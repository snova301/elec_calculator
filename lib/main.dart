import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart'; // 広告用
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'homePage.dart';

void main() {
  // runApp(MyApp());
  runApp(ProviderScope(child: MyApp()));
}

final counterProvider = StateProvider((ref) => true);

class MyApp extends ConsumerWidget {
// class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  bool boolThemeColor = false;

  @override
  // Widget build(BuildContext context) {
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider.state).state;

    return MaterialApp(
      title: '電気設備計算アシスタント',
      theme: count
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.green,
              // fontFamily: "Noto Sans JP",
            ),

      // ダークモード対応
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.system,

      // 中華系フォント対策
      locale: const Locale("ja", "JP"),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ja", "JP"),
      ],

      // ページタイトル
      home: const MyHomePage(title: '計算画面'),
    );
  }
}
