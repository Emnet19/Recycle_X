import { Router } from 'express';
import { auditController } from './audit.controller';
import { authenticate } from '../../middleware/authenticate.middleware';
import { authorizeRoles } from '../../middleware/authorize.middleware';
import { UserRole } from '../../constants/roles.constant';

const router = Router();

router.use(authenticate, authorizeRoles(UserRole.ADMIN));

router.get('/', auditController.listLogs);
router.get('/users/:userId', auditController.getUserActivity);

export const auditRoutes = router;

