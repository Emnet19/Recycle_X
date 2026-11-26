import { Request, Response } from 'express';
import { HttpStatus } from '../constants/http-status.constant';
import { ErrorCode } from '../constants/error-codes.constant';

export function notFoundHandler(req: Request, res: Response): void {
  res.status(HttpStatus.NOT_FOUND).json({
    success: false,
    errorCode: ErrorCode.NOT_FOUND,
    message: `Route '${req.method} ${req.originalUrl}' was not found on this server.`,
    timestamp: new Date().toISOString(),
  });
}

