import { Request, Response, NextFunction } from 'express';
import { auditService } from './audit.service';
import { ApiResponse } from '../../shared/utils/api-response';

export class AuditController {
  async listLogs(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const page = Number(req.query.page) || 1;
      const limit = Number(req.query.limit) || 50;
      const result = await auditService.listLogs(page, limit);
      ApiResponse.success(res, result.logs, undefined, 200, {
        page,
        limit,
        total: result.total,
      });
    } catch (error) {
      next(error);
    }
  }

  async getUserActivity(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { userId } = req.params;
      const limit = Number(req.query.limit) || 30;
      const logs = await auditService.listUserActivity(userId, limit);
      ApiResponse.success(res, logs);
    } catch (error) {
      next(error);
    }
  }
}

export const auditController = new AuditController();

