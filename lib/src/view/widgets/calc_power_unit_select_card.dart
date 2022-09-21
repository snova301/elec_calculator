import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 電力の単位の接頭語選択widget
class CalcPowerUnitSelectCard extends ConsumerWidget {
  final String powerUnit;
  final Function(PowerUnitEnum value) onPressedFunc;

  const CalcPowerUnitSelectCard({
    Key? key,
    required this.powerUnit,
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
                '単位の接頭語',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),

          /// 選択row
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                /// 単位なし
                ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PowerUnitEnum.w);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        powerUnit == PowerUnitEnum.w.str ? Colors.green : null),
                    foregroundColor: MaterialStateProperty.all(
                        powerUnit == PowerUnitEnum.w.str ? Colors.white : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  child: Text(PowerUnitEnum.w.str),
                ),

                /// kオーダー
                ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PowerUnitEnum.kw);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        powerUnit == PowerUnitEnum.kw.str
                            ? Colors.green
                            : null),
                    foregroundColor: MaterialStateProperty.all(
                        powerUnit == PowerUnitEnum.kw.str
                            ? Colors.white
                            : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20.0)),
                  ),
                  child: Text(PowerUnitEnum.kw.str),
                ),

                /// Mオーダー
                ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PowerUnitEnum.mw);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        powerUnit == PowerUnitEnum.mw.str
                            ? Colors.green
                            : null),
                    foregroundColor: MaterialStateProperty.all(
                        powerUnit == PowerUnitEnum.mw.str
                            ? Colors.white
                            : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20.0)),
                  ),
                  child: Text(PowerUnitEnum.mw.str),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
