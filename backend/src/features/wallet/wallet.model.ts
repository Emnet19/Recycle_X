import { Schema, model, Document, Types } from 'mongoose';

export interface IWallet extends Document {
  userId: Types.ObjectId;
  balance: number;
  totalEarned: number;
  totalSpent: number;
  isActive: boolean;
  version: number; // Optimistic concurrency control
  createdAt: Date;
  updatedAt: Date;
}

const WalletSchema = new Schema<IWallet>(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
      index: true,
    },
    balance: {
      type: Number,
      default: 100, // Sign-up welcome reward as seen in frontend
      min: 0,
    },
    totalEarned: {
      type: Number,
      default: 100,
    },
    totalSpent: {
      type: Number,
      default: 0,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    version: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

export const WalletModel = model<IWallet>('Wallet', WalletSchema);

