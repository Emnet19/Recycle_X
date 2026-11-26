# RecycleX Backend

Enterprise-grade REST API for the **RecycleX** waste collection and resource recovery platform.

| | |
|---|---|
| **Runtime** | Node.js 22 |
| **Language** | TypeScript 5 |
| **Framework** | Express.js 4 |
| **Database** | MongoDB via Mongoose 8 |
| **Auth** | JWT (Access + Refresh tokens) |
| **Hashing** | Argon2id |
| **Validation** | Zod |
| **Docs** | Swagger UI (`/api/v1/docs`) |

---

## Quick Start

```bash
cd backend
npm install
cp .env.example .env        # Edit .env with your secrets
npm run dev                 # Start dev server with hot-reload
```

The API will be available at **http://localhost:5000/api/v1**.

---

## Folder Structure

```
backend/
├── .env.example            # Safe template — commit this, never .env
├── package.json
├── tsconfig.json
└── src/
    ├── server.ts           # Entry point: starts HTTP server & graceful shutdown
    ├── app.ts              # Express app factory (middleware stack + routes)
    │
    ├── config/             # Application-wide configuration
    │   ├── env.config.ts   # Zod-validated env parsing – single source of truth
    │   └── logger.config.ts # Structured logger (timestamped, level-aware)
    │
    ├── database/
    │   └── connection.ts   # Mongoose connect/disconnect with event listeners
    │
    ├── constants/          # Enums and static values shared across features
    │   ├── roles.constant.ts       # UserRole enum (matches Flutter frontend roles)
    │   ├── permissions.constant.ts # Granular permission strings for RBAC
    │   ├── http-status.constant.ts # HTTP status code constants
    │   └── error-codes.constant.ts # Application-specific error codes
    │
    ├── security/           # Security utilities (stateless, no DB calls)
    │   ├── jwt.security.ts      # Token signing and verification (HS256)
    │   ├── password.security.ts # Argon2id hash and verify wrappers
    │   └── cors.security.ts     # CORS policy from env CORS_ORIGIN
    │
    ├── middleware/         # Express middleware (applied in app.ts or per-route)
    │   ├── authenticate.middleware.ts    # JWT Bearer extraction + validation
    │   ├── authorize.middleware.ts       # Role-based access control guard
    │   ├── validate.middleware.ts        # Zod schema request validation
    │   ├── error-handler.middleware.ts   # Global error envelope formatter
    │   ├── not-found.middleware.ts       # 404 catch-all handler
    │   └── request-logger.middleware.ts  # Per-request method/path/status/ms log
    │
    ├── shared/             # Cross-feature utilities and base types
    │   ├── errors/
    │   │   └── app-error.ts     # AppError class (statusCode + errorCode + message)
    │   ├── types/
    │   │   ├── express.d.ts     # Augments Express Request with req.user / req.token
    │   │   └── common.types.ts  # PaginationParams, PaginatedResult<T>
    │   └── utils/
    │       └── api-response.ts  # ApiResponse.success/created/noContent helpers
    │
    ├── docs/
    │   └── swagger.config.ts    # OpenAPI 3 spec object (expand paths per feature)
    │
    ├── routes/
    │   └── index.ts        # Mounts all feature routers under env.API_PREFIX
    │
    └── features/           # ★ Feature-based modules (one folder per domain)
        │
        ├── auth/           # Registration, login, token refresh, logout
        │   ├── auth.types.ts
        │   ├── auth.validation.ts
        │   ├── auth.service.ts
        │   ├── auth.controller.ts
        │   └── auth.routes.ts
        │
        ├── users/          # Profile, account status, admin user management
        │   ├── user.types.ts
        │   ├── user.model.ts       # Mongoose schema (Argon2 hash, lockout, tokenVersion)
        │   ├── user.validation.ts
        │   ├── user.service.ts
        │   ├── user.controller.ts
        │   └── user.routes.ts
        │
        ├── roles/          # Role definitions + maker-checker change requests (SoD)
        │   ├── role.model.ts
        │   ├── role-change-request.model.ts
        │   ├── role.validation.ts
        │   ├── role.service.ts       # Enforces requester ≠ reviewer (SoD)
        │   ├── role.controller.ts
        │   └── role.routes.ts
        │
        ├── collections/    # Scheduled & emergency pickup lifecycle
        │   ├── collection.model.ts   # 2dsphere geospatial index on address.coordinates
        │   ├── collection.validation.ts
        │   ├── collection.service.ts
        │   ├── collection.controller.ts
        │   └── collection.routes.ts
        │
        ├── wallet/         # EcoCoin balances, ledger transactions, reward redemption
        │   ├── wallet.model.ts       # Optimistic concurrency (version field)
        │   ├── transaction.model.ts  # Immutable ledger entries
        │   ├── wallet.validation.ts
        │   ├── wallet.service.ts
        │   ├── wallet.controller.ts
        │   └── wallet.routes.ts
        │
        ├── company/        # Company profile + recyclable materials catalog
        │   ├── company-material.model.ts
        │   ├── company.validation.ts
        │   ├── company.service.ts
        │   ├── company.controller.ts
        │   └── company.routes.ts
        │
        └── audit/          # Immutable tamper-evident audit log (Admin-only reads)
            ├── audit-log.model.ts    # Pre-save hook blocks updates
            ├── audit.service.ts      # Non-fatal async log writer
            ├── audit.controller.ts
            └── audit.routes.ts
```

---

## API Endpoints

| Method | Path | Auth | Role(s) | Description |
|--------|------|------|---------|-------------|
| `GET` | `/api/v1/health` | — | Public | Server health check |
| `GET` | `/api/v1/docs` | — | Public | Swagger UI |
| `POST` | `/api/v1/auth/register` | — | Public | Register a new user |
| `POST` | `/api/v1/auth/login` | — | Public | Login and receive tokens |
| `POST` | `/api/v1/auth/refresh-token` | — | Public | Refresh access token |
| `POST` | `/api/v1/auth/logout` | ✅ JWT | Any | Invalidate session |
| `GET` | `/api/v1/users/profile` | ✅ JWT | Any | Get own profile |
| `PATCH` | `/api/v1/users/profile` | ✅ JWT | Any | Update own profile |
| `GET` | `/api/v1/users` | ✅ JWT | Admin | List all users |
| `PATCH` | `/api/v1/users/:id/status` | ✅ JWT | Admin | Change account status |
| `GET` | `/api/v1/roles` | ✅ JWT | Any | List role definitions |
| `POST` | `/api/v1/roles/requests` | ✅ JWT | Admin | Submit role change request |
| `PATCH` | `/api/v1/roles/requests/:id/review` | ✅ JWT | Admin | Approve/Reject (SoD enforced) |
| `POST` | `/api/v1/collections` | ✅ JWT | Customer | Create pickup request |
| `GET` | `/api/v1/collections/my` | ✅ JWT | Customer | Own pickups |
| `GET` | `/api/v1/collections/assigned` | ✅ JWT | Collector | Assigned pickups |
| `PATCH` | `/api/v1/collections/:id/accept` | ✅ JWT | Collector | Accept a pickup |
| `PATCH` | `/api/v1/collections/:id/status` | ✅ JWT | Collector/Admin | Update pickup status |
| `GET` | `/api/v1/wallet/balance` | ✅ JWT | Any | EcoCoin balance |
| `GET` | `/api/v1/wallet/transactions` | ✅ JWT | Any | Transaction history |
| `POST` | `/api/v1/wallet/redeem` | ✅ JWT | Any | Redeem reward |
| `GET` | `/api/v1/company/profile` | ✅ JWT | Company | Company profile |
| `PATCH` | `/api/v1/company/profile` | ✅ JWT | Company | Update profile |
| `GET` | `/api/v1/company/materials` | ✅ JWT | Company | Materials catalog |
| `POST` | `/api/v1/company/materials` | ✅ JWT | Company | Add material |
| `PATCH` | `/api/v1/company/materials/:materialId` | ✅ JWT | Company | Update material |
| `DELETE` | `/api/v1/company/materials/:materialId` | ✅ JWT | Company | Deactivate material |
| `GET` | `/api/v1/audit` | ✅ JWT | Admin | System audit log |
| `GET` | `/api/v1/audit/users/:userId` | ✅ JWT | Admin | Per-user activity |

---

## npm Scripts

| Command | Action |
|---------|--------|
| `npm run dev` | Start dev server with hot-reload (`tsx watch`) |
| `npm run build` | Compile TypeScript to `dist/` |
| `npm start` | Run compiled production build |

---

## Security Architecture

| Mechanism | Implementation |
|-----------|---------------|
| Password hashing | Argon2id (`timeCost=3`, `memoryCost=64 MB`) |
| Session tokens | Short-lived JWT access (15 min) + Refresh (7 days) |
| Token invalidation | `tokenVersion` field incremented on logout/role change |
| Role enforcement | `authorizeRoles()` middleware on every protected route |
| Input sanitisation | Zod validation on all request bodies — raw data never touches service layer |
| Account lockout | `failedLoginAttempts` + `lockoutUntil` on `UserModel` (implemented in service phase) |
| Separation of Duties | `role.service.ts` rejects when `requesterId === reviewerId` |
| Audit immutability | `AuditLogSchema.pre('findOneAndUpdate')` throws to prevent tampering |
| Security headers | `helmet()` applied globally in `app.ts` |
| CORS | Whitelist-only via `CORS_ORIGIN` environment variable |

---

## Adding a New Feature

Follow this checklist to add, e.g., a **notifications** feature:

```
src/features/notifications/
├── notification.model.ts      # 1. Define Mongoose schema + TypeScript interface
├── notification.types.ts      # 2. DTOs and enums (optional if types fit in model)
├── notification.validation.ts # 3. Zod schemas for every request body/query
├── notification.service.ts    # 4. Business logic – import model, throw AppError
├── notification.controller.ts # 5. HTTP layer – call service, call ApiResponse.*
└── notification.routes.ts     # 6. Mount authenticate/authorizeRoles/validate
```

Then register it in `src/routes/index.ts`:

```ts
import { notificationRoutes } from '../features/notifications/notification.routes';
router.use('/notifications', notificationRoutes);
```

That is all — no other files need to change.

