import 'package:elec_facility_calc/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// ページ遷移の確認
  testWidgets(
    'Tap test',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      /// 所定のボタンが存在するか確認
      expect(find.text('ケーブル設計'), findsOneWidget);

      /// 所定のボタンが押す
      await tester.tap(find.text('ケーブル設計'));
      await tester.pumpAndSettle();

      /// ページ遷移できたか確認
      expect(find.text('計算条件'), findsOneWidget);
    },
  );

  /// ケーブル設計の計算確認
  testWidgets(
    'Cable design test',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      /// ページ遷移
      await tester.tap(find.text('ケーブル設計'));
      await tester.pumpAndSettle();

      /// ページ遷移できたか確認
      // expect(find.text('ケーブル長'), findsOneWidget);
      // expect(find.text('計算実行'), findsOneWidget);
      expect(find.text('9.4'), findsNothing);

      /// 計算実行
      await tester.tap(find.text('計算実行'));
      await tester.pumpAndSettle();
      // await tester.pump();

      /// 計算できているか確認
      expect(find.text('9.4'), findsOneWidget);
    },
  );
}
