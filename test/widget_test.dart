import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Tap test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(const MyHomePage());
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('ケーブル設計'), findsOneWidget);
    // expect(find.text('1'), findsNothing);
    await tester.tap(find.text('ケーブル設計'));
    await tester.pump();

    expect(find.text('計算条件'), findsOneWidget);
    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
