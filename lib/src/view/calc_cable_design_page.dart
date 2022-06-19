import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/view/calc_page.dart';

/// ケーブル設計のListView Widget
class ListViewCableDesign extends ConsumerWidget {
  final double listViewPadding;
  final double blockWidth;

  const ListViewCableDesign(
      {Key? key, required this.listViewPadding, required this.blockWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.fromLTRB(listViewPadding, 10, listViewPadding, 10),
      children: <Widget>[
        /// 入力表示
        const SeparateText(title: '計算条件'),
        PhaseSelectCard(provider: cableDesignPhaseProvider),
        const CableDeignSelectCableType(),
        InputTextCard(
          title: '電気容量',
          unit: 'W',
          message: '整数のみ',
          provider: cableDesignElecOutProvider,
        ),
        InputTextCard(
          title: '線間電圧',
          unit: 'V',
          message: '整数のみ',
          provider: cableDesignVoltProvider,
        ),
        InputTextCard(
          title: '力率',
          unit: '%',
          message: '整数のみ',
          provider: cableDesignCosFaiProvider,
        ),
        InputTextCard(
          title: 'ケーブル長',
          unit: 'm',
          message: '整数のみ',
          provider: cableDesignCableLenProvider,
        ),

        /// 計算実行ボタン
        RunElevatedButton(
            paddingSize: blockWidth, provider: cableDesignCosFaiProvider),

        /// 結果表示
        const SeparateText(title: '計算結果'),
        OutputTextCard(
          title: '電流',
          unit: 'A',
          provider: cableDesignCurrentProvider,
        ),
        OutputTextCard(
          title: ref.watch(cableDesignCableTypeProvider),
          unit: 'mm2',
          provider: cableDesignCableSizeProvider,
        ),

        OutputTextCard(
          title: '電圧降下',
          unit: 'V',
          provider: cableDesignVoltDropProvider,
        ),
        OutputTextCard(
          title: '電力損失',
          unit: 'W',
          provider: cableDesignPowerLossProvider,
        ),
      ],
    );
  }
}
