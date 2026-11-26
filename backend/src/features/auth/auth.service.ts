import mongoose from 'mongoose';
import { UserModel } from '../users/user.model';
import { AccountStatus } from '../users/user.types';
import { WalletModel } from '../wallet/wallet.model';
import { TransactionModel, TransactionType } from '../wallet/transaction.model';
import { PasswordSecurity } from '../../security/password.security';
import { JwtSecurity } from '../../security/jwt.security';
import { auditService } from '../audit/audit.service';
import { AuditAction } from '../audit/audit-log.model';
import { UserRole } from '../../constants/roles.constant';
import { AppError } from '../../shared/errors/app-error';
import { HttpStatus } from '../../constants/http-status.constant';
import { ErrorCode } from '../../constants/error-codes.constant';
import { RegisterDto, LoginDto, AuthResult } from './auth.types';
import { logger } from '../../config/logger.config';

const MAX_FAILED_ATTEMPTS = 5;
const LOCKOUT_DURATION_MS = 15 * 60 * 1000; // 15 minutes
const WELCOME_COINS = 100;

export class AuthService {
  async register(dto: RegisterDto): Promise<AuthResult> {
    // 1. Check for duplicate email
    const existing = await UserModel.findOne({ email: dto.email.toLowerCase().trim() });
    if (existing) {
      throw new AppError(
        'An account with this email already exists.',
        HttpStatus.CONFLICT,
        ErrorCode.CONFLICT
      );
    }

    // Collector & Company roles require admin approval in production;
    // for now they start as ACTIVE (approval workflow will be added in later phase)
    const status =
      dto.role === UserRole.ADMIN ? AccountStatus.PENDING_APPROVAL : AccountStatus.ACTIVE;

    // 2. Hash password with Argon2id
    const passwordHash = await PasswordSecurity.hash(dto.password);

    // 3. Create user + wallet + welcome transaction atomically
    const session = await mongoose.startSession();
    let newUser: InstanceType<typeof UserModel> | undefined;

    try {
      await session.withTransaction(async () => {
        const [created] = await UserModel.create(
          [
            {
              email: dto.email.toLowerCase().trim(),
              passwordHash,
              role: dto.role,
              status,
              fullName: dto.fullName,
              phoneNumber: dto.phoneNumber,
              zoneOrSubcity: dto.zoneOrSubcity,
              companyName: dto.companyName,
              registrationNumber: dto.registrationNumber,
              tokenVersion: 0,
              failedLoginAttempts: 0,
            },
          ],
          { session }
        );

        newUser = created;

        // Create wallet with welcome bonus
        const [wallet] = await WalletModel.create(
          [
            {
              userId: created._id,
              balance: WELCOME_COINS,
              totalEarned: WELCOME_COINS,
              totalSpent: 0,
            },
          ],
          { session }
        );

        // Record welcome transaction in ledger
        await TransactionModel.create(
          [
            {
              walletId: wallet._id,
              userId: created._id,
              type: TransactionType.EARN,
              amount: WELCOME_COINS,
              balanceAfter: WELCOME_COINS,
              description: 'Welcome bonus – thank you for joining RecycleX!',
            },
          ],
          { session }
        );
      });
    } finally {
      await session.endSession();
    }

    if (!newUser) {
      throw new AppError('Registration failed. Please try again.', HttpStatus.INTERNAL_SERVER_ERROR, ErrorCode.INTERNAL_ERROR);
    }

    // 4. Generate token pair
    const tokens = JwtSecurity.generateTokenPair({
      id: (newUser._id as mongoose.Types.ObjectId).toString(),
      email: newUser.email,
      role: newUser.role,
      tokenVersion: newUser.tokenVersion,
    });

    // 5. Fire-and-forget audit log
    void auditService.log({
      action: AuditAction.USER_REGISTERED,
      actorId: (newUser._id as mongoose.Types.ObjectId).toString(),
      metadata: { role: newUser.role, email: newUser.email },
    });

    logger.info(`New user registered: ${newUser.email} (${newUser.role})`);

    return {
      user: {
        id: (newUser._id as mongoose.Types.ObjectId).toString(),
        email: newUser.email,
        role: newUser.role,
        fullName: newUser.fullName,
        status: newUser.status,
      },
      tokens,
    };
  }

  async login(dto: LoginDto, ipAddress?: string): Promise<AuthResult> {
    const email = dto.email.toLowerCase().trim();

    // 1. Find user (select passwordHash explicitly)
    const user = await UserModel.findOne({ email }).select('+passwordHash');
    if (!user) {
      throw new AppError('Invalid email or password.', HttpStatus.UNAUTHORIZED, ErrorCode.INVALID_CREDENTIALS);
    }

    // 2. Check account status
    if (user.status === AccountStatus.DEACTIVATED) {
      throw new AppError(
        'Your account has been deactivated. Contact support.',
        HttpStatus.UNAUTHORIZED,
        ErrorCode.ACCOUNT_INACTIVE
      );
    }

    if (user.status === AccountStatus.PENDING_APPROVAL) {
      throw new AppError(
        'Your account is pending admin approval.',
        HttpStatus.UNAUTHORIZED,
        ErrorCode.ACCOUNT_INACTIVE
      );
    }

    // 3. Check lockout
    if (user.lockoutUntil && user.lockoutUntil > new Date()) {
      const remainingMs = user.lockoutUntil.getTime() - Date.now();
      const remainingMin = Math.ceil(remainingMs / 60000);
      void auditService.log({
        action: AuditAction.ACCOUNT_LOCKED,
        actorId: user._id.toString(),
        ipAddress,
        metadata: { remainingMinutes: remainingMin },
      });
      throw new AppError(
        `Account temporarily locked. Try again in ${remainingMin} minute(s).`,
        HttpStatus.UNAUTHORIZED,
        ErrorCode.ACCOUNT_LOCKED
      );
    }

    // 4. Verify password
    const passwordValid = await PasswordSecurity.verify(user.passwordHash, dto.password);
    if (!passwordValid) {
      user.failedLoginAttempts += 1;

      if (user.failedLoginAttempts >= MAX_FAILED_ATTEMPTS) {
        user.lockoutUntil = new Date(Date.now() + LOCKOUT_DURATION_MS);
        void auditService.log({
          action: AuditAction.ACCOUNT_LOCKED,
          actorId: user._id.toString(),
          ipAddress,
          metadata: { failedAttempts: user.failedLoginAttempts },
        });
      }

      await user.save();
      void auditService.log({
        action: AuditAction.LOGIN_FAILED,
        actorId: user._id.toString(),
        ipAddress,
        metadata: { attempts: user.failedLoginAttempts },
      });

      throw new AppError('Invalid email or password.', HttpStatus.UNAUTHORIZED, ErrorCode.INVALID_CREDENTIALS);
    }

    // 5. Reset failure counters on successful login
    if (user.failedLoginAttempts > 0 || user.lockoutUntil) {
      user.failedLoginAttempts = 0;
      user.lockoutUntil = undefined;
      await user.save();
    }

    // 6. Generate tokens
    const tokens = JwtSecurity.generateTokenPair({
      id: user._id.toString(),
      email: user.email,
      role: user.role,
      tokenVersion: user.tokenVersion,
    });

    void auditService.log({
      action: AuditAction.USER_LOGGED_IN,
      actorId: user._id.toString(),
      ipAddress,
      metadata: { role: user.role },
    });

    return {
      user: {
        id: user._id.toString(),
        email: user.email,
        role: user.role,
        fullName: user.fullName,
        status: user.status,
      },
      tokens,
    };
  }

  async refreshToken(token: string): Promise<{ accessToken: string }> {
    let payload: { id: string; email: string; role: UserRole; tokenVersion: number };

    try {
      payload = JwtSecurity.verifyRefreshToken(token) as typeof payload;
    } catch {
      throw new AppError('Invalid or expired refresh token.', HttpStatus.UNAUTHORIZED, ErrorCode.TOKEN_INVALID);
    }

    // Verify tokenVersion matches stored value (logout invalidates old refresh tokens)
    const user = await UserModel.findById(payload.id).select('tokenVersion status email role');
    if (!user) {
      throw new AppError('User no longer exists.', HttpStatus.UNAUTHORIZED, ErrorCode.UNAUTHORIZED);
    }

    if (user.tokenVersion !== payload.tokenVersion) {
      throw new AppError(
        'Refresh token has been invalidated. Please log in again.',
        HttpStatus.UNAUTHORIZED,
        ErrorCode.TOKEN_INVALID
      );
    }

    if (user.status !== AccountStatus.ACTIVE) {
      throw new AppError('Account is not active.', HttpStatus.UNAUTHORIZED, ErrorCode.ACCOUNT_INACTIVE);
    }

    const accessToken = JwtSecurity.generateTokenPair({
      id: user._id.toString(),
      email: user.email,
      role: user.role,
      tokenVersion: user.tokenVersion,
    }).accessToken;

    return { accessToken };
  }

  async logout(userId: string): Promise<void> {
    // Increment tokenVersion to invalidate all existing tokens for this user
    await UserModel.findByIdAndUpdate(userId, { $inc: { tokenVersion: 1 } });

    void auditService.log({
      action: AuditAction.USER_LOGGED_OUT,
      actorId: userId,
    });
  }
}

export const authService = new AuthService();
