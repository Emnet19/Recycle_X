import { Router } from 'express';
import { userController } from './user.controller';
import { authenticate } from '../../middleware/authenticate.middleware';
import { authorizeRoles } from '../../middleware/authorize.middleware';
import { validate } from '../../middleware/validate.middleware';
import { updateProfileSchema, updateStatusSchema } from './user.validation';
import { UserRole } from '../../constants/roles.constant';

const router = Router();

// Own profile routes
router.get('/profile', authenticate, userController.getOwnProfile);
router.patch('/profile', authenticate, validate({ body: updateProfileSchema }), userController.updateOwnProfile);

// Admin-only user management routes
router.get('/', authenticate, authorizeRoles(UserRole.ADMIN), userController.listUsers);
router.patch(
  '/:id/status',
  authenticate,
  authorizeRoles(UserRole.ADMIN),
  validate({ body: updateStatusSchema }),
  userController.updateStatus
);

export const userRoutes = router;

