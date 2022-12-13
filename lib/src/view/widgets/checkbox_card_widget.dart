import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// チェックボックス
///
/// 使い方
/// CheckBoxCard(
///   title: '無窓階',
///   isChecked: ref.watch(provider).isNoWindow,
///   func: (bool newVal) {
///     ref.read(provider.notifier).updateIsNoWindow(newVal);
///   },
/// ),
class CheckBoxCard extends ConsumerWidget {
  /// 入力文字列
  final String title;

  /// チェックボックスの状態
  final bool isChecked;

  /// チェックボックスの関数
  final Function(bool newBool) func;

  const CheckBoxCard({
    Key? key,
    required this.title,
    required this.isChecked,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: CheckboxListTile(
        value: isChecked,
        onChanged: (bool? newBool) {
          func(newBool!);
        },
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
          ),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
