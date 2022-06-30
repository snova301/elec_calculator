import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';
import 'package:elec_facility_calc/ads_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:elec_facility_calc/src/view/home_page.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';

/// プラットフォームの確認
final isAndroid =
    defaultTargetPlatform == TargetPlatform.android ? true : false;
final isIOS = defaultTargetPlatform == TargetPlatform.iOS ? true : false;

void main() async {
  /// クラッシュハンドラ
  runZonedGuarded<Future<void>>(() async {
    /// Firebaseの初期化
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// クラッシュハンドラ(Flutterフレームワーク内でスローされたすべてのエラー)
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    /// Admobの初期化
    if (isAndroid || isIOS) {
      MobileAds.instance.initialize();
    }

    /// runApp w/ Riverpod
    runApp(const ProviderScope(child: MyApp()));
  },

      /// クラッシュハンドラ(Flutterフレームワーク内でキャッチされないエラー)
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

/// App settings
class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    /// shared_preferencesの設定読込
    try {
      StateManagerClass().getPrefs(ref);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(settingProvider).darkMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '電気設備計算アシスタント',
      home: const MyHomePage(),
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.green,
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ButtonStyle(
        //     backgroundColor: MaterialStateProperty.all(Colors.green),
        //   ),
        // ),
        fontFamily: 'NotoSansJP',
        useMaterial3: true,
      ),

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
    );
  }
}
