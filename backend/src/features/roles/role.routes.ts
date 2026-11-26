import { Router } from 'express';
import { roleController } from './role.controller';
import { authenticate } from '../../middleware/authenticate.middleware';
import { authorizeRoles } from '../../middleware/authorize.middleware';
import { validate } from '../../middleware/validate.middleware';
import { createRoleChangeRequestSchema, reviewRoleChangeRequestSchema } from './role.validation';
import { UserRole } from '../../constants/roles.constant';

const router = Router();

router.use(authenticate);

// List role definitions
router.get('/', roleController.listRoles);

// Admin role change requests with maker-checker workflow
router.post(
  '/requests',
  authorizeRoles(UserRole.ADMIN),
  validate({ body: createRoleChangeRequestSchema }),
  roleController.createChangeRequest
);

router.patch(
  '/requests/:id/review',
  authorizeRoles(UserRole.ADMIN),
  validate({ body: reviewRoleChangeRequestSchema }),
  roleController.reviewChangeRequest
);

export const roleRoutes = router;

