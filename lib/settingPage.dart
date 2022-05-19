import 'package:elec_facility_calc/stateManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          _DarkmodeCard(context, ref),
          _DataRemoveCard(context, ref),
        ],
      ),
    );
  }
}

class _DarkmodeCard extends Card {
  _DarkmodeCard(BuildContext context, WidgetRef ref)
      : super(
          child: SwitchListTile(
            title: const Text('ダークモード'),
            value: ref.watch(isDarkmodeProvider),
            contentPadding: const EdgeInsets.all(10),
            secondary: const Icon(Icons.dark_mode_outlined),
            onChanged: (bool value) {
              ref.read(isDarkmodeProvider.state).state = value;
              StateManagerClass().setDarkmodeVal(ref);
            },
          ),
        );
}

class _DataRemoveCard extends Card {
  _DataRemoveCard(BuildContext context, WidgetRef ref)
      : super(
          child: ListTile(
            title: const Text('計算データを削除'),
            textColor: Colors.red,
            iconColor: Colors.red,
            contentPadding: const EdgeInsets.all(10),
            leading: const Icon(Icons.delete_outline),
            onTap: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      _DataRemoveDialog(context, ref));
            },
          ),
        );
}

class _DataRemoveDialog extends AlertDialog {
  _DataRemoveDialog(BuildContext context, WidgetRef ref)
      : super(
          title: const Text('注意'),
          content: const Text('以前の計算データが削除されます。'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                /// shared_prefのデータを削除
                StateManagerClass().removeCalcData(ref);

                /// 戻る
                Navigator.pop(context);
              },
            ),
          ],
        );
}
