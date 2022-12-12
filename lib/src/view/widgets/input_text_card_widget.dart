import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 入力用のwidget
class InputTextCard extends ConsumerWidget {
  /// タイトル
  final String title;

  /// 単位
  final String? unit;

  /// tooltip用メッセージ
  final String message;

  /// TextEditingController
  final TextEditingController? controller;

  /// 電圧の単位選択
  final Function(VoltUnitEnum value)? onPressedVoltUnitFunc;

  /// 電力の単位選択
  final Function(PowerUnitEnum value)? onPressedPowerUnitFunc;

  const InputTextCard({
    Key? key,
    required this.title,
    this.unit,
    required this.message,
    this.controller,
    this.onPressedVoltUnitFunc,
    this.onPressedPowerUnitFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// タイトル
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Tooltip(
              message: message,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),

          /// 表示
          controller != null && unit != null
              ? ListTile(
                  title: TextField(
                    controller: controller,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  trailing: Text(
                    unit!,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                )
              : Container(),

          /// 電圧単位の選択
          onPressedVoltUnitFunc != null
              ? Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 文字
                      const Text(
                        '電圧単位',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),

                      /// 選択用ボタン
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// 単位v
                          /// 単位が選択されていたら緑に反転
                          ElevatedButton(
                            onPressed: () {
                              onPressedVoltUnitFunc!(VoltUnitEnum.v);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  unit == VoltUnitEnum.v.str
                                      ? Colors.green
                                      : null),
                              foregroundColor: MaterialStateProperty.all(
                                  unit == VoltUnitEnum.v.str
                                      ? Colors.white
                                      : null),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20)),
                            ),
                            child: Text(VoltUnitEnum.v.str),
                          ),

                          /// 単位kV
                          /// 単位が選択されていたら緑に反転
                          ElevatedButton(
                            onPressed: () {
                              onPressedVoltUnitFunc!(VoltUnitEnum.kv);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  unit == VoltUnitEnum.kv.str
                                      ? Colors.green
                                      : null),
                              foregroundColor: MaterialStateProperty.all(
                                  unit == VoltUnitEnum.kv.str
                                      ? Colors.white
                                      : null),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20)),
                            ),
                            child: Text(VoltUnitEnum.kv.str),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),

          /// 電力単位の選択
          onPressedPowerUnitFunc != null
              ? Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 文字
                      const Text(
                        '電力単位',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),

                      /// 選択用ボタン
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          /// 単位W
                          /// 単位が選択されていたら緑に反転
                          ElevatedButton(
                            onPressed: () {
                              onPressedPowerUnitFunc!(PowerUnitEnum.w);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  unit == PowerUnitEnum.w.strActive
                                      ? Colors.green
                                      : null),
                              foregroundColor: MaterialStateProperty.all(
                                  unit == PowerUnitEnum.w.strActive
                                      ? Colors.white
                                      : null),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20)),
                            ),
                            child: Text(PowerUnitEnum.w.strActive),
                          ),

                          /// 単位kW
                          /// 単位が選択されていたら緑に反転
                          ElevatedButton(
                            onPressed: () {
                              onPressedPowerUnitFunc!(PowerUnitEnum.kw);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  unit == PowerUnitEnum.kw.strActive
                                      ? Colors.green
                                      : null),
                              foregroundColor: MaterialStateProperty.all(
                                  unit == PowerUnitEnum.kw.strActive
                                      ? Colors.white
                                      : null),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20)),
                            ),
                            child: Text(PowerUnitEnum.kw.strActive),
                          ),

                          /// 単位MW
                          /// 単位が選択されていたら緑に反転
                          ElevatedButton(
                            onPressed: () {
                              onPressedPowerUnitFunc!(PowerUnitEnum.mw);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  unit == PowerUnitEnum.mw.strActive
                                      ? Colors.green
                                      : null),
                              foregroundColor: MaterialStateProperty.all(
                                  unit == PowerUnitEnum.mw.strActive
                                      ? Colors.white
                                      : null),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20)),
                            ),
                            child: Text(PowerUnitEnum.mw.strActive),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
