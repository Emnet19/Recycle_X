import { AuditLogModel, AuditAction, IAuditLog } from './audit-log.model';
import { logger } from '../../config/logger.config';

export class AuditService {
  async log(params: {
    action: AuditAction;
    actorId?: string;
    targetId?: string;
    targetModel?: string;
    ipAddress?: string;
    userAgent?: string;
    metadata?: Record<string, unknown>;
  }): Promise<void> {
    try {
      await AuditLogModel.create(params);
    } catch (error) {
      // Audit failures must never crash the main request flow
      logger.error('Failed to write audit log:', error);
    }
  }

  async listLogs(page = 1, limit = 50): Promise<{ logs: IAuditLog[]; total: number }> {
    const skip = (page - 1) * limit;
    const [logs, total] = await Promise.all([
      AuditLogModel.find().sort({ createdAt: -1 }).skip(skip).limit(limit),
      AuditLogModel.countDocuments(),
    ]);
    return { logs, total };
  }

  async listUserActivity(userId: string, limit = 30): Promise<IAuditLog[]> {
    return AuditLogModel.find({
      $or: [{ actorId: userId }, { targetId: userId }],
    })
      .sort({ createdAt: -1 })
      .limit(limit);
  }
}

export const auditService = new AuditService();

