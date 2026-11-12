import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycle_x/core/constants/app_strings.dart';
import 'package:recycle_x/features/auth/presentation/pages/onboarding_page.dart';

void main() {
  Widget buildTestWidget({Key? key, Size screenSize = const Size(390, 844)}) {
    return MediaQuery(
      data: MediaQueryData(size: screenSize),
      child: MaterialApp(
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Screen')),
        },
        home: OnboardingPage(key: key),
      ),
    );
  }

  group('OnboardingPage Tests', () {
    testWidgets('Screen 1 renders correctly with Skip button and title separated',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Heading 1 present
      expect(find.text(AppStrings.onboarding1Title), findsOneWidget);
      expect(find.text(AppStrings.onboarding1Subtitle), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      // Skip button present and visible
      final skipFinder = find.widgetWithText(TextButton, AppStrings.skip);
      expect(skipFinder, findsOneWidget);

      // Verify Skip button is above the heading with a clear gap (no overlap)
      final skipRect = tester.getRect(skipFinder);
      final titleFinder = find.text(AppStrings.onboarding1Title);
      final titleRect = tester.getRect(titleFinder);

      expect(
        titleRect.top,
        greaterThan(skipRect.bottom),
        reason: 'Heading should be positioned strictly below the Skip button',
      );
      // Clear gap between Skip button and heading
      expect(
        titleRect.top - skipRect.bottom,
        greaterThanOrEqualTo(10.0),
        reason: 'There must be a clear gap between Skip button and heading',
      );
    });

    testWidgets('Screen 2 renders Skip button and title separated',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap Next to go to Screen 2
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();

      // Heading 2 present
      expect(find.text(AppStrings.onboarding2Title), findsOneWidget);
      expect(find.text(AppStrings.onboarding2Subtitle), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      // Skip button still visible
      final skipFinder = find.widgetWithText(TextButton, AppStrings.skip);
      expect(skipFinder, findsOneWidget);

      final skipVisibility = tester.widget<Visibility>(
        find.ancestor(of: skipFinder, matching: find.byType(Visibility)),
      );
      expect(skipVisibility.visible, isTrue);

      final skipRect = tester.getRect(skipFinder);
      final titleFinder = find.text(AppStrings.onboarding2Title);
      final titleRect = tester.getRect(titleFinder);

      expect(
        titleRect.top,
        greaterThan(skipRect.bottom),
        reason: 'Heading 2 should be positioned strictly below the Skip button',
      );
    });

    testWidgets('Screen 3 hides Skip button and shows Get Started',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Page 1 -> Page 2
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();

      // Page 2 -> Page 3
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();

      // Heading 3 present
      expect(find.text(AppStrings.onboarding3Title), findsOneWidget);
      expect(find.text(AppStrings.onboarding3Subtitle), findsOneWidget);

      // Button changes to 'Get Started'
      expect(find.text(AppStrings.getStarted), findsOneWidget);
      expect(find.text('Next'), findsNothing);

      // Skip button must be HIDDEN on final screen
      final skipFinder = find.widgetWithText(TextButton, AppStrings.skip);
      final skipVisibility = tester.widget<Visibility>(
        find.ancestor(of: skipFinder, matching: find.byType(Visibility)),
      );
      expect(
        skipVisibility.visible,
        isFalse,
        reason: 'Skip button must be hidden on the final onboarding screen',
      );
    });

    testWidgets('Skip button navigates to /login from screen 1',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, AppStrings.skip));
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('Get Started navigates to /login from final screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Advance to screen 3
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();

      // Tap Get Started
      await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.getStarted));
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('Responsive across smaller and larger device sizes without overflow',
        (WidgetTester tester) async {
      final screenSizes = [
        const Size(360, 640), // small device
        const Size(390, 844), // standard iPhone
        const Size(412, 915), // large Android
      ];

      for (int i = 0; i < screenSizes.length; i++) {
        final size = screenSizes[i];
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(buildTestWidget(key: ValueKey(i), screenSize: size));
        await tester.pumpAndSettle();

        // Check screen 1
        expect(tester.takeException(), isNull);

        // Check screen 2
        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Check screen 3
        await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text(AppStrings.getStarted), findsOneWidget);
      }
      tester.view.resetPhysicalSize();
    });
  });
}
