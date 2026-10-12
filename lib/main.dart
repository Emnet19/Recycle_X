import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (safely catches unconfigured platform errors such as Web)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization skipped/failed: $e');
  }

  runApp(const RecycleXApp());
}

class RecycleXApp extends StatelessWidget {
  const RecycleXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'RecycleX',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,

            // ── Navigation ─────────────────────────────────────────────
            initialRoute: Routes.splash,
            onGenerateRoute: AppRouter.generateRoute,

            // ── Auth-aware redirect after login ────────────────────────
            // When auth state changes and the user is now logged in,
            // the SplashScreen / LoginPage should navigate away.
            // The AuthProvider stream handles this automatically via
            // the router when the user navigates from LoginPage.
          );
        },
      ),
    );
  }
}
