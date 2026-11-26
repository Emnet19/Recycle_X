import { Schema, model, Document, Types } from 'mongoose';
import { UserRole, ALL_ROLES } from '../../constants/roles.constant';

export enum RoleChangeStatus {
  PENDING = 'PENDING',
  APPROVED = 'APPROVED',
  REJECTED = 'REJECTED',
}

export interface IRoleChangeRequest extends Document {
  targetUserId: Types.ObjectId;
  requesterId: Types.ObjectId;
  currentRole: UserRole;
  requestedRole: UserRole;
  justification: string;
  status: RoleChangeStatus;
  reviewedBy?: Types.ObjectId;
  reviewedAt?: Date;
  reviewNotes?: string;
  createdAt: Date;
  updatedAt: Date;
}

const RoleChangeRequestSchema = new Schema<IRoleChangeRequest>(
  {
    targetUserId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    requesterId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    currentRole: {
      type: String,
      enum: ALL_ROLES,
      required: true,
    },
    requestedRole: {
      type: String,
      enum: ALL_ROLES,
      required: true,
    },
    justification: {
      type: String,
      required: true,
      minlength: 10,
    },
    status: {
      type: String,
      enum: Object.values(RoleChangeStatus),
      default: RoleChangeStatus.PENDING,
      index: true,
    },
    reviewedBy: {
      type: Schema.Types.ObjectId,
      ref: 'User',
    },
    reviewedAt: {
      type: Date,
    },
    reviewNotes: {
      type: String,
    },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

export const RoleChangeRequestModel = model<IRoleChangeRequest>(
  'RoleChangeRequest',
  RoleChangeRequestSchema
);

