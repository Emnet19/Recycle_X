import express, { Application } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { env } from './config/env.config';
import { corsOptions } from './security/cors.security';
import { requestLogger } from './middleware/request-logger.middleware';
import { errorHandler } from './middleware/error-handler.middleware';
import { notFoundHandler } from './middleware/not-found.middleware';
import { apiRouter } from './routes';

export function createApp(): Application {
  const app = express();

  // ── Security Headers ─────────────────────────────────────────────────────
  app.use(helmet());
  app.use(cors(corsOptions));

  // ── Body Parsers ─────────────────────────────────────────────────────────
  app.use(express.json({ limit: '10kb' }));
  app.use(express.urlencoded({ extended: true, limit: '10kb' }));

  // ── Request Logging ──────────────────────────────────────────────────────
  app.use(requestLogger);

  // ── API Routes ───────────────────────────────────────────────────────────
  app.use(env.API_PREFIX, apiRouter);

  // ── 404 Handler ──────────────────────────────────────────────────────────
  app.use(notFoundHandler);

  // ── Global Error Handler ─────────────────────────────────────────────────
  app.use(errorHandler);

  return app;
}

