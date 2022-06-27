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
    return ListView(
      padding: EdgeInsets.fromLTRB(listViewPadding, 10, listViewPadding, 10),
      children: <Widget>[
        /// 入力表示
        const SeparateText(title: '計算条件'),

        /// 相選択
        const ElecPowerPhaseSelectCard(),

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
        ElecPowerRunButton(paddingSize: blockWidth),

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
      ],
    );
  }
}

/// 相の選択widget
class ElecPowerPhaseSelectCard extends ConsumerWidget {
  const ElecPowerPhaseSelectCard({Key? key}) : super(key: key);

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
                    ref.read(elecPowerProvider.notifier).updatePhase('単相');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        ref.watch(elecPowerProvider).phase == '単相'
                            ? null
                            : Colors.grey),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: const Text('単相'),
                ),
              ),

              /// 三相
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(elecPowerProvider.notifier).updatePhase('三相');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        ref.watch(elecPowerProvider).phase == '三相'
                            ? null
                            : Colors.grey),
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
class ElecPowerRunButton extends ConsumerWidget {
  final double paddingSize;

  const ElecPowerRunButton({
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
