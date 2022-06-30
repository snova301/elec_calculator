import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/view/calc_page.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_elec_power_state.dart';

/// 電力計算のListView Widget
class ListViewElecPower extends ConsumerWidget {
  final double listViewPadding;
  final double blockWidth;

  const ListViewElecPower(
      {Key? key, required this.listViewPadding, required this.blockWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 広告の初期化
    AdsSettingsClass().initElecPowerRec();

    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(elecPowerSPSetProvider);

    return ListView(
      padding: EdgeInsets.fromLTRB(listViewPadding, 10, listViewPadding, 10),
      children: <Widget>[
        /// 入力表示
        const SeparateText(title: '計算条件'),

        /// 相選択
        CalcPhaseSelectCard(
          phase: ref.watch(elecPowerProvider).phase,
          onPressedFunc: (String value) =>
              ref.read(elecPowerProvider.notifier).updatePhase(value),
        ),

        /// 電圧入力
        InputTextCard(
          title: '線間電圧',
          unit: 'V',
          message: '整数のみ',
          controller: ref.watch(elecPowerTxtCtrVoltProvider),
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
          paddingSize: blockWidth,
          func: () {
            /// textcontrollerのデータを取得
            final volt = ref.watch(elecPowerTxtCtrVoltProvider).text;
            final current = ref.watch(elecPowerTxtCtrCurrentProvider).text;
            final cosFai = ref.watch(elecPowerTxtCtrCosFaiProvider).text;
            if (ref
                .read(elecPowerProvider.notifier)
                .isRunCheck(volt, current, cosFai)) {
              ref.watch(elecPowerProvider.notifier).run(volt, current, cosFai);
            } else {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return const CorrectAlertDialog();
                },
              );
            }
          },
        ),

        /// 結果表示
        const SeparateText(title: '計算結果'),

        /// 皮相電力
        OutputTextCard(
          title: '皮相電力',
          unit: 'kVA',
          result: ref.watch(elecPowerProvider).apparentPower,
        ),

        /// 有効電力
        OutputTextCard(
          title: '有効電力',
          unit: 'kW',
          result: ref.watch(elecPowerProvider).activePower,
        ),

        /// 無効電力
        OutputTextCard(
          title: '無効電力',
          unit: 'kVar',
          result: ref.watch(elecPowerProvider).reactivePower,
        ),

        /// sinφ
        OutputTextCard(
          title: 'sinφ',
          unit: '%',
          result: ref.watch(elecPowerProvider).sinFai,
        ),

        /// 広告表示
        isAndroid || isIOS ? const ElecPowerRecBannerContainer() : Container(),
      ],
    );
  }
}
