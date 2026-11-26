import { Request, Response, NextFunction } from 'express';
import { authService } from './auth.service';
import { ApiResponse } from '../../shared/utils/api-response';

export class AuthController {
  async register(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await authService.register(req.body);
      ApiResponse.created(res, result, 'Account created successfully. Welcome to RecycleX!');
    } catch (error) {
      next(error);
    }
  }

  async login(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const ipAddress = req.ip ?? req.socket.remoteAddress;
      const result = await authService.login(req.body, ipAddress);
      ApiResponse.success(res, result, 'Login successful.');
    } catch (error) {
      next(error);
    }
  }

  async refreshToken(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await authService.refreshToken(req.body.refreshToken as string);
      ApiResponse.success(res, result, 'Access token refreshed.');
    } catch (error) {
      next(error);
    }
  }

  async logout(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (req.user) {
        await authService.logout(req.user.id);
      }
      ApiResponse.noContent(res);
    } catch (error) {
      next(error);
    }
  }

  async getMe(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      // User is already attached by authenticate middleware
      ApiResponse.success(res, req.user, 'Authenticated user info.');
    } catch (error) {
      next(error);
    }
  }
}

export const authController = new AuthController();
