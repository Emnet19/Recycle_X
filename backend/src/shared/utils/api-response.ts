import { Response } from 'express';
import { HttpStatus, HttpStatusCode } from '../../constants/http-status.constant';

export interface ApiResponseEnvelope<T> {
  success: boolean;
  message?: string;
  data?: T;
  meta?: Record<string, unknown>;
  timestamp: string;
}

export class ApiResponse {
  static success<T>(
    res: Response,
    data?: T,
    message?: string,
    statusCode: HttpStatusCode = HttpStatus.OK,
    meta?: Record<string, unknown>
  ): Response {
    const payload: ApiResponseEnvelope<T> = {
      success: true,
      ...(message && { message }),
      ...(data !== undefined && { data }),
      ...(meta && { meta }),
      timestamp: new Date().toISOString(),
    };
    return res.status(statusCode).json(payload);
  }

  static created<T>(res: Response, data?: T, message?: string): Response {
    return this.success(res, data, message, HttpStatus.CREATED);
  }

  static noContent(res: Response): Response {
    return res.status(HttpStatus.NO_CONTENT).send();
  }
}

