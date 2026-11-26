import { Request, Response, NextFunction } from 'express';
import { UserRole } from '../constants/roles.constant';
import { AppError } from '../shared/errors/app-error';
import { HttpStatus } from '../constants/http-status.constant';
import { ErrorCode } from '../constants/error-codes.constant';

export function authorizeRoles(...allowedRoles: UserRole[]) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    if (!req.user) {
      throw new AppError('Authentication required.', HttpStatus.UNAUTHORIZED, ErrorCode.UNAUTHORIZED);
    }

    if (!allowedRoles.includes(req.user.role)) {
      throw new AppError(
        `Access denied. Role '${req.user.role}' lacks permission for this action.`,
        HttpStatus.FORBIDDEN,
        ErrorCode.FORBIDDEN
      );
    }

    next();
  };
}

