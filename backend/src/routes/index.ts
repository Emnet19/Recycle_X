import { Router, Request, Response } from 'express';
import swaggerUi from 'swagger-ui-express';
import { env } from '../config/env.config';
import { authRoutes } from '../features/auth/auth.routes';
import { userRoutes } from '../features/users/user.routes';
import { roleRoutes } from '../features/roles/role.routes';
import { collectionRoutes } from '../features/collections/collection.routes';
import { walletRoutes } from '../features/wallet/wallet.routes';
import { companyRoutes } from '../features/company/company.routes';
import { auditRoutes } from '../features/audit/audit.routes';
import { swaggerSpec } from '../docs/swagger.config';

const router = Router();

// ── Health Check ────────────────────────────────────────────────────────────
router.get('/health', (_req: Request, res: Response) => {
  res.json({
    success: true,
    message: 'RecycleX API is running.',
    environment: env.NODE_ENV,
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

// ── API Documentation ────────────────────────────────────────────────────────
router.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
  customSiteTitle: 'RecycleX API Docs',
}));

// ── Feature Routes ───────────────────────────────────────────────────────────
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/roles', roleRoutes);
router.use('/collections', collectionRoutes);
router.use('/wallet', walletRoutes);
router.use('/company', companyRoutes);
router.use('/audit', auditRoutes);

export const apiRouter = router;

