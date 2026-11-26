import { RoleModel, IRole } from './role.model';
import { RoleChangeRequestModel, IRoleChangeRequest, RoleChangeStatus } from './role-change-request.model';
import { UserModel } from '../users/user.model';
import { auditService } from '../audit/audit.service';
import { AuditAction } from '../audit/audit-log.model';
import { UserRole } from '../../constants/roles.constant';
import { AppError } from '../../shared/errors/app-error';
import { HttpStatus } from '../../constants/http-status.constant';
import { ErrorCode } from '../../constants/error-codes.constant';
import { Types } from 'mongoose';

export class RoleService {
  async listRoles(): Promise<IRole[]> {
    return RoleModel.find();
  }

  async createChangeRequest(
    requesterId: string,
    targetUserId: string,
    requestedRole: UserRole,
    justification: string
  ): Promise<IRoleChangeRequest> {
    const targetUser = await UserModel.findById(targetUserId).select('role email');
    if (!targetUser) {
      throw new AppError('Target user not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }
    if (targetUser.role === requestedRole) {
      throw new AppError('User already has this role.', HttpStatus.BAD_REQUEST, ErrorCode.CONFLICT);
    }

    const request = await RoleChangeRequestModel.create({
      targetUserId,
      requesterId,
      currentRole: targetUser.role,
      requestedRole,
      justification,
      status: RoleChangeStatus.PENDING,
    });

    void auditService.log({
      action: AuditAction.ROLE_CHANGE_REQUESTED,
      actorId: requesterId,
      targetId: targetUserId,
      targetModel: 'User',
      metadata: {
        requestId: request._id.toString(),
        currentRole: targetUser.role,
        requestedRole,
      },
    });

    return request;
  }

  async reviewChangeRequest(
    requestId: string,
    reviewerId: string,
    approved: boolean,
    reviewNotes: string
  ): Promise<IRoleChangeRequest> {
    const request = await RoleChangeRequestModel.findById(requestId);
    if (!request) {
      throw new AppError('Role change request not found.', HttpStatus.NOT_FOUND, ErrorCode.NOT_FOUND);
    }
    if (request.status !== RoleChangeStatus.PENDING) {
      throw new AppError('Request has already been processed.', HttpStatus.BAD_REQUEST, ErrorCode.CONFLICT);
    }

    // ── Separation of Duties: requester cannot approve their own request ──
    if (request.requesterId.toString() === reviewerId) {
      throw new AppError(
        'Separation of Duties violation: the requester cannot review their own request.',
        HttpStatus.FORBIDDEN,
        ErrorCode.FORBIDDEN
      );
    }

    request.status = approved ? RoleChangeStatus.APPROVED : RoleChangeStatus.REJECTED;
    request.reviewedBy = new Types.ObjectId(reviewerId) as unknown as typeof request.reviewedBy;
    request.reviewedAt = new Date();
    request.reviewNotes = reviewNotes;
    await request.save();

    if (approved) {
      await UserModel.findByIdAndUpdate(request.targetUserId, {
        $set: { role: request.requestedRole },
        $inc: { tokenVersion: 1 }, // Invalidate existing tokens after role change
      });

      void auditService.log({
        action: AuditAction.ROLE_CHANGED,
        actorId: reviewerId,
        targetId: request.targetUserId.toString(),
        targetModel: 'User',
        metadata: {
          from: request.currentRole,
          to: request.requestedRole,
          requestId,
        },
      });
    }

    void auditService.log({
      action: approved ? AuditAction.ROLE_CHANGE_APPROVED : AuditAction.ROLE_CHANGE_REJECTED,
      actorId: reviewerId,
      targetId: requestId,
      targetModel: 'RoleChangeRequest',
      metadata: { reviewNotes },
    });

    return request;
  }
}

export const roleService = new RoleService();
