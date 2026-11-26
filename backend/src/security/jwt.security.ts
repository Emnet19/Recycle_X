import jwt from 'jsonwebtoken';
import { env } from '../config/env.config';
import { AuthenticatedUser } from '../shared/types/express';

export interface JwtTokenPair {
  accessToken: string;
  refreshToken: string;
}

export class JwtSecurity {
  static generateTokenPair(user: AuthenticatedUser): JwtTokenPair {
    const accessToken = jwt.sign(
      { id: user.id, email: user.email, role: user.role, tokenVersion: user.tokenVersion ?? 0 },
      env.JWT_ACCESS_SECRET,
      { expiresIn: env.JWT_ACCESS_EXPIRES_IN as jwt.SignOptions['expiresIn'] }
    );

    const refreshToken = jwt.sign(
      { id: user.id, email: user.email, role: user.role, tokenVersion: user.tokenVersion ?? 0 },
      env.JWT_REFRESH_SECRET,
      { expiresIn: env.JWT_REFRESH_EXPIRES_IN as jwt.SignOptions['expiresIn'] }
    );

    return { accessToken, refreshToken };
  }

  static verifyAccessToken(token: string): AuthenticatedUser {
    return jwt.verify(token, env.JWT_ACCESS_SECRET) as AuthenticatedUser;
  }

  static verifyRefreshToken(token: string): AuthenticatedUser {
    return jwt.verify(token, env.JWT_REFRESH_SECRET) as AuthenticatedUser;
  }
}

