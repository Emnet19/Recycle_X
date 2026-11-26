import { Schema, model, Document, Types } from 'mongoose';

export enum TransactionType {
  EARN = 'EARN',
  REWARD_REDEMPTION = 'REWARD_REDEMPTION',
  EMERGENCY_PICKUP_FEE = 'EMERGENCY_PICKUP_FEE',
  TRANSFER_IN = 'TRANSFER_IN',
  TRANSFER_OUT = 'TRANSFER_OUT',
  ADMIN_ADJUSTMENT = 'ADMIN_ADJUSTMENT',
}

export interface ITransaction extends Document {
  walletId: Types.ObjectId;
  userId: Types.ObjectId;
  type: TransactionType;
  amount: number;
  balanceAfter: number;
  description: string;
  referenceId?: string;
  createdAt: Date;
}

const TransactionSchema = new Schema<ITransaction>(
  {
    walletId: {
      type: Schema.Types.ObjectId,
      ref: 'Wallet',
      required: true,
      index: true,
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    type: {
      type: String,
      enum: Object.values(TransactionType),
      required: true,
    },
    amount: {
      type: Number,
      required: true,
    },
    balanceAfter: {
      type: Number,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    referenceId: {
      type: String,
    },
  },
  {
    timestamps: { createdAt: true, updatedAt: false },
    versionKey: false,
  }
);

export const TransactionModel = model<ITransaction>('Transaction', TransactionSchema);

