import { Schema, model, Document } from 'mongoose';
import { UserRole, ALL_ROLES } from '../../constants/roles.constant';
import { Permission } from '../../constants/permissions.constant';

export interface IRole extends Document {
  name: UserRole;
  description: string;
  permissions: Permission[];
  isSystem: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const RoleSchema = new Schema<IRole>(
  {
    name: {
      type: String,
      enum: ALL_ROLES,
      required: true,
      unique: true,
      index: true,
    },
    description: {
      type: String,
      required: true,
    },
    permissions: [
      {
        type: String,
        enum: Object.values(Permission),
      },
    ],
    isSystem: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

export const RoleModel = model<IRole>('Role', RoleSchema);

