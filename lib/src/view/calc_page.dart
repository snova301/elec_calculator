import 'package:elec_facility_calc/src/model/data_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:elec_facility_calc/src/view/common_page.dart';
import 'package:elec_facility_calc/src/view/calc_cable_design_page.dart';
import 'package:elec_facility_calc/src/view/calc_conduit_page.dart';
import 'package:elec_facility_calc/src/view/calc_elec_power_page.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_conduit_state.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart'; // 広告用

/// 計算ページ
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

  /// ページ名の取得
  List calcPageNameList = [
    PageNameEnum.cableDesign.title,
    PageNameEnum.elecPower.title,
    PageNameEnum.conduit.title,
  ];

  @override
  void initState() {
    super.initState();
    // calcPageNameList = CalcPageNameEnum.values.map((e) => e.pageName).toList();
  }

  @override
  Widget build(BuildContext context) {
    /// 画面情報取得
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final blockWidth = screenWidth / 100 * 20;
    final listViewPadding = screenWidth / 20;

    /// bottomNavigatorの選択された数値
    final selectedBottomNavi = ref.watch(bottomNaviSelectProvider);

    /// 電線管設計用
    int maxNumCable = 20;

    return Scaffold(
      appBar: AppBar(
        title: Text(calcPageNameList[selectedBottomNavi]),
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
      ][selectedBottomNavi],

      /// drawer
      drawer: const DrawerContents(),

      /// bottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(PageNameEnum.cableDesign.icon),
            label: PageNameEnum.cableDesign.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(PageNameEnum.elecPower.icon),
            label: PageNameEnum.elecPower.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(PageNameEnum.conduit.icon),
            label: PageNameEnum.conduit.title,
          ),
        ],
        currentIndex: selectedBottomNavi,
        onTap: (index) {
          ref.read(bottomNaviSelectProvider.state).state = index;
        },
      ),

      /// 電線管設計のときのみケーブル選択のためfloatingActionButtonを設置
      floatingActionButton:
          calcPageNameList[selectedBottomNavi] == PageNameEnum.conduit.title
              ? FloatingActionButton(
                  tooltip: 'ケーブル追加',
                  child: const Icon(Icons.add),
                  onPressed: () {
                    if (ref.read(conduitCalcProvider).length < maxNumCable) {
                      ref.read(conduitCalcProvider.notifier).addCable();
                      ref.read(conduitCalcProvider.notifier).calcCableArea();
                    } else {
                      /// snackbarで警告
                      SnackBarAlert(context: context).snackbar('これ以上追加できません');
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
  final String title; // 入力文字列

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
class CalcPhaseSelectCard extends ConsumerWidget {
  final String phase;
  final Function(String value) onPressedFunc;

  const CalcPhaseSelectCard({
    Key? key,
    required this.phase,
    required this.onPressedFunc,
  }) : super(key: key);

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

          /// 単相 or 三相の選択row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /// 単相
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PhaseNameEnum.single.phase);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.single.phase
                            ? Colors.green
                            : null),
                    foregroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.single.phase
                            ? Colors.white
                            : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Text(PhaseNameEnum.single.phase),
                ),
              ),

              /// 三相
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PhaseNameEnum.three.phase);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.three.phase
                            ? Colors.green
                            : null),
                    foregroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.three.phase
                            ? Colors.white
                            : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20.0)),
                  ),
                  child: Text(PhaseNameEnum.three.phase),
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
  final String title; // タイトル
  final String unit; // 単位
  final String message; // tooltip用メッセージ
  final TextEditingController controller; // TextEditingController

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
          /// タイトル
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

          /// 表示
          ListTile(
            title: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 18,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            trailing: Text(
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

/// 結果用のwidget
class OutputTextCard extends ConsumerWidget {
  final String title; // 出力タイトル
  final String unit; // 単位
  final String result; // 出力結果

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
          /// タイトル
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

          /// 結果表示
          ListTile(
            title: Text(
              result,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
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

/// 実行ボタンのWidget
class CalcRunButton extends ConsumerWidget {
  final double paddingSize;
  final Function() func;

  const CalcRunButton({
    Key? key,
    required this.paddingSize,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(paddingSize, 0, paddingSize, 0),
      child: ElevatedButton(
        onPressed: () {
          func();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(const EdgeInsets.all(30.0)),
        ),
        child: const Text(
          '計算実行',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

/// 数値が異常の場合、エラーダイアログを出す
/// [使い方]
/// showDialog<void>(
///   context: context,
///   builder: (BuildContext context) {
///     return const CorrectAlertDialog();
///   },
/// );
class CorrectAlertDialog extends StatelessWidget {
  const CorrectAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('入力数値異常'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('入力した数値を確認してください。'),
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
}
