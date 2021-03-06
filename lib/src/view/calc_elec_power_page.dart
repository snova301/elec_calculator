import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';
import 'package:elec_facility_calc/src/view/common_widgets.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/view/calc_widgets.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_elec_power_state.dart';

/// 電力計算ページ
class CalcElecPowerPage extends ConsumerStatefulWidget {
  const CalcElecPowerPage({Key? key}) : super(key: key);

  @override
  CalcElecPowerPageState createState() => CalcElecPowerPageState();
}

class CalcElecPowerPageState extends ConsumerState<CalcElecPowerPage> {
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
    AdsSettingsClass().initElecPowerRec();

    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(elecPowerSPSetProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            PageNameEnum.elecPower.title,
          ),
        ),
        body: Row(
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

                  /// 相選択
                  CalcPhaseSelectCard(
                    phase: ref.watch(elecPowerProvider).phase.str,
                    onPressedFunc: (PhaseNameEnum value) =>
                        ref.read(elecPowerProvider.notifier).updatePhase(value),
                  ),

                  /// 電圧入力
                  InputTextCard(
                    title: '線間電圧',
                    unit: ref.watch(elecPowerProvider).voltUnit.str,
                    message: '整数のみ',
                    controller: ref.watch(elecPowerTxtCtrVoltProvider),
                    onPressedVoltUnitFunc: (VoltUnitEnum value) => ref
                        .read(elecPowerProvider.notifier)
                        .updateVoltUnit(value),
                  ),

                  /// 電流値入力
                  InputTextCard(
                    title: '電流',
                    unit: 'A',
                    message: '整数のみ',
                    controller: ref.watch(elecPowerTxtCtrCurrentProvider),
                  ),

                  /// 力率入力
                  InputTextCard(
                    title: '力率',
                    unit: '%',
                    message: '1-100%の整数のみ',
                    controller: ref.watch(elecPowerTxtCtrCosFaiProvider),
                  ),

                  /// 計算実行ボタン
                  CalcRunButton(
                    // paddingSize: blockWidth,
                    func: () {
                      /// textcontrollerのデータを取得
                      final volt = ref.read(elecPowerTxtCtrVoltProvider).text;
                      final current =
                          ref.read(elecPowerTxtCtrCurrentProvider).text;
                      final cosFai =
                          ref.read(elecPowerTxtCtrCosFaiProvider).text;

                      /// 実行できるか確認
                      bool isRunCheck = ref
                          .read(elecPowerProvider.notifier)
                          .isRunCheck(volt, current, cosFai);

                      /// 実行可能なら計算実行
                      if (isRunCheck) {
                        ref.watch(elecPowerProvider.notifier).run();
                      } else {
                        /// 実行不可能ならエラーダイアログ
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return const CorrectAlertDialog();
                          },
                        );
                      }
                    },
                  ),

                  /// 広告表示
                  existAds ? const ElecPowerRecBannerContainer() : Container(),

                  /// 結果表示
                  const SeparateText(title: '計算結果'),

                  /// 単位選択
                  CalcPowerUnitSelectCard(
                    powerUnit: ref.watch(elecPowerProvider).powerUnit.str,
                    onPressedFunc: (PowerUnitEnum value) => ref
                        .read(elecPowerProvider.notifier)
                        .updatePowerUnit(value),
                  ),

                  /// 皮相電力
                  OutputTextCard(
                    title: '皮相電力',
                    unit: ref.watch(elecPowerProvider).powerUnit.strApparent,
                    result: ref.watch(elecPowerApparentPowerProvider),
                  ),

                  /// 有効電力
                  OutputTextCard(
                    title: '有効電力',
                    unit: ref.watch(elecPowerProvider).powerUnit.strActive,
                    result: ref.watch(elecPowerActivePowerProvider),
                  ),

                  /// 無効電力
                  OutputTextCard(
                    title: '無効電力',
                    unit: ref.watch(elecPowerProvider).powerUnit.strReactive,
                    result: ref.watch(elecPowerReactivePowerProvider),
                  ),

                  /// sinφ
                  OutputTextCard(
                    title: 'sinφ',
                    unit: '%',
                    result: ref.watch(elecPowerSinFaiProvider),
                  ),
                ],
              ),
            ),
          ],
        ),

        /// drawer
        drawer: isDrawerFixed ? null : const DrawerContents(),
      ),
    );
  }
}
