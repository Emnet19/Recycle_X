import { Request, Response, NextFunction, ErrorRequestHandler } from 'express';
import { AppError } from '../shared/errors/app-error';
import { HttpStatus } from '../constants/http-status.constant';
import { ErrorCode } from '../constants/error-codes.constant';
import { logger } from '../config/logger.config';
import { env } from '../config/env.config';

export const errorHandler: ErrorRequestHandler = (
  err: Error | AppError,
  req: Request,
  res: Response,
  _next: NextFunction
): void => {
  if (err instanceof AppError) {
    logger.warn(`Operational Error [${err.errorCode}]: ${err.message}`, {
      path: req.path,
      method: req.method,
      details: err.details,
    });

    res.status(err.statusCode).json({
      success: false,
      errorCode: err.errorCode,
      message: err.message,
      ...(err.details ? { details: err.details } : {}),
      timestamp: new Date().toISOString(),
    });
    return;
  }

  logger.error(`Unhandled Exception on ${req.method} ${req.path}:`, err);

  res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
    success: false,
    errorCode: ErrorCode.INTERNAL_ERROR,
    message: env.NODE_ENV === 'production' ? 'Internal server error.' : err.message,
    ...(env.NODE_ENV !== 'production' && { stack: err.stack }),
    timestamp: new Date().toISOString(),
  });
};

