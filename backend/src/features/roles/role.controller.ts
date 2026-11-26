import { Request, Response, NextFunction } from 'express';
import { roleService } from './role.service';
import { ApiResponse } from '../../shared/utils/api-response';

export class RoleController {
  async listRoles(_req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const roles = await roleService.listRoles();
      ApiResponse.success(res, roles);
    } catch (error) {
      next(error);
    }
  }

  async createChangeRequest(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { targetUserId, requestedRole, justification } = req.body;
      const request = await roleService.createChangeRequest(
        req.user!.id,
        targetUserId,
        requestedRole,
        justification
      );
      ApiResponse.created(res, request, 'Role change request submitted for review.');
    } catch (error) {
      next(error);
    }
  }

  async reviewChangeRequest(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const { approved, reviewNotes } = req.body;
      const result = await roleService.reviewChangeRequest(id, req.user!.id, approved, reviewNotes);
      ApiResponse.success(
        res,
        result,
        approved ? 'Role change approved.' : 'Role change rejected.'
      );
    } catch (error) {
      next(error);
    }
  }
}

export const roleController = new RoleController();

