import { z } from 'zod';
import { AccountStatus } from './user.types';

export const updateProfileSchema = z.object({
  fullName: z.string().min(2).optional(),
  phoneNumber: z.string().min(9).optional(),
  zoneOrSubcity: z.string().optional(),
});

export const updateStatusSchema = z.object({
  status: z.nativeEnum(AccountStatus),
  reason: z.string().min(5, 'Reason for status change is required.'),
});

