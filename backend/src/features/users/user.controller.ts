import { Request, Response, NextFunction } from 'express';
import { userService } from './user.service';
import { ApiResponse } from '../../shared/utils/api-response';
import { AccountStatus } from './user.types';

export class UserController {
  async getOwnProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const user = await userService.getProfile(req.user!.id);
      ApiResponse.success(res, user);
    } catch (error) {
      next(error);
    }
  }

  async updateOwnProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const updated = await userService.updateProfile(req.user!.id, req.body);
      ApiResponse.success(res, updated, 'Profile updated successfully.');
    } catch (error) {
      next(error);
    }
  }

  async listUsers(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const page = Math.max(1, Number(req.query.page) || 1);
      const limit = Math.min(100, Math.max(1, Number(req.query.limit) || 20));
      const result = await userService.listUsers(page, limit);
      ApiResponse.success(res, result.users, undefined, 200, {
        page: result.page,
        limit,
        total: result.total,
        totalPages: result.totalPages,
      });
    } catch (error) {
      next(error);
    }
  }

  async updateStatus(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const { status, reason } = req.body as { status: AccountStatus; reason: string };
      const updated = await userService.updateStatus(id, req.user!.id, status, reason);
      ApiResponse.success(res, updated, 'User status updated successfully.');
    } catch (error) {
      next(error);
    }
  }
}

export const userController = new UserController();
