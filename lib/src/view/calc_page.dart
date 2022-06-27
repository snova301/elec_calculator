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
    int maxNumCable = 10;

    return Scaffold(
      appBar: AppBar(
        title: Text(['ケーブル設計', '電力計算', '電線管設計'][selectedBottomNavi]),
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
        currentIndex: selectedBottomNavi,
        onTap: (index) {
          ref.read(bottomNaviSelectProvider.state).state = index;
        },
      ),

      /// 電線管設計のときのみケーブル選択のためfloatingActionButtonを設置
      floatingActionButton: selectedBottomNavi == 2
          ? FloatingActionButton(
              tooltip: 'ケーブル追加',
              child: const Icon(Icons.add),
              onPressed: () {
                if (ref.read(conduitCalcProvider).items.length < maxNumCable) {
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
