import { UserModel } from './user.model';
import { IUser, UserProfileDto, AccountStatus } from './user.types';
import { auditService } from '../audit/audit.service';
import { AuditAction } from '../audit/audit-log.model';
import { AppError } from '../../shared/errors/app-error';
import { HttpStatus } from '../../constants/http-status.constant';
import { ErrorCode } from '../../constants/error-codes.constant';

export class UserService {
  async getProfile(userId: string): Promise<IUser> {
    const user = await UserModel.findById(userId).select('-passwordHash');
    if (!user) {
      throw new AppError('User not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }
    return user;
  }

  async updateProfile(userId: string, dto: UserProfileDto): Promise<IUser> {
    const user = await UserModel.findByIdAndUpdate(
      userId,
      { $set: dto },
      { new: true, runValidators: true }
    ).select('-passwordHash');

    if (!user) {
      throw new AppError('User not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }

    void auditService.log({
      action: AuditAction.PROFILE_UPDATED,
      actorId: userId,
      targetId: userId,
      targetModel: 'User',
      metadata: { fieldsUpdated: Object.keys(dto) },
    });

    return user;
  }

  async listUsers(
    page = 1,
    limit = 20
  ): Promise<{ users: IUser[]; total: number; page: number; totalPages: number }> {
    const skip = (page - 1) * limit;
    const [users, total] = await Promise.all([
      UserModel.find().select('-passwordHash').sort({ createdAt: -1 }).skip(skip).limit(limit),
      UserModel.countDocuments(),
    ]);
    return { users, total, page, totalPages: Math.ceil(total / limit) };
  }

  async updateStatus(userId: string, actorId: string, status: AccountStatus, reason: string): Promise<IUser> {
    const user = await UserModel.findByIdAndUpdate(
      userId,
      { $set: { status } },
      { new: true }
    ).select('-passwordHash');

    if (!user) {
      throw new AppError('User not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }

    void auditService.log({
      action: AuditAction.ACCOUNT_STATUS_CHANGED,
      actorId,
      targetId: userId,
      targetModel: 'User',
      metadata: { newStatus: status, reason },
    });

    return user;
  }
}

export const userService = new UserService();
