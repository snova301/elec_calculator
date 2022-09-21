import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
