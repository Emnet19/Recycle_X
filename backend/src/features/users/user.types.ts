import { Document } from 'mongoose';
import { UserRole } from '../../constants/roles.constant';

export enum AccountStatus {
  PENDING_APPROVAL = 'PENDING_APPROVAL',
  ACTIVE = 'ACTIVE',
  SUSPENDED = 'SUSPENDED',
  DEACTIVATED = 'DEACTIVATED',
}

export interface IUser extends Document {
  email: string;
  passwordHash: string;
  role: UserRole;
  status: AccountStatus;
  fullName?: string;
  phoneNumber: string;
  zoneOrSubcity?: string;
  companyName?: string;
  registrationNumber?: string;
  tokenVersion: number;
  failedLoginAttempts: number;
  lockoutUntil?: Date;
  mfaEnabled: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface UserProfileDto {
  fullName?: string;
  phoneNumber?: string;
  zoneOrSubcity?: string;
}

