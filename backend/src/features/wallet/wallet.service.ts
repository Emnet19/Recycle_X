import mongoose from 'mongoose';
import { WalletModel, IWallet } from './wallet.model';
import { TransactionModel, ITransaction, TransactionType } from './transaction.model';
import { auditService } from '../audit/audit.service';
import { AuditAction } from '../audit/audit-log.model';
import { AppError } from '../../shared/errors/app-error';
import { HttpStatus } from '../../constants/http-status.constant';
import { ErrorCode } from '../../constants/error-codes.constant';

export class WalletService {
  /** Get or lazily create wallet (idempotent). */
  async getWallet(userId: string): Promise<IWallet> {
    let wallet = await WalletModel.findOne({ userId });
    if (!wallet) {
      wallet = await WalletModel.create({ userId, balance: 0, totalEarned: 0 });
    }
    return wallet;
  }

  async listTransactions(userId: string, page = 1, limit = 20): Promise<{ transactions: ITransaction[]; total: number }> {
    const skip = (page - 1) * limit;
    const [transactions, total] = await Promise.all([
      TransactionModel.find({ userId }).sort({ createdAt: -1 }).skip(skip).limit(limit),
      TransactionModel.countDocuments({ userId }),
    ]);
    return { transactions, total };
  }

  async redeemReward(
    userId: string,
    coinsCost: number,
    itemTitle: string,
    rewardId: string
  ): Promise<IWallet> {
    const session = await mongoose.startSession();
    let updatedWallet!: IWallet;

    try {
      await session.withTransaction(async () => {
        const wallet = await WalletModel.findOne({ userId }).session(session);
        if (!wallet) {
          throw new AppError('Wallet not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
        }
        if (wallet.balance < coinsCost) {
          throw new AppError(
            `Insufficient EcoCoins. Balance: ${wallet.balance}, Required: ${coinsCost}.`,
            HttpStatus.BAD_REQUEST,
            ErrorCode.CONFLICT
          );
        }

        wallet.balance -= coinsCost;
        wallet.totalSpent += coinsCost;
        await wallet.save({ session });

        await TransactionModel.create(
          [
            {
              walletId: wallet._id,
              userId,
              type: TransactionType.REWARD_REDEMPTION,
              amount: -coinsCost,
              balanceAfter: wallet.balance,
              description: `Redeemed: ${itemTitle}`,
              referenceId: rewardId,
            },
          ],
          { session }
        );

        updatedWallet = wallet;
      });
    } finally {
      await session.endSession();
    }

    void auditService.log({
      action: AuditAction.WALLET_REDEEMED,
      actorId: userId,
      metadata: { coinsCost, itemTitle, rewardId },
    });

    return updatedWallet;
  }
}

export const walletService = new WalletService();
