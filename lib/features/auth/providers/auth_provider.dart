import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../../../core/constants/app_strings.dart';

/// Drives auth state for the entire application.
/// Listens to Firebase auth stream and exposes [currentUser] and [appUser].
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
  String get userRole => _appUser?.role ?? '';

  AuthProvider() {
    // Listen for Firebase auth state changes
    AuthService.authStateChanges.listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? firebaseUser) {
    if (firebaseUser == null) {
      _appUser = null;
    } else {
      // TODO: fetch full UserModel (with role) from backend using firebaseUser.uid.
      // For now, create a temporary UserModel from Firebase data only.
      // Role defaults to 'customer'; role selection screen handles the real role.
      _appUser = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        role: AppStrings.roleCustomer,
        emailVerified: firebaseUser.emailVerified,
      );
    }
    notifyListeners();
  }

  // ─── Google ───────────────────────────────────────────────────────────────
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      await AuthService.signInWithGoogle();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ─── Email / Password login ────────────────────────────────────────────────
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await AuthService.signInWithEmail(email: email, password: password);
      _error = null;
    } catch (e) {
      _error = _friendlyError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ─── Registration ─────────────────────────────────────────────────────────
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await AuthService.registerWithEmail(email: email, password: password);
      await AuthService.sendEmailVerification();
      _error = null;
    } catch (e) {
      _error = _friendlyError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ─── Password reset ───────────────────────────────────────────────────────
  Future<void> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    try {
      await AuthService.sendPasswordResetEmail(email);
      _error = null;
    } catch (e) {
      _error = _friendlyError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ─── Sign out ─────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await AuthService.signOut();
      _appUser = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _friendlyError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found for this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'weak-password':
          return 'Password should be at least 6 characters.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        default:
          return e.message ?? 'Authentication failed.';
      }
    }
    return e.toString();
  }
}
