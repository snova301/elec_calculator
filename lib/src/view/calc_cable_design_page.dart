import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elec_facility_calc/src/view/calc_page.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_logic.dart';

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

        /// 相選択
        const CalcDesignPhaseSelectCard(),

        /// ケーブル種類選択
        const CableDeignSelectCableType(),

        /// 電気容量入力
        InputTextCard(
          title: '電気容量',
          unit: 'W',
          message: '整数のみ',
          controller: ref.watch(cableDesignProvider).elecOut,
        ),

        /// 線間電圧入力
        InputTextCard(
          title: '線間電圧',
          unit: 'V',
          message: '整数のみ',
          controller: ref.watch(cableDesignProvider).volt,
        ),

        /// 力率入力
        InputTextCard(
          title: '力率',
          unit: '%',
          message: '整数のみ',
          controller: ref.watch(cableDesignProvider).cosfai,
        ),

        /// ケーブル長入力
        InputTextCard(
          title: 'ケーブル長',
          unit: 'm',
          message: '整数のみ',
          controller: ref.watch(cableDesignProvider).cableLength,
        ),

        /// 計算実行ボタン
        CableDesignRunButton(paddingSize: blockWidth),

        /// 結果表示
        const SeparateText(title: '計算結果'),

        /// 電流表示
        OutputTextCard(
          title: '電流',
          unit: 'A',
          result: ref.watch(cableDesignProvider).current,
        ),

        /// ケーブルサイズ表示
        OutputTextCard(
          title: ref.watch(cableDesignProvider).cableType,
          unit: 'mm2',
          result: ref.watch(cableDesignProvider).cableSize,
        ),

        /// 電圧降下表示
        OutputTextCard(
          title: '電圧降下',
          unit: 'V',
          result: ref.watch(cableDesignProvider).voltDrop,
        ),

        /// 電力損失表示
        OutputTextCard(
          title: '電力損失',
          unit: 'W',
          result: ref.watch(cableDesignProvider).powerLoss,
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
          /// テキスト表示
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

          /// ドロップダウンから選択
          Align(
            alignment: Alignment.center,
            child: DropdownButton(
              value: ref.watch(cableDesignProvider).cableType,
              items: CableData()
                  .cableTypeList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: AlignmentDirectional.centerStart,
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                ref.read(cableDesignProvider.notifier).updateCableType(value!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 相の選択widget
class CalcDesignPhaseSelectCard extends ConsumerWidget {
  const CalcDesignPhaseSelectCard({Key? key}) : super(key: key);

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
                    ref.read(cableDesignProvider.notifier).updatePhase('単相');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        ref.watch(cableDesignProvider).phase == '単相'
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
                    ref.read(cableDesignProvider.notifier).updatePhase('三相');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        ref.watch(cableDesignProvider).phase == '三相'
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

/// 実行ボタンのWidget
class CableDesignRunButton extends ConsumerWidget {
  final double paddingSize;

  const CableDesignRunButton({
    Key? key,
    required this.paddingSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(paddingSize, 0, paddingSize, 0),
      child: ElevatedButton(
        onPressed: () {
          final cosFai = ref.watch(cableDesignProvider).cosfai.text;
          CalcLogic().isCosFaiCorrect(cosFai)
              ? ref.read(cableDesignProvider.notifier).run()
              : showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const CosFaiAlertDialog();
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
