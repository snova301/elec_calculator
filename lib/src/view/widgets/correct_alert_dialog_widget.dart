import 'package:flutter/material.dart';

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
