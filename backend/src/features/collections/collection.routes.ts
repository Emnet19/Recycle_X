import { Router } from 'express';
import { collectionController } from './collection.controller';
import { authenticate } from '../../middleware/authenticate.middleware';
import { authorizeRoles } from '../../middleware/authorize.middleware';
import { validate } from '../../middleware/validate.middleware';
import { createPickupSchema, updatePickupStatusSchema } from './collection.validation';
import { UserRole } from '../../constants/roles.constant';

const router = Router();

router.use(authenticate);

// Customer routes
router.post('/', authorizeRoles(UserRole.CUSTOMER), validate({ body: createPickupSchema }), collectionController.createPickup);
router.get('/my', authorizeRoles(UserRole.CUSTOMER), collectionController.listOwnPickups);

// Collector routes
router.get('/pending', authorizeRoles(UserRole.KEBELE_COLLECTOR, UserRole.COMMUNITY_COLLECTOR, UserRole.ADMIN), collectionController.listPending);
router.get('/assigned', authorizeRoles(UserRole.KEBELE_COLLECTOR, UserRole.COMMUNITY_COLLECTOR), collectionController.listAssigned);
router.patch('/:id/accept', authorizeRoles(UserRole.KEBELE_COLLECTOR, UserRole.COMMUNITY_COLLECTOR), collectionController.acceptPickup);
router.patch('/:id/status', authorizeRoles(UserRole.KEBELE_COLLECTOR, UserRole.COMMUNITY_COLLECTOR, UserRole.ADMIN), validate({ body: updatePickupStatusSchema }), collectionController.updateStatus);

export const collectionRoutes = router;
