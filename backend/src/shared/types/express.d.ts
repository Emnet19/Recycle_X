import { UserRole } from '../../constants/roles.constant';

export interface AuthenticatedUser {
  id: string;
  email: string;
  role: UserRole;
  tokenVersion?: number;
}

declare global {
  namespace Express {
    interface Request {
      user?: AuthenticatedUser;
      token?: string;
    }
  }
}

