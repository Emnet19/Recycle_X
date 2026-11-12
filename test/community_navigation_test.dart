import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:recycle_x/components/customer_bottom_nav.dart';
import 'package:recycle_x/core/constants/app_strings.dart';
import 'package:recycle_x/core/routing/app_router.dart';
import 'package:recycle_x/features/auth/providers/auth_provider.dart';
import 'package:recycle_x/features/collector/presentation/pages/community_collector_home_page.dart';

void main() {
  late AuthProvider auth;

  setUpAll(() async {
    auth = AuthProvider();
    await auth.loginAsDemo(AppStrings.roleCommunityCollector);
  });

  tearDownAll(() => auth.dispose());

  Widget buildApp() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: auth,
      child: const MaterialApp(
        onGenerateRoute: AppRouter.generateRoute,
        home: CommunityCollectorHomePage(),
      ),
    );
  }

  Future<void> openProfileAndGoBack(WidgetTester tester) async {
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomerBottomNav), findsNothing);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
  }

  testWidgets('profile back and all tabs stay in the Community section',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await openProfileAndGoBack(tester);
    expect(find.text('Community Actions'), findsOneWidget);

    await tester.tap(find.text('Drop-offs'));
    await tester.pumpAndSettle();
    expect(find.text('Community Drop-offs'), findsOneWidget);

    await openProfileAndGoBack(tester);
    expect(find.text('Community Drop-offs'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Community Actions'), findsOneWidget);

    await tester.tap(find.text('Drives'));
    await tester.pumpAndSettle();
    expect(find.text('Clean-up Drives'), findsOneWidget);
  });

  testWidgets('Community home has no overflow on a compact screen',
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
