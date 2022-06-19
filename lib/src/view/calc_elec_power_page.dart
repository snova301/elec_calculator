import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/view/calc_page.dart';

/// 電力計算のListView Widget
class ListViewElecPower extends ConsumerWidget {
  final double listViewPadding;
  final double blockWidth;

  const ListViewElecPower(
      {Key? key, required this.listViewPadding, required this.blockWidth})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.fromLTRB(listViewPadding, 10, listViewPadding, 10),
      children: <Widget>[
        /// 入力表示
        const SeparateText(title: '計算条件'),
        PhaseSelectCard(provider: elecPowerPhaseProvider),
        InputTextCard(
          title: '線間電圧',
          unit: 'V',
          message: '整数のみ',
          provider: elecPowerVoltProvider,
        ),
        InputTextCard(
          title: '電流',
          unit: 'A',
          message: '整数のみ',
          provider: elecPowerCurrentProvider,
        ),
        InputTextCard(
          title: '力率',
          unit: '%',
          message: '1-100%の整数のみ',
          provider: elecPowerCosFaiProvider,
        ),

        /// 計算実行ボタン
        RunElevatedButton(
            paddingSize: blockWidth, provider: elecPowerCosFaiProvider),

        /// 結果表示
        const SeparateText(title: '計算結果'),
        OutputTextCard(
          title: '皮相電力',
          unit: 'kVA',
          provider: elecPowerApparentPowerProvider,
        ),
        OutputTextCard(
          title: '有効電力',
          unit: 'kW',
          provider: elecPowerActivePowerProvider,
        ),
        OutputTextCard(
          title: '無効電力',
          unit: 'kVar',
          provider: elecPowerReactivePowerProvider,
        ),
        OutputTextCard(
          title: 'sinφ',
          unit: '%',
          provider: elecPowerSinFaiProvider,
        ),
      ],
    );
  }
}
