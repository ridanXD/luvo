import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luvo/main.dart';
import 'package:luvo/views/dashboard_view.dart';

void main() {
  testWidgets('Smoke test login screen render with rounded textfields', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify textfields have rounded border radius (12.0)
    final textFields = tester.widgetList<TextField>(find.byType(TextField));
    for (final tf in textFields) {
      final border = tf.decoration?.border as OutlineInputBorder?;
      expect(border?.borderRadius, BorderRadius.circular(12));
    }
  });

  testWidgets('Email validation requires @ on login', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Enter email without @
    await tester.enterText(find.byType(TextField).at(0), 'invalidemail');
    await tester.enterText(find.byType(TextField).at(1), '123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify error message for missing @
    expect(find.text('Email harus mengandung karakter @'), findsOneWidget);
  });

  testWidgets('Dashboard displays Selamat Datang without Role: User', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: DashboardView(),
    ));

    // Verify 'Selamat Datang' is present
    expect(find.text('Selamat Datang'), findsOneWidget);

    // Verify 'Role: USER' and role texts are NOT present
    expect(find.textContaining('Role:'), findsNothing);
    expect(find.textContaining('USER'), findsNothing);
    expect(find.textContaining('Merchant:'), findsNothing);
    expect(find.textContaining('Akses fitur'), findsNothing);
  });
}
