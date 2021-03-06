import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';

/// 計算ページ
/// 計算条件や計算結果の文字表示widget
class SeparateText extends ConsumerWidget {
  final String title; // 入力文字列

  const SeparateText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}

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

/// 入力用のwidget
class InputTextCard extends ConsumerWidget {
  final String title; // タイトル
  final String? unit; // 単位
  final String message; // tooltip用メッセージ
  final TextEditingController? controller; // TextEditingController
  final Function(VoltUnitEnum value)? onPressedVoltUnitFunc; // 電圧の単位選択
  final Function(PowerUnitEnum value)? onPressedPowerUnitFunc; // 電力の単位選択

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

/// 結果用のwidget
class OutputTextCard extends ConsumerWidget {
  final String title; // 出力タイトル
  final String unit; // 単位
  final String result; // 出力結果

  const OutputTextCard({
    Key? key,
    required this.title,
    required this.unit,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// タイトル
          Container(
            // padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),

          /// 結果表示
          ListTile(
            title: Text(
              result,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            trailing: result == '候補なし' || result == '候補なし(電圧要確認)'
                ? const Text('')
                : Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
          ),

          ///
        ],
      ),
    );
  }
}

/// 実行ボタンのWidget
class CalcRunButton extends ConsumerWidget {
  final Function() func;

  const CalcRunButton({
    Key? key,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          func();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
            const EdgeInsets.fromLTRB(30, 20, 30, 20),
          ),
        ),
        child: const Text(
          '計算実行',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

/// 数値が異常の場合、エラーダイアログを出す
/// [使い方]
/// showDialog<void>(
///   context: context,
///   builder: (BuildContext context) {
///     return const CorrectAlertDialog();
///   },
/// );
class CorrectAlertDialog extends StatelessWidget {
  const CorrectAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('入力数値異常'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('入力した数値を確認してください。'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
