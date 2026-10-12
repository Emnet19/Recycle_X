import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/customer/presentation/pages/customer_home_page.dart';
import '../../features/customer/presentation/pages/map_page.dart';
import '../../features/collector/presentation/pages/collector_home_page.dart';
import '../../features/company/presentation/pages/company_home_page.dart';
import '../../features/collection/presentation/pages/schedule_pickup_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../core/constants/app_strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Named route constants — use these instead of raw strings in [Navigator] calls.
class Routes {
  Routes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Customer
  static const String customerHome = '/customer/home';
  static const String schedulePick = '/schedule-pickup';
  static const String emergencyPickup = '/emergency-pickup';
  static const String map = '/map';
  static const String collectionHistory = '/collection-history';

  // Collector
  static const String collectorHome = '/collector/home';

  // Company
  static const String companyHome = '/company/home';

  // Shared
  static const String wallet = '/wallet';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
}

/// Central router.
///
/// Route resolution:
///   /  (splash) → onboarding → login / register
///   After login:
///     customer  → /customer/home
///     collector → /collector/home
///     company   → /company/home
///     admin     → /admin/dashboard (future)
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _build(const SplashScreen());

      case Routes.onboarding:
        return _build(const OnboardingPage());

      case Routes.login:
        return _build(const LoginPage());

      case Routes.register:
        return _build(const RegisterPage());

      case Routes.forgotPassword:
        return _build(const ForgotPasswordPage());

      case Routes.customerHome:
        return _build(const CustomerHomePage());

      case Routes.collectorHome:
        return _build(const CollectorHomePage());

      case Routes.companyHome:
        return _build(const CompanyHomePage());

      case Routes.schedulePick:
        return _build(const SchedulePickupPage());

      case Routes.emergencyPickup:
        // TODO: create EmergencyPickupPage
        return _build(const SchedulePickupPage()); // temporary fallback

      case Routes.map:
        // MapPage requires a LatLng argument
        final args = settings.arguments;
        final location = args is LatLng ? args : const LatLng(9.03, 38.74);
        return _build(MapPage(userLocation: location));

      case Routes.wallet:
        return _build(const WalletPage());

      case Routes.profile:
        return _build(const ProfilePage());

      case Routes.notifications:
        // TODO: create NotificationsPage
        return _build(const _PlaceholderPage(title: 'Notifications'));

      case Routes.collectionHistory:
        // TODO: create CollectionHistoryPage
        return _build(const _PlaceholderPage(title: 'Collection History'));

      default:
        return _build(_NotFoundPage(routeName: settings.name ?? '?'));
    }
  }

  /// Role-aware redirect: call this after a successful login.
  static String homeRouteForRole(String role) {
    switch (role) {
      case AppStrings.roleCollector:
        return Routes.collectorHome;
      case AppStrings.roleCompany:
        return Routes.companyHome;
      case AppStrings.roleAdmin:
        return '/admin/dashboard'; // future
      case AppStrings.roleCustomer:
      default:
        return Routes.customerHome;
    }
  }

  static PageRoute _build(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}

// ─── Placeholder page ─────────────────────────────────────────────────────────
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n(Coming soon)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// ─── 404 page ─────────────────────────────────────────────────────────────────
class _NotFoundPage extends StatelessWidget {
  final String routeName;
  const _NotFoundPage({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '404 — Route "$routeName" not found.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
