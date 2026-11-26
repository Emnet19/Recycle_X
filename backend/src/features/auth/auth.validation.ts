import { z } from 'zod';
import { UserRole } from '../../constants/roles.constant';

export const registerSchema = z.object({
  email: z.string().email('Invalid email address format.'),
  password: z
    .string()
    .min(8, 'Password must be at least 8 characters long.')
    .regex(/[A-Z]/, 'Password must contain at least one uppercase letter.')
    .regex(/[0-9]/, 'Password must contain at least one digit.'),
  role: z.nativeEnum(UserRole, {
    errorMap: () => ({ message: 'Invalid role specified.' }),
  }),
  fullName: z.string().min(2, 'Full name must be at least 2 characters.').optional(),
  phoneNumber: z.string().min(9, 'Valid phone number is required.'),
  zoneOrSubcity: z.string().optional(),
  companyName: z.string().optional(),
  registrationNumber: z.string().optional(),
});

export const loginSchema = z.object({
  email: z.string().email('Invalid email address format.'),
  password: z.string().min(1, 'Password is required.'),
});

export const refreshTokenSchema = z.object({
  refreshToken: z.string().min(1, 'Refresh token is required.'),
});

