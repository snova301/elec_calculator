import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:elec_facility_calc/src/notifiers/calc_elec_rate_state.dart';
import 'package:elec_facility_calc/src/view/widgets/calc_power_unit_appa_select_card.dart';
import 'package:elec_facility_calc/src/view/widgets/calc_power_unit_select_card.dart';
import 'package:elec_facility_calc/src/view/widgets/drawer_contents_widget.dart';
import 'package:elec_facility_calc/src/view/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/src/notifiers/state_manager.dart';
import 'package:elec_facility_calc/src/view/widgets/calc_phase_select_card.dart';
import 'package:elec_facility_calc/src/view/widgets/calc_run_button_widget.dart';
import 'package:elec_facility_calc/src/view/widgets/correct_alert_dialog_widget.dart';
import 'package:elec_facility_calc/src/view/widgets/input_text_card_widget.dart';
import 'package:elec_facility_calc/src/view/widgets/output_text_card_widget.dart';
import 'package:elec_facility_calc/src/view/widgets/separate_text_widget.dart';
import 'package:elec_facility_calc/src/notifiers/calc_elec_power_state.dart';

/// 需要率計算ページ
class CalcElecRatePage extends ConsumerStatefulWidget {
  const CalcElecRatePage({Key? key}) : super(key: key);

  @override
  CalcElecRatePageState createState() => CalcElecRatePageState();
}

class CalcElecRatePageState extends ConsumerState<CalcElecRatePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  /// tabcontollerの設定
  /// vsyncのためにTickerProviderStateMixinが必要
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// 画面情報取得
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    // final blockWidth = screenWidth / 100 * 20;
    final listViewPadding = screenWidth / 20;

    /// レスポンシブ設定
    bool isDrawerFixed = checkResponsive(screenWidth);

    /// 広告の初期化
    AdsSettingsClass().initRecBanner();

    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(elecPowerSPSetProvider);

    /// 入力されている文字をNotifierへ通知するためのローカル関数
    void runCheckFunc() {
      ref.read(elecRateProvider.notifier).isRunCheck(
            ref.watch(elecRateTxtCtrAllInstCapaProvider).text,
          );
    }

    /// 文字入力中に画面の別の部分をタップしたら入力が完了する
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        runCheckFunc();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            PageNameEnum.elecRate.title,
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                child: Text(
                  '需要率計算',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '最大需要電力計算',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Row(
              children: [
                /// 画面幅が規定以上でメニューを左側に固定
                isDrawerFixed ? const DrawerContentsFixed() : Container(),

                /// サイズ指定されていないとエラーなのでExpandedで囲む
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                        listViewPadding, 10, listViewPadding, 10),
                    children: <Widget>[
                      /// 入力表示
                      const SeparateText(title: '計算条件'),

                      /// 接頭語単位選択
                      CalcPowerUnitSelectCard(
                          powerUnit:
                              ref.watch(elecRateProvider).ratePowerUnit.str,
                          onPressedFunc: (PowerUnitEnum value) {
                            // タップして変更した場合にすでに入力されている他の数値も通知
                            runCheckFunc();
                            ref
                                .read(elecRateProvider.notifier)
                                .updateRatePowerUnit(value);
                          }),

                      /// 電力種類選択
                      CalcPowerTypeSelectCard(
                          powerType:
                              ref.watch(elecRateProvider).ratePowerType.str,
                          onPressedFunc: (PowerTypeEnum value) {
                            // タップして変更した場合にすでに入力されている他の数値も通知
                            runCheckFunc();
                            ref
                                .read(elecRateProvider.notifier)
                                .updateRatePowerType(value);
                          }),

                      /// 全設備容量入力
                      InputTextCard(
                        title: '全設備容量',
                        unit:
                            ref.watch(elecRateProvider).ratePowerUnit.strMark +
                                ref.watch(elecRateProvider).ratePowerType.str,
                        message: '整数のみ',
                        controller:
                            ref.watch(elecRateTxtCtrAllInstCapaProvider),
                      ),

                      // /// 計算実行ボタン
                      // CalcRunButton(
                      //   // paddingSize: blockWidth,
                      //   func: () {
                      //     /// textcontrollerのデータを取得
                      //     final volt =
                      //         ref.read(elecPowerTxtCtrVoltProvider).text;
                      //     final current =
                      //         ref.read(elecPowerTxtCtrCurrentProvider).text;
                      //     final cosFai =
                      //         ref.read(elecPowerTxtCtrCosFaiProvider).text;

                      //     /// 実行できるか確認
                      //     bool isRunCheck = ref
                      //         .read(elecPowerProvider.notifier)
                      //         .isRunCheck(volt, current, cosFai);

                      //     /// 実行可能なら計算実行
                      //     if (isRunCheck) {
                      //       ref.watch(elecPowerProvider.notifier).run();
                      //     } else {
                      //       /// 実行不可能ならエラーダイアログ
                      //       showDialog<void>(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return const CorrectAlertDialog();
                      //         },
                      //       );
                      //     }
                      //   },
                      // ),

                      // /// 広告表示
                      // existAds ? const RecBannerContainer() : Container(),

                      // /// 結果表示
                      // const SeparateText(title: '計算結果'),

                      // /// 皮相電力
                      // OutputTextCard(
                      //   title: '皮相電力',
                      //   unit:
                      //       ref.watch(elecPowerProvider).powerUnit.strApparent,
                      //   result: ref.watch(elecPowerApparentPowerProvider),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                /// 画面幅が規定以上でメニューを左側に固定
                isDrawerFixed ? const DrawerContentsFixed() : Container(),

                /// サイズ指定されていないとエラーなのでExpandedで囲む
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                        listViewPadding, 10, listViewPadding, 10),
                    children: const <Widget>[
                      /// 入力表示
                      SeparateText(title: '計算条件'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        /// drawer
        drawer: isDrawerFixed ? null : const DrawerContents(),
      ),
    );
  }
}
