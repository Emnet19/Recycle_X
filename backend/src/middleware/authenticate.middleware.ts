import { Request, Response, NextFunction } from 'express';
import { JwtSecurity } from '../security/jwt.security';
import { AppError } from '../shared/errors/app-error';
import { HttpStatus } from '../constants/http-status.constant';
import { ErrorCode } from '../constants/error-codes.constant';

export function authenticate(req: Request, _res: Response, next: NextFunction): void {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new AppError(
      'Authentication token required. Format: Bearer <token>',
      HttpStatus.UNAUTHORIZED,
      ErrorCode.UNAUTHORIZED
    );
  }

  const token = authHeader.split(' ')[1];

  try {
    const payload = JwtSecurity.verifyAccessToken(token);
    req.user = payload;
    req.token = token;
    next();
  } catch (err: unknown) {
    const isExpired = err instanceof Error && err.name === 'TokenExpiredError';
    throw new AppError(
      isExpired ? 'Access token has expired.' : 'Invalid access token.',
      HttpStatus.UNAUTHORIZED,
      isExpired ? ErrorCode.TOKEN_EXPIRED : ErrorCode.TOKEN_INVALID
    );
  }
}

