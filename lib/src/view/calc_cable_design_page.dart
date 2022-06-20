import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
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
    print(ref.watch(cableDesignInProvider).elecOut);
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
          controller: ref.watch(cableDesignInProvider).elecOut,
        ),
        InputTextCard(
          title: '線間電圧',
          unit: 'V',
          message: '整数のみ',
          controller: ref.watch(cableDesignInProvider).volt,
        ),
        InputTextCard(
          title: '力率',
          unit: '%',
          message: '整数のみ',
          controller: ref.watch(cableDesignInProvider).cosfai,
        ),
        InputTextCard(
          title: 'ケーブル長',
          unit: 'm',
          message: '整数のみ',
          controller: ref.watch(cableDesignInProvider).cableLength,
        ),

        /// 計算実行ボタン
        RunElevatedButton(
            paddingSize: blockWidth,
            provider: ref.watch(cableDesignInProvider).cosfai),
        // paddingSize: blockWidth, provider: cableDesignCosFaiProvider),

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

/// ケーブル種類選択widget
class CableDeignSelectCableType extends ConsumerWidget {
  const CableDeignSelectCableType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: const Tooltip(
              message: 'ドロップダウンから選択してください',
              child: Text(
                'ケーブル種類',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: DropdownButton(
              value: ref.watch(cableDesignInProvider).cableType,
              items: <String>['600V CV-2C', '600V CV-3C', '600V CVT', 'IV']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: AlignmentDirectional.centerStart,
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                ref
                    .read(cableDesignInProvider.notifier)
                    .cableTypeUpdate(value!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
