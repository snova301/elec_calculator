import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:elec_facility_calc/src/view/home_page.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart'; // 広告用

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

    /// runApp w/ Riverpod
    runApp(const ProviderScope(child: MyApp()));
  },

      /// クラッシュハンドラ(Flutterフレームワーク内でキャッチされないエラー)
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

/// initiallize provider for setteings
final isDarkmodeProvider = StateProvider((ref) => true);
final bottomNaviSelectProvider = StateProvider((ref) => 0);

/// initiallize provider for cableDesign
var cableDesignElecOutProvider = StateProvider((ref) {
  return TextEditingController(text: '1500');
});
var cableDesignCosFaiProvider = StateProvider((ref) {
  return TextEditingController(text: '80');
});
var cableDesignVoltProvider = StateProvider((ref) {
  return TextEditingController(text: '200');
});
var cableDesignCableLenProvider = StateProvider((ref) {
  return TextEditingController(text: '10');
});
final cableDesignPhaseProvider = StateProvider((ref) => '単相');
final cableDesignCableTypeProvider = StateProvider((ref) => '600V CV-2C');
final cableDesignCurrentProvider = StateProvider((ref) => '0');
final cableDesignCableSizeProvider = StateProvider((ref) => '0');
final cableDesignVoltDropProvider = StateProvider((ref) => '0');
final cableDesignPowerLossProvider = StateProvider((ref) => '0');

/// initiallize provider for conduit design
final conduitListItemProvider = StateProvider((ref) => []);
final conduitCableSizeListProvider = StateProvider((ref) => []);
final conduitConduitTypeProvider = StateProvider((ref) => 'PF管');
final conduitConduitSize32Provider = StateProvider((ref) => '');
final conduitConduitSize48Provider = StateProvider((ref) => '');

/// initiallize provider for elecpower
var elecPowerVoltProvider = StateProvider((ref) {
  return TextEditingController(text: '100');
});
var elecPowerCurrentProvider = StateProvider((ref) {
  return TextEditingController(text: '10');
});
var elecPowerCosFaiProvider = StateProvider((ref) {
  return TextEditingController(text: '80');
});
final elecPowerPhaseProvider = StateProvider((ref) => '単相');
final elecPowerApparentPowerProvider = StateProvider((ref) => '0');
final elecPowerActivePowerProvider = StateProvider((ref) => '0');
final elecPowerReactivePowerProvider = StateProvider((ref) => '0');
final elecPowerSinFaiProvider = StateProvider((ref) => '0');

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

    /// ダークモードの設定読込
    try {
      StateManagerClass().getDarkmodeVal(ref);
    } catch (e) {
      print('getDarkmodeVal Error');
    }

    /// 前回の計算データ読込
    try {
      StateManagerClass().getCalcData(ref);
    } catch (e) {
      print('getCalcData Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = ref.watch(isDarkmodeProvider.state).state;
    print(ref.watch(cableDesignOutProvider).cableSize);
    ref.read(cableDesignOutProvider.notifier).add();
    print(ref.watch(cableDesignOutProvider).cableSize);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '電気設備計算アシスタント',
      home: const MyHomePage(),
      theme: ThemeData(
        brightness: isDarkmode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.green,
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
