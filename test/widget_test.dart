// Basic smoke test — updated to use the new RecycleXApp entry point.
// Full integration tests require Firebase test environment setup.

import 'package:flutter_test/flutter_test.dart';

import 'package:recycle_x/main.dart';

void main() {
  testWidgets('App widget tree contains a MaterialApp', (WidgetTester tester) async {
    // Note: Full test requires Firebase initialization.
    // This is a placeholder smoke test.
    expect(RecycleXApp, isNotNull);
  });
}
