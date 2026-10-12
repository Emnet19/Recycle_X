import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles all Firebase authentication operations.
/// Moved from lib/services/auth_service.dart → features/auth/services/auth_service.dart
///
/// Extended with email/password sign-in, registration, password reset,
/// and email verification — ready to connect with the future backend.
/// Safe against uninitialized Firebase (e.g. running on Web before flutterfire configure).
class AuthService {
  AuthService._();

  static FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ─── State ────────────────────────────────────────────────────────────────

  /// Stream of auth state changes (null = signed out).
  static Stream<User?> get authStateChanges {
    try {
      final auth = _auth;
      if (auth != null) return auth.authStateChanges();
    } catch (_) {}
    return const Stream.empty();
  }

  /// Currently signed-in Firebase user (null if not authenticated).
  static User? get currentUser {
    try {
      return _auth?.currentUser;
    } catch (_) {
      return null;
    }
  }

  // ─── Google Sign-In ───────────────────────────────────────────────────────

  static Future<User?> signInWithGoogle() async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase is not configured for this platform. Run `flutterfire configure`.');
    }
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await auth.signInWithCredential(credential);
    return userCredential.user;
  }

  // ─── Email / Password ─────────────────────────────────────────────────────

  static Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase is not configured for this platform. Run `flutterfire configure`.');
    }
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  static Future<User?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase is not configured for this platform. Run `flutterfire configure`.');
    }
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // ─── Password reset ───────────────────────────────────────────────────────

  static Future<void> sendPasswordResetEmail(String email) async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase is not configured for this platform.');
    }
    await auth.sendPasswordResetEmail(email: email);
  }

  // ─── Email verification ───────────────────────────────────────────────────

  static Future<void> sendEmailVerification() async {
    await _auth?.currentUser?.sendEmailVerification();
  }

  static bool get isEmailVerified =>
      _auth?.currentUser?.emailVerified ?? false;

  // ─── Sign out ─────────────────────────────────────────────────────────────

  static Future<void> signOut() async {
    await _auth?.signOut();
    await _googleSignIn.signOut();
  }
}
