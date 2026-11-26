import { z } from 'zod';
import { MaterialCategory } from './company-material.model';

export const updateCompanyProfileSchema = z.object({
  companyName: z.string().min(2).optional(),
  phoneNumber: z.string().min(9).optional(),
  address: z.string().optional(),
  registrationNumber: z.string().optional(),
});

export const createMaterialSchema = z.object({
  category: z.nativeEnum(MaterialCategory),
  name: z.string().min(2, 'Material name is required.'),
  pricePerKg: z.number().nonnegative(),
  minimumWeightKg: z.number().nonnegative().default(1),
});

export const updateMaterialSchema = createMaterialSchema.partial().extend({
  isActive: z.boolean().optional(),
});

