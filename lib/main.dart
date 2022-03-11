// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart'; // 広告用

import 'homePage.dart';
import 'settingPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool boolThemeColor = SettingPageState().boolThemeColor;

    return MaterialApp(
      title: '電気設備計算アシスタント',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // fontFamily: "Noto Sans JP",
      ),
      // theme: SettingPageState().boolThemeColor
      //     ? ThemeData.light()
      //     : ThemeData.dark(),
      // theme: boolThemeColor ? ThemeData.dark() : ThemeData.light(),

      // ダークモード対応
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

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
