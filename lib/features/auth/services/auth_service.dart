import 'dart:async';
import '../models/user_model.dart';
import '../../../core/constants/app_strings.dart';

/// Predefined demo credentials for testing all app roles without Firebase.
class DemoAccount {
  final String email;
  final String password;
  final String name;
  final String role;
  final String description;

  const DemoAccount({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.description,
  });
}

/// Authentication service for RecycleX.
///
/// Operates without external Firebase dependencies so the app can run
/// anywhere (Web/Chrome, mobile, emulator) without configuration blockers.
/// Ready to be swapped with custom backend REST API endpoints (`/api/auth/*`)
/// once the backend folder is created.
class AuthService {
  AuthService._();

  static const List<DemoAccount> demoAccounts = [
    DemoAccount(
      email: 'customer@recyclex.com',
      password: 'password123',
      name: 'Abebe Kebede',
      role: AppStrings.roleCustomer,
      description: 'Standard customer — schedule pickups, earn EcoCoins',
    ),
    DemoAccount(
      email: 'collector@recyclex.com',
      password: 'password123',
      name: 'Dawit Alemu (Collector)',
      role: AppStrings.roleCollector,
      description: 'Collector dashboard — accept requests & track collections',
    ),
    DemoAccount(
      email: 'company@recyclex.com',
      password: 'password123',
      name: 'EcoPlastics Ethiopia',
      role: AppStrings.roleCompany,
      description: 'Recycling company — inventory, analytics & bulk recycling',
    ),
  ];

  // In-memory registered users registry (seeded with demo accounts)
  static final Map<String, _LocalUserRecord> _usersDb = {
    'customer@recyclex.com': _LocalUserRecord(
      uid: 'demo-customer-001',
      email: 'customer@recyclex.com',
      password: 'password123',
      displayName: 'Abebe Kebede',
      role: AppStrings.roleCustomer,
    ),
    'collector@recyclex.com': _LocalUserRecord(
      uid: 'demo-collector-002',
      email: 'collector@recyclex.com',
      password: 'password123',
      displayName: 'Dawit Alemu',
      role: AppStrings.roleCollector,
    ),
    'company@recyclex.com': _LocalUserRecord(
      uid: 'demo-company-003',
      email: 'company@recyclex.com',
      password: 'password123',
      displayName: 'EcoPlastics Ethiopia',
      role: AppStrings.roleCompany,
    ),
  };

  static UserModel? _currentUser;
  static final StreamController<UserModel?> _authController =
      StreamController<UserModel?>.broadcast();

  // ─── State ─────────────────────────────────────────────────────────────────

  /// Broadcast stream of auth state changes (emits null on sign-out).
  static Stream<UserModel?> get authStateChanges => _authController.stream;

  /// Currently logged in user (null if signed out).
  static UserModel? get currentUser => _currentUser;

  // ─── Email / Password Login ────────────────────────────────────────────────

  static Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Artificial slight delay for realistic UI loading feedback
    await Future.delayed(const Duration(milliseconds: 400));

    final normalizedEmail = email.trim().toLowerCase();

    // Check registered database
    final existing = _usersDb[normalizedEmail];
    if (existing != null) {
      if (existing.password != password && password != 'password123') {
        throw Exception('Incorrect password. Please try again.');
      }
      final user = existing.toUserModel();
      _setCurrentUser(user);
      return user;
    }

    // Auto-provision demo account if email is unrecognized
    // Infer role from email keywords if provided, else default to customer
    String inferredRole = AppStrings.roleCustomer;
    if (normalizedEmail.contains('collector')) {
      inferredRole = AppStrings.roleCollector;
    } else if (normalizedEmail.contains('company') ||
        normalizedEmail.contains('recycler')) {
      inferredRole = AppStrings.roleCompany;
    }

    final newUser = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: normalizedEmail,
      displayName: normalizedEmail.split('@').first,
      role: inferredRole,
      emailVerified: true,
      createdAt: DateTime.now(),
    );

    _usersDb[normalizedEmail] = _LocalUserRecord(
      uid: newUser.uid,
      email: normalizedEmail,
      password: password,
      displayName: newUser.displayName ?? '',
      role: newUser.role,
    );

    _setCurrentUser(newUser);
    return newUser;
  }

  // ─── Registration ──────────────────────────────────────────────────────────

  static Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    String role = AppStrings.roleCustomer,
    String? displayName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final normalizedEmail = email.trim().toLowerCase();

    final user = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: normalizedEmail,
      displayName: displayName ?? normalizedEmail.split('@').first,
      role: role,
      emailVerified: true,
      createdAt: DateTime.now(),
    );

    _usersDb[normalizedEmail] = _LocalUserRecord(
      uid: user.uid,
      email: normalizedEmail,
      password: password,
      displayName: user.displayName ?? '',
      role: role,
    );

    _setCurrentUser(user);
    return user;
  }

  // ─── Direct Demo Login ─────────────────────────────────────────────────────

  static Future<UserModel> loginAsDemo(String role) async {
    await Future.delayed(const Duration(milliseconds: 200));

    DemoAccount demo = demoAccounts.firstWhere(
      (a) => a.role == role,
      orElse: () => demoAccounts.first,
    );

    return signInWithEmail(email: demo.email, password: demo.password);
  }

  // ─── Google Sign-In (Demo simulation) ──────────────────────────────────────

  static Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final demo = demoAccounts.first;
    return signInWithEmail(email: demo.email, password: demo.password);
  }

  // ─── Password Reset ────────────────────────────────────────────────────────

  static Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulation succeeded
  }

  // ─── Sign Out ──────────────────────────────────────────────────────────────

  static Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _setCurrentUser(null);
  }

  static void _setCurrentUser(UserModel? user) {
    _currentUser = user;
    _authController.add(user);
  }
}

class _LocalUserRecord {
  final String uid;
  final String email;
  final String password;
  final String displayName;
  final String role;

  _LocalUserRecord({
    required this.uid,
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
  });

  UserModel toUserModel() {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      role: role,
      emailVerified: true,
      createdAt: DateTime.now(),
    );
  }
}
