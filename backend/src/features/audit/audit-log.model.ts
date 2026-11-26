import { Schema, model, Document, Types } from 'mongoose';

export enum AuditAction {
  USER_REGISTERED = 'USER_REGISTERED',
  USER_LOGGED_IN = 'USER_LOGGED_IN',
  USER_LOGGED_OUT = 'USER_LOGGED_OUT',
  LOGIN_FAILED = 'LOGIN_FAILED',
  ACCOUNT_LOCKED = 'ACCOUNT_LOCKED',
  ROLE_CHANGED = 'ROLE_CHANGED',
  ROLE_CHANGE_REQUESTED = 'ROLE_CHANGE_REQUESTED',
  ROLE_CHANGE_APPROVED = 'ROLE_CHANGE_APPROVED',
  ROLE_CHANGE_REJECTED = 'ROLE_CHANGE_REJECTED',
  ACCOUNT_STATUS_CHANGED = 'ACCOUNT_STATUS_CHANGED',
  PICKUP_CREATED = 'PICKUP_CREATED',
  PICKUP_ACCEPTED = 'PICKUP_ACCEPTED',
  PICKUP_COMPLETED = 'PICKUP_COMPLETED',
  PICKUP_CANCELLED = 'PICKUP_CANCELLED',
  WALLET_REDEEMED = 'WALLET_REDEEMED',
  WALLET_ADJUSTED = 'WALLET_ADJUSTED',
  PROFILE_UPDATED = 'PROFILE_UPDATED',
  SYSTEM_SETTING_CHANGED = 'SYSTEM_SETTING_CHANGED',
}

export interface IAuditLog extends Document {
  action: AuditAction;
  actorId?: Types.ObjectId;
  targetId?: Types.ObjectId;
  targetModel?: string;
  ipAddress?: string;
  userAgent?: string;
  metadata?: Record<string, unknown>;
  createdAt: Date;
}

const AuditLogSchema = new Schema<IAuditLog>(
  {
    action: {
      type: String,
      enum: Object.values(AuditAction),
      required: true,
      index: true,
    },
    actorId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      index: true,
    },
    targetId: {
      type: Schema.Types.ObjectId,
      index: true,
    },
    targetModel: {
      type: String,
    },
    ipAddress: {
      type: String,
    },
    userAgent: {
      type: String,
    },
    metadata: {
      type: Schema.Types.Mixed,
    },
  },
  {
    timestamps: { createdAt: true, updatedAt: false },
    versionKey: false,
  }
);

// Immutable audit logs – prevent updates and deletes at the schema level
AuditLogSchema.pre('findOneAndUpdate', function () {
  throw new Error('Audit logs are immutable and cannot be modified.');
});

export const AuditLogModel = model<IAuditLog>('AuditLog', AuditLogSchema);

