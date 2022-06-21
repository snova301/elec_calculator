import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/view/home_page.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_logic.dart';
import 'package:elec_facility_calc/src/view/calc_cable_design_page.dart';
import 'package:elec_facility_calc/src/view/calc_conduit_page.dart';
import 'package:elec_facility_calc/src/view/calc_elec_power_page.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart'; // 広告用

class CalcPage extends ConsumerStatefulWidget {
  const CalcPage({Key? key}) : super(key: key);

  @override
  CalcPageState createState() => CalcPageState();
}

class CalcPageState extends ConsumerState<CalcPage> {
  /// admobの関数定義
  // BannerAd adMyBanner = BannerAd(
  //   adUnitId: 'ca-app-pub-3940256099942544/6300978111', // テスト用
  //   size: AdSize.banner,
  //   request: const AdRequest(),
  //   listener: const BannerAdListener(),
  // )..load();

  @override
  Widget build(BuildContext context) {
    /// 画面情報取得
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final blockWidth = screenWidth / 100 * 20;
    final listViewPadding = screenWidth / 20;
    // final screenHeight = mediaQueryData.size.height;
    // final blockSizeVertical = screenHeight / 100;

    /// 電線管設計用
    int maxNumCable = 10;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            ['ケーブル設計', '電力計算', '電線管設計'][ref.watch(bottomNaviSelectProvider)]),
      ),

      /// bottomNavigationBarで選択されたitemについて
      /// widgetのListから選択し、ListViewを表示する
      body: <Widget>[
        ListViewCableDesign(
          listViewPadding: listViewPadding,
          blockWidth: blockWidth,
        ),
        ListViewElecPower(
          listViewPadding: listViewPadding,
          blockWidth: blockWidth,
        ),
        ListViewConduit(
          listViewPadding: listViewPadding,
          blockWidth: blockWidth,
          maxNumCable: maxNumCable,
        ),
      ][ref.read(bottomNaviSelectProvider)],

      drawer: DrawerContents(context),

      /// bottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services),
            label: 'ケーブル設計',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: '電力計算',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel_rounded),
            label: '電線管設計',
          ),
        ],
        currentIndex: ref.read(bottomNaviSelectProvider),
        onTap: (index) {
          ref.read(bottomNaviSelectProvider.state).state = index;
        },
      ),

      /// 電線管設計のときのみケーブル選択のためfloatingActionButtonを設置
      floatingActionButton: ref.watch(bottomNaviSelectProvider) == 2
          ? FloatingActionButton(
              tooltip: 'ケーブル追加',
              child: const Icon(Icons.add),
              onPressed: () {
                if (ref.read(conduitListItemProvider).length < maxNumCable) {
                  CalcLogic(ref).conduitCableAddRun();
                }
              },
            )
          : null,

      // 広告用のbottomnavigator
      // bottomNavigationBar: Container(
      //   alignment: Alignment.center,
      //   child: AdWidget(ad: adMyBanner),
      //   width: adMyBanner.size.width.toDouble(),
      //   height: adMyBanner.size.height.toDouble(),
      // ),
      // ),
    );
  }
}

/// 計算条件や計算結果の文字表示widget
class SeparateText extends ConsumerWidget {
  final String title;

  const SeparateText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}

/// 相の選択widget
class PhaseSelectCard extends ConsumerWidget {
  final StateProvider provider;

  const PhaseSelectCard({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: const Tooltip(
              message: '選択してください',
              child: Text(
                '電源の相',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(provider.state).state = '単相';
                    ref.read(cableDesignInProvider.notifier).phaseUpdate('単相');
                    print(ref.read(cableDesignInProvider).phase);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        ref.watch(cableDesignInProvider).phase == '単相'
                            ? null
                            : Colors.grey),
                    // ref.watch(provider) == '単相' ? null : Colors.grey),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: const Text('単相'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(provider.state).state = '三相';
                    ref.read(cableDesignInProvider.notifier).phaseUpdate('三相');
                    print(ref.read(cableDesignInProvider).phase);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        ref.watch(cableDesignInProvider).phase == '三相'
                            ? null
                            : Colors.grey),
                    // ref.watch(provider) == '三相' ? null : Colors.grey),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20.0)),
                  ),
                  child: const Text('三相'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// 入力用のwidget
class InputTextCard extends ConsumerWidget {
  final String title;
  final String unit;
  final String message;
  final TextEditingController controller;

  const InputTextCard({
    Key? key,
    required this.title,
    required this.unit,
    required this.message,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Tooltip(
              message: message,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),
          ListTile(
            trailing: Text(
              unit,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            title: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ],
      ),
    );
  }
}

/// 実行ボタンのWidget
class RunElevatedButton extends ConsumerWidget {
  final double paddingSize;
  final TextEditingController provider;

  const RunElevatedButton({
    Key? key,
    required this.paddingSize,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(paddingSize, 0, paddingSize, 0),
      child: ElevatedButton(
        onPressed: () {
          CalcLogic(ref).isCosFaiCorrect(provider.text)
              // CalcLogic(ref).isCosFaiCorrect(ref.read(provider).text)
              ? CalcLogic(ref).selectButtonRun()
              : showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return _CosFaiAlertDialog(context);
                  },
                );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
          padding: MaterialStateProperty.all(const EdgeInsets.all(30.0)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        child: const Text(
          '計算実行',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

/// 結果用のwidget
class OutputTextCard extends ConsumerWidget {
  final String title;
  final String unit;
  final String result;

  const OutputTextCard({
    Key? key,
    required this.title,
    required this.unit,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          ListTile(
            title: Text(result, textAlign: TextAlign.right),
            trailing: result == '規格なし'
                ? const Text('')
                : Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// 力率が0-100%の範囲内にない場合、ポップアップ表示で警告
class _CosFaiAlertDialog extends AlertDialog {
  _CosFaiAlertDialog(BuildContext context)
      : super(
          title: const Text('力率数値異常'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('力率は1-100の間で設定してください。'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
}
