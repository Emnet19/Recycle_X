import { CollectionModel, ICollection, PickupStatus, PickupType, WasteCategory } from './collection.model';
import { WalletModel } from '../wallet/wallet.model';
import { TransactionModel, TransactionType } from '../wallet/transaction.model';
import { auditService } from '../audit/audit.service';
import { AuditAction } from '../audit/audit-log.model';
import { AppError } from '../../shared/errors/app-error';
import { HttpStatus } from '../../constants/http-status.constant';
import { ErrorCode } from '../../constants/error-codes.constant';

const PICKUP_EARN_COINS = 50;
const EMERGENCY_PICKUP_FEE_COINS = 50;

interface CreatePickupDto {
  type?: PickupType;
  categories: WasteCategory[];
  estimatedWeightKg?: number;
  scheduledDate: string | Date;
  address: {
    street: string;
    subcity: string;
    kebele?: string;
    coordinates?: { lat: number; lng: number };
  };
  notes?: string;
}

export class CollectionService {
  async createPickup(customerId: string, dto: CreatePickupDto): Promise<ICollection> {
    // Emergency pickups cost 50 EcoCoins
    if (dto.type === PickupType.EMERGENCY) {
      const wallet = await WalletModel.findOne({ userId: customerId });
      if (!wallet || wallet.balance < EMERGENCY_PICKUP_FEE_COINS) {
        throw new AppError(
          `Emergency pickup requires ${EMERGENCY_PICKUP_FEE_COINS} EcoCoins (you have ${wallet?.balance ?? 0}).`,
          HttpStatus.BAD_REQUEST,
          ErrorCode.CONFLICT
        );
      }
      // Deduct fee
      wallet.balance -= EMERGENCY_PICKUP_FEE_COINS;
      wallet.totalSpent += EMERGENCY_PICKUP_FEE_COINS;
      await wallet.save();

      await TransactionModel.create({
        walletId: wallet._id,
        userId: customerId,
        type: TransactionType.EMERGENCY_PICKUP_FEE,
        amount: -EMERGENCY_PICKUP_FEE_COINS,
        balanceAfter: wallet.balance,
        description: 'Emergency pickup request fee',
      });
    }

    const addressData = {
      street: dto.address.street,
      subcity: dto.address.subcity,
      kebele: dto.address.kebele,
      ...(dto.address.coordinates
        ? {
            coordinates: {
              type: 'Point',
              coordinates: [dto.address.coordinates.lng, dto.address.coordinates.lat] as [number, number],
            },
          }
        : {}),
    };

    const pickup = await CollectionModel.create({
      customerId,
      type: dto.type ?? PickupType.SCHEDULED,
      categories: dto.categories,
      estimatedWeightKg: dto.estimatedWeightKg,
      scheduledDate: new Date(dto.scheduledDate),
      address: addressData,
      notes: dto.notes,
      status: PickupStatus.PENDING,
    });

    void auditService.log({
      action: AuditAction.PICKUP_CREATED,
      actorId: customerId,
      targetId: pickup._id.toString(),
      targetModel: 'Collection',
      metadata: { type: pickup.type, categories: pickup.categories },
    });

    return pickup;
  }

  async listCustomerPickups(customerId: string): Promise<ICollection[]> {
    return CollectionModel.find({ customerId })
      .sort({ scheduledDate: -1 })
      .populate('assignedCollectorId', 'fullName phoneNumber');
  }

  async listAssignedPickups(collectorId: string): Promise<ICollection[]> {
    return CollectionModel.find({ assignedCollectorId: collectorId })
      .sort({ scheduledDate: -1 })
      .populate('customerId', 'fullName phoneNumber');
  }

  async listPendingPickups(): Promise<ICollection[]> {
    return CollectionModel.find({ status: PickupStatus.PENDING })
      .sort({ scheduledDate: 1 })
      .populate('customerId', 'fullName phoneNumber');
  }

  async acceptPickup(pickupId: string, collectorId: string): Promise<ICollection> {
    const pickup = await CollectionModel.findById(pickupId);
    if (!pickup) {
      throw new AppError('Pickup request not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }
    if (pickup.status !== PickupStatus.PENDING) {
      throw new AppError(
        `Cannot accept a pickup with status '${pickup.status}'.`,
        HttpStatus.BAD_REQUEST,
        ErrorCode.CONFLICT
      );
    }

    pickup.assignedCollectorId = collectorId as unknown as typeof pickup.assignedCollectorId;
    pickup.status = PickupStatus.ACCEPTED;
    await pickup.save();

    void auditService.log({
      action: AuditAction.PICKUP_ACCEPTED,
      actorId: collectorId,
      targetId: pickupId,
      targetModel: 'Collection',
    });

    return pickup;
  }

  async updateStatus(
    pickupId: string,
    actorId: string,
    status: PickupStatus,
    actualWeightKg?: number
  ): Promise<ICollection> {
    const pickup = await CollectionModel.findById(pickupId);
    if (!pickup) {
      throw new AppError('Pickup request not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }

    pickup.status = status;
    if (actualWeightKg) pickup.estimatedWeightKg = actualWeightKg;

    if (status === PickupStatus.COMPLETED) {
      pickup.completedAt = new Date();

      // Award EcoCoins to customer on completion
      const coinsEarned = PICKUP_EARN_COINS;
      pickup.coinRewardEarned = coinsEarned;

      const wallet = await WalletModel.findOneAndUpdate(
        { userId: pickup.customerId },
        { $inc: { balance: coinsEarned, totalEarned: coinsEarned } },
        { new: true }
      );

      if (wallet) {
        await TransactionModel.create({
          walletId: wallet._id,
          userId: pickup.customerId,
          type: TransactionType.EARN,
          amount: coinsEarned,
          balanceAfter: wallet.balance,
          description: `Recycling reward for pickup #${pickupId.slice(-6).toUpperCase()}`,
          referenceId: pickupId,
        });
      }

      void auditService.log({
        action: AuditAction.PICKUP_COMPLETED,
        actorId,
        targetId: pickupId,
        targetModel: 'Collection',
        metadata: { coinsEarned, customerId: pickup.customerId.toString() },
      });
    } else if (status === PickupStatus.CANCELLED) {
      void auditService.log({
        action: AuditAction.PICKUP_CANCELLED,
        actorId,
        targetId: pickupId,
        targetModel: 'Collection',
      });
    }

    await pickup.save();
    return pickup;
  }
}

export const collectionService = new CollectionService();
