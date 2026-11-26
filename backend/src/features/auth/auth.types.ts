import { UserRole } from '../../constants/roles.constant';

export interface RegisterDto {
  email: string;
  password: string;
  role: UserRole;
  fullName?: string;
  phoneNumber: string;
  zoneOrSubcity?: string;
  companyName?: string;
  registrationNumber?: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
}

export interface AuthResult {
  user: {
    id: string;
    email: string;
    role: UserRole;
    fullName?: string;
    status: string;
  };
  tokens: AuthTokens;
}

