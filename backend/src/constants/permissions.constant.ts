export enum Permission {
  // Authentication & Profile
  AUTH_LOGIN = 'auth:login',
  AUTH_REGISTER = 'auth:register',
  PROFILE_READ_OWN = 'profile:read:own',
  PROFILE_UPDATE_OWN = 'profile:update:own',
  ACCOUNT_DEACTIVATE_OWN = 'account:deactivate:own',

  // User Management (Admin)
  USERS_READ_ALL = 'users:read:all',
  USERS_MANAGE = 'users:manage',
  USERS_STATUS_UPDATE = 'users:status:update',

  // Collections / Pickups
  PICKUP_CREATE = 'pickup:create',
  PICKUP_READ_OWN = 'pickup:read:own',
  PICKUP_READ_ASSIGNED = 'pickup:read:assigned',
  PICKUP_ASSIGN = 'pickup:assign',
  PICKUP_STATUS_UPDATE = 'pickup:status:update',
  PICKUP_COMPLETE = 'pickup:complete',
  PICKUP_HISTORY_VIEW = 'pickup:history:view',

  // EcoCoins & Wallet
  WALLET_READ_OWN = 'wallet:read:own',
  WALLET_TRANSACT = 'wallet:transact',
  WALLET_ADJUST = 'wallet:adjust',
  WALLET_READ_ANY = 'wallet:read:any',

  // Company Recycling Operations
  COMPANY_PROFILE_MANAGE = 'company:profile:manage',
  COMPANY_MATERIALS_MANAGE = 'company:materials:manage',
  COMPANY_BATCHES_MANAGE = 'company:batches:manage',

  // Administration & Security
  ROLES_ASSIGN = 'roles:assign',
  ROLES_REVOKE = 'roles:revoke',
  ROLES_APPROVE_CHANGE = 'roles:approve_change',
  AUDIT_READ = 'audit:read',
  SYSTEM_SETTINGS_MANAGE = 'system:settings:manage',
}

