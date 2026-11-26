import { createApp } from './app';
import { connectDatabase } from './database/connection';
import { env } from './config/env.config';
import { logger } from './config/logger.config';

async function bootstrap(): Promise<void> {
  // Connect to MongoDB (non-fatal if unavailable during development)
  await connectDatabase();

  const app = createApp();

  const server = app.listen(env.PORT, () => {
    logger.info(`🚀 RecycleX API server started`);
    logger.info(`   Environment : ${env.NODE_ENV}`);
    logger.info(`   Port        : ${env.PORT}`);
    logger.info(`   Base URL    : http://localhost:${env.PORT}${env.API_PREFIX}`);
    logger.info(`   Docs        : http://localhost:${env.PORT}${env.API_PREFIX}/docs`);
    logger.info(`   Health      : http://localhost:${env.PORT}${env.API_PREFIX}/health`);
  });

  // ── Graceful Shutdown ─────────────────────────────────────────────────────
  const shutdown = (signal: string) => {
    logger.info(`Received ${signal}. Shutting down gracefully…`);
    server.close(() => {
      logger.info('HTTP server closed.');
      process.exit(0);
    });
  };

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));

  process.on('unhandledRejection', (reason: unknown) => {
    logger.error('Unhandled Promise Rejection:', reason);
  });

  process.on('uncaughtException', (err: Error) => {
    logger.error('Uncaught Exception:', err);
    process.exit(1);
  });
}

bootstrap();

