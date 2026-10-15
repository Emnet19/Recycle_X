import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../../../core/constants/app_strings.dart';

/// Drives auth state for the entire application.
/// Listens to [AuthService.authStateChanges] and exposes [currentUser] and [appUser].
///
/// The [appUser.role] field is used by [AppRouter] to decide which
/// dashboard to navigate to after a successful login.
class AuthProvider extends ChangeNotifier {
  UserModel? _appUser;
  bool _loading = false;
  String? _error;

  UserModel? get appUser => _appUser;
  bool get loading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _appUser != null;
  String get userRole => _appUser?.role ?? AppStrings.roleCustomer;

  AuthProvider() {
    // Seed with current user if already logged in
    _appUser = AuthService.currentUser;
    // Listen for auth state changes
    AuthService.authStateChanges.listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(UserModel? user) {
    _appUser = user;
    notifyListeners();
  }

  // ─── Direct Demo Login ─────────────────────────────────────────────────────
  Future<bool> loginAsDemo(String role) async {
    _setLoading(true);
    try {
      final user = await AuthService.loginAsDemo(role);
      _appUser = user;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Google ────────────────────────────────────────────────────────────────
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      final user = await AuthService.signInWithGoogle();
      _appUser = user;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Email / Password login ────────────────────────────────────────────────
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final user = await AuthService.signInWithEmail(email: email, password: password);
      _appUser = user;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Registration ──────────────────────────────────────────────────────────
  Future<bool> registerWithEmail({
    required String email,
    required String password,
    String role = AppStrings.roleCustomer,
    String? displayName,
  }) async {
    _setLoading(true);
    try {
      final user = await AuthService.registerWithEmail(
        email: email,
        password: password,
        role: role,
        displayName: displayName,
      );
      _appUser = user;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─── Password reset ────────────────────────────────────────────────────────
  Future<void> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    try {
      await AuthService.sendPasswordResetEmail(email);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  // ─── Sign out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await AuthService.signOut();
      _appUser = null;
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
