import { Router } from 'express';
import { companyController } from './company.controller';
import { authenticate } from '../../middleware/authenticate.middleware';
import { authorizeRoles } from '../../middleware/authorize.middleware';
import { validate } from '../../middleware/validate.middleware';
import { updateCompanyProfileSchema, createMaterialSchema, updateMaterialSchema } from './company.validation';
import { UserRole } from '../../constants/roles.constant';

const router = Router();

router.use(authenticate, authorizeRoles(UserRole.COMPANY));

// Company profile
router.get('/profile', companyController.getProfile);
router.patch('/profile', validate({ body: updateCompanyProfileSchema }), companyController.updateProfile);

// Recyclable materials catalog
router.get('/materials', companyController.listMaterials);
router.post('/materials', validate({ body: createMaterialSchema }), companyController.createMaterial);
router.patch('/materials/:materialId', validate({ body: updateMaterialSchema }), companyController.updateMaterial);
router.delete('/materials/:materialId', companyController.deleteMaterial);

export const companyRoutes = router;

