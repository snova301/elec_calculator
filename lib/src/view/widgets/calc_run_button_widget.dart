import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
