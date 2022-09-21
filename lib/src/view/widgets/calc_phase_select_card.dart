import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 相の選択widget
class CalcPhaseSelectCard extends ConsumerWidget {
  final String phase;
  final Function(PhaseNameEnum value) onPressedFunc;

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
          /// タイトル
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
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                /// 単相2線
                ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PhaseNameEnum.single);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.single.str
                            ? Colors.green
                            : null),
                    foregroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.single.str
                            ? Colors.white
                            : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Text(PhaseNameEnum.single.str),
                ),

                /// 単相3線
                ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PhaseNameEnum.singlePhaseThreeWire);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.singlePhaseThreeWire.str
                            ? Colors.green
                            : null),
                    foregroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.singlePhaseThreeWire.str
                            ? Colors.white
                            : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Text(PhaseNameEnum.singlePhaseThreeWire.str),
                ),

                /// 三相3線
                ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PhaseNameEnum.three);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.three.str ? Colors.green : null),
                    foregroundColor: MaterialStateProperty.all(
                        phase == PhaseNameEnum.three.str ? Colors.white : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20.0)),
                  ),
                  child: Text(PhaseNameEnum.three.str),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
