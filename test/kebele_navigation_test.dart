import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:recycle_x/components/customer_bottom_nav.dart';
import 'package:recycle_x/core/constants/app_strings.dart';
import 'package:recycle_x/core/routing/app_router.dart';
import 'package:recycle_x/features/auth/providers/auth_provider.dart';
import 'package:recycle_x/features/collector/presentation/pages/kebele_collector_home_page.dart';

void main() {
  late AuthProvider auth;

  setUpAll(() async {
    auth = AuthProvider();
    await auth.loginAsDemo(AppStrings.roleKebeleCollector);
  });

  tearDownAll(() => auth.dispose());

  Widget buildApp() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: auth,
      child: const MaterialApp(
        onGenerateRoute: AppRouter.generateRoute,
        home: KebeleCollectorHomePage(),
      ),
    );
  }

  testWidgets('profile back keeps every bottom tab in the Kebele section',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomerBottomNav), findsNothing);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    expect(find.text('Kebele Operations'), findsOneWidget);

    await tester.tap(find.text('Zone Routes'));
    await tester.pumpAndSettle();
    expect(find.textContaining('assigned routes in your kebele zone'),
        findsOneWidget);

    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    expect(find.text('Pickup Requests'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Kebele Operations'), findsOneWidget);
  });

  testWidgets('Kebele home has no overflow on a compact screen',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
