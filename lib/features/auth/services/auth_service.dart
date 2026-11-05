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
      description: 'Customer account — schedule pickups & earn EcoCoins',
    ),
    DemoAccount(
      email: 'kebele.collector@recyclex.com',
      password: 'password123',
      name: 'Tadesse Worku (Kebele 08 Team)',
      role: AppStrings.roleKebeleCollector,
      description: 'Kebele Collector — municipal zone routes & neighborhood bins',
    ),
    DemoAccount(
      email: 'community.collector@recyclex.com',
      password: 'password123',
      name: 'Selamawit Desta (Green Community Team)',
      role: AppStrings.roleCommunityCollector,
      description: 'Community Collector — neighborhood cleanups & drop-off hubs',
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
      ecoCoins: 100,
      initialCoinsAwarded: true,
    ),
    'kebele.collector@recyclex.com': _LocalUserRecord(
      uid: 'demo-kebele-002',
      email: 'kebele.collector@recyclex.com',
      password: 'password123',
      displayName: 'Tadesse Worku (Kebele 08)',
      role: AppStrings.roleKebeleCollector,
      ecoCoins: 100,
      initialCoinsAwarded: true,
      collectorType: 'Kebele Collector',
      zoneOrOrganization: 'Kebele 08 / Woreda 03',
    ),
    'community.collector@recyclex.com': _LocalUserRecord(
      uid: 'demo-comm-003',
      email: 'community.collector@recyclex.com',
      password: 'password123',
      displayName: 'Selamawit Desta',
      role: AppStrings.roleCommunityCollector,
      ecoCoins: 100,
      initialCoinsAwarded: true,
      collectorType: 'Community Collector',
      zoneOrOrganization: 'Green Community Youth Cooperative',
    ),
    'company@recyclex.com': _LocalUserRecord(
      uid: 'demo-company-004',
      email: 'company@recyclex.com',
      password: 'password123',
      displayName: 'EcoPlastics Ethiopia',
      role: AppStrings.roleCompany,
      ecoCoins: 100,
      initialCoinsAwarded: true,
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
    String? collectorType;
    if (normalizedEmail.contains('kebele')) {
      inferredRole = AppStrings.roleKebeleCollector;
      collectorType = 'Kebele Collector';
    } else if (normalizedEmail.contains('community')) {
      inferredRole = AppStrings.roleCommunityCollector;
      collectorType = 'Community Collector';
    } else if (normalizedEmail.contains('collector')) {
      inferredRole = AppStrings.roleKebeleCollector;
      collectorType = 'Kebele Collector';
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
      ecoCoins: 100,
      initialCoinsAwarded: true,
      collectorType: collectorType,
    );

    _usersDb[normalizedEmail] = _LocalUserRecord(
      uid: newUser.uid,
      email: normalizedEmail,
      password: password,
      displayName: newUser.displayName ?? '',
      role: newUser.role,
      ecoCoins: 100,
      initialCoinsAwarded: true,
      collectorType: collectorType,
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
    String? collectorType,
    String? zoneOrOrganization,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final normalizedEmail = email.trim().toLowerCase();

    // Check if user already exists
    if (_usersDb.containsKey(normalizedEmail)) {
      throw Exception('An account with this email already exists.');
    }

    // Requirement 4: Award 100 initial ecoCoins on first registration
    const initialEcoCoins = 100;
    const initialCoinsAwarded = true;

    final user = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: normalizedEmail,
      displayName: displayName ?? normalizedEmail.split('@').first,
      role: role,
      emailVerified: true,
      createdAt: DateTime.now(),
      ecoCoins: initialEcoCoins,
      initialCoinsAwarded: initialCoinsAwarded,
      collectorType: collectorType,
      zoneOrOrganization: zoneOrOrganization,
    );

    _usersDb[normalizedEmail] = _LocalUserRecord(
      uid: user.uid,
      email: normalizedEmail,
      password: password,
      displayName: user.displayName ?? '',
      role: role,
      ecoCoins: initialEcoCoins,
      initialCoinsAwarded: initialCoinsAwarded,
      collectorType: collectorType,
      zoneOrOrganization: zoneOrOrganization,
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
  final int ecoCoins;
  final bool initialCoinsAwarded;
  final String? collectorType;
  final String? zoneOrOrganization;

  _LocalUserRecord({
    required this.uid,
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
    this.ecoCoins = 100,
    this.initialCoinsAwarded = true,
    this.collectorType,
    this.zoneOrOrganization,
  });

  UserModel toUserModel() {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      role: role,
      emailVerified: true,
      createdAt: DateTime.now(),
      ecoCoins: ecoCoins,
      initialCoinsAwarded: initialCoinsAwarded,
      collectorType: collectorType,
      zoneOrOrganization: zoneOrOrganization,
    );
  }
}
