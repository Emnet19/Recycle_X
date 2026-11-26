import { Schema, model, Document, Types } from 'mongoose';

export enum PickupType {
  SCHEDULED = 'SCHEDULED',
  EMERGENCY = 'EMERGENCY',
}

export enum PickupStatus {
  PENDING = 'PENDING',
  ACCEPTED = 'ACCEPTED',
  IN_PROGRESS = 'IN_PROGRESS',
  COMPLETED = 'COMPLETED',
  CANCELLED = 'CANCELLED',
}

export enum WasteCategory {
  PLASTIC = 'plastic',
  PAPER = 'paper',
  METAL = 'metal',
  ORGANIC = 'organic',
  ELECTRONIC = 'electronic',
}

export interface ICollection extends Document {
  customerId: Types.ObjectId;
  assignedCollectorId?: Types.ObjectId;
  type: PickupType;
  status: PickupStatus;
  categories: WasteCategory[];
  estimatedWeightKg?: number;
  scheduledDate: Date;
  address: {
    street: string;
    subcity: string;
    kebele?: string;
    coordinates?: {
      type: string;
      coordinates: [number, number]; // [lng, lat]
    };
  };
  notes?: string;
  coinRewardEarned?: number;
  completedAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const CollectionSchema = new Schema<ICollection>(
  {
    customerId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    assignedCollectorId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      index: true,
    },
    type: {
      type: String,
      enum: Object.values(PickupType),
      default: PickupType.SCHEDULED,
    },
    status: {
      type: String,
      enum: Object.values(PickupStatus),
      default: PickupStatus.PENDING,
      index: true,
    },
    categories: [
      {
        type: String,
        enum: Object.values(WasteCategory),
      },
    ],
    estimatedWeightKg: {
      type: Number,
    },
    scheduledDate: {
      type: Date,
      required: true,
    },
    address: {
      street: { type: String, required: true },
      subcity: { type: String, required: true },
      kebele: { type: String },
      coordinates: {
        type: { type: String, default: 'Point' },
        coordinates: { type: [Number], index: '2dsphere' },
      },
    },
    notes: {
      type: String,
    },
    coinRewardEarned: {
      type: Number,
      default: 0,
    },
    completedAt: {
      type: Date,
    },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

export const CollectionModel = model<ICollection>('Collection', CollectionSchema);

