import { z } from 'zod';
import { UserRole } from '../../constants/roles.constant';

export const createRoleChangeRequestSchema = z.object({
  targetUserId: z.string().min(1, 'Target user ID is required.'),
  requestedRole: z.nativeEnum(UserRole),
  justification: z.string().min(10, 'Justification must be at least 10 characters.'),
});

export const reviewRoleChangeRequestSchema = z.object({
  approved: z.boolean(),
  reviewNotes: z.string().min(5, 'Review notes are required.'),
});

