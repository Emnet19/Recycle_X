# RecycleX – Monorepo

A waste collection and recycling platform built with **Flutter** (frontend) and **Node.js / Express / TypeScript / MongoDB** (backend).

```
Recycle_X/
├── frontend/   ← Flutter mobile application
├── backend/    ← Node.js REST API
└── README.md
```

---

## Frontend (Flutter)

**Location:** `frontend/`  
**Technology:** Flutter · Dart · Provider

### Requirements
- Flutter SDK ≥ 3.x ([install guide](https://docs.flutter.dev/get-started/install))
- Dart SDK (bundled with Flutter)

### Setup & Run

```bash
cd frontend

# Install dependencies
flutter pub get

# Run on a connected device / emulator
flutter run

# Build release APK
flutter build apk --release
```

### Project structure

```
frontend/
├── lib/
│   ├── core/           # Theme, routing, constants, services
│   ├── features/       # Feature modules (auth, collection, company, …)
│   └── main.dart
├── assets/             # Images, fonts, icons
├── android/            # Android platform files
├── ios/                # iOS platform files
├── web/                # Web platform files
├── pubspec.yaml        # Flutter dependencies
└── analysis_options.yaml
```

---

## Backend (Node.js / Express / TypeScript)

**Location:** `backend/`  
**Technology:** Node.js · Express.js · TypeScript · MongoDB · Mongoose · JWT · Argon2id

### Requirements
- Node.js ≥ 22
- npm ≥ 10
- MongoDB ≥ 7 (local or Atlas)

### Setup

```bash
cd backend

# Install dependencies
npm install

# Copy the env template and fill in your values
cp .env.example .env
```

**Minimum `.env` values:**

```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/recyclex
JWT_ACCESS_SECRET=your_secret_here
JWT_REFRESH_SECRET=your_refresh_secret_here
NODE_ENV=development
```

### Run

```bash
# Development (hot-reload via tsx watch)
npm run dev

# Production build
npm run build
npm start
```

### API

| Endpoint | Description |
|---|---|
| `GET  /api/v1/health` | Health check |
| `POST /api/v1/auth/register` | Register a new user |
| `POST /api/v1/auth/login` | Login |
| `POST /api/v1/auth/refresh-token` | Refresh access token |
| `POST /api/v1/auth/logout` | Logout |
| `GET  /api/v1/auth/me` | Get current user |
| `GET  /api/v1/docs` | Swagger UI |

> Full API documentation available at `http://localhost:5000/api/v1/docs` when running in development.

### Project structure

```
backend/
├── src/
│   ├── server.ts           # Entry point & graceful shutdown
│   ├── app.ts              # Express factory & middleware stack
│   ├── config/             # Env validation, logger
│   ├── constants/          # Roles, permissions, HTTP status codes
│   ├── database/           # MongoDB connection
│   ├── docs/               # Swagger configuration
│   ├── middleware/         # Auth, RBAC, validation, error handler
│   ├── routes/             # Aggregated route index
│   ├── security/           # JWT, password hashing, CORS
│   ├── shared/             # Shared types, errors, API response helper
│   └── features/
│       ├── auth/           # Register · Login · Refresh · Logout · Me
│       ├── users/          # Profile · List · Status management
│       ├── roles/          # Maker-checker role assignment (SoD)
│       ├── collections/    # Scheduled & emergency pickups
│       ├── wallet/         # Coin earn · Redeem (Mongoose transactions)
│       ├── company/        # Company profile & materials CRUD
│       └── audit/          # Immutable audit log (Admin-only reads)
├── .env.example
├── package.json
└── tsconfig.json
```

---

## User Roles

| Role | Description |
|---|---|
| **Customer** | Schedules pickups, tracks collections, manages wallet |
| **Kebele Collector** | Handles government-level collection assignments |
| **Community Collector** | Handles community-level collection requests |
| **Company** | Manages recyclable material categories and company profile |
| **Admin** | Full access, user management, audit log inspection |

---

## Development Status

| Layer | Status |
|---|---|
| Flutter Frontend | ✅ Implemented (UI-only, no live backend yet) |
| Backend API | ✅ Implemented, TypeScript verified (zero errors) |
| Frontend ↔ Backend integration | 🔜 Planned next phase |

---

## Security Notes

- Passwords hashed with **Argon2id**
- Tokens issued as short-lived **JWT access tokens** + **refresh tokens**
- Role-based access control (**RBAC**) with least privilege
- **Maker-checker separation of duties** for sensitive role changes
- Immutable **audit trail** for all sensitive operations
- `.env` files are git-ignored — never commit secrets

---

*RecycleX — Addis Ababa Science and Technology University | Computer System Security Project*
