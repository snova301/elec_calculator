import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 電力単位の接頭語選択widget
/// VA or Wを選択
class CalcPowerTypeSelectCard extends ConsumerWidget {
  final String powerType;
  final Function(PowerTypeEnum value) onPressedFunc;

  const CalcPowerTypeSelectCard({
    Key? key,
    required this.powerType,
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
                '電力種類の選択',
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
                /// 皮相電力 VA
                ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PowerTypeEnum.apparent);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        powerType == PowerTypeEnum.apparent.str
                            ? Colors.green
                            : null),
                    foregroundColor: MaterialStateProperty.all(
                        powerType == PowerTypeEnum.apparent.str
                            ? Colors.white
                            : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20.0)),
                  ),
                  child: Text(PowerTypeEnum.apparent.str),
                ),

                /// 有効電力 W
                ElevatedButton(
                  onPressed: () {
                    onPressedFunc(PowerTypeEnum.active);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        powerType == PowerTypeEnum.active.str
                            ? Colors.green
                            : null),
                    foregroundColor: MaterialStateProperty.all(
                        powerType == PowerTypeEnum.active.str
                            ? Colors.white
                            : null),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20.0)),
                  ),
                  child: Text(PowerTypeEnum.active.str),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
