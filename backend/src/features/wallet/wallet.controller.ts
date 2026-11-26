import { Request, Response, NextFunction } from 'express';
import { walletService } from './wallet.service';
import { ApiResponse } from '../../shared/utils/api-response';

export class WalletController {
  async getBalance(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const wallet = await walletService.getWallet(req.user!.id);
      ApiResponse.success(res, wallet);
    } catch (error) {
      next(error);
    }
  }

  async listTransactions(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const page = Math.max(1, Number(req.query.page) || 1);
      const limit = Math.min(50, Math.max(1, Number(req.query.limit) || 20));
      const result = await walletService.listTransactions(req.user!.id, page, limit);
      ApiResponse.success(res, result.transactions, undefined, 200, {
        page,
        limit,
        total: result.total,
      });
    } catch (error) {
      next(error);
    }
  }

  async redeemReward(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { coinsCost, itemTitle, rewardId } = req.body as {
        coinsCost: number;
        itemTitle: string;
        rewardId: string;
      };
      const wallet = await walletService.redeemReward(req.user!.id, coinsCost, itemTitle, rewardId);
      ApiResponse.success(res, wallet, `Successfully redeemed "${itemTitle}" for ${coinsCost} EcoCoins.`);
    } catch (error) {
      next(error);
    }
  }
}

export const walletController = new WalletController();
