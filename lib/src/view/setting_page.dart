import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';

/// 設定ページ
class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(settingSPSetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const <Widget>[
          _DarkmodeCard(),
          _DataRemoveCard(),
        ],
      ),
    );
  }
}

/// ダークモード設定のwidget
class _DarkmodeCard extends ConsumerWidget {
  const _DarkmodeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: SwitchListTile(
        title: const Text('ダークモード'),
        value: ref.watch(settingProvider).darkMode,
        contentPadding: const EdgeInsets.all(10),
        secondary: const Icon(Icons.dark_mode_outlined),
        onChanged: (bool value) {
          ref.read(settingProvider.notifier).updateDarkMode(value);
        },
      ),
    );
  }
}

/// キャッシュデータ全削除のwidget
class _DataRemoveCard extends ConsumerWidget {
  const _DataRemoveCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: const Text('計算データを削除'),
        textColor: Colors.red,
        iconColor: Colors.red,
        contentPadding: const EdgeInsets.all(10),
        leading: const Icon(Icons.delete_outline),
        onTap: () {
          _DataRemoveDialog(context: context, ref: ref).removeAlert();
        },
      ),
    );
  }
}

/// キャッシュデータを削除する際のAlertDialog
class _DataRemoveDialog {
  BuildContext context;
  WidgetRef ref;

  _DataRemoveDialog({required this.context, required this.ref}) : super();

  void removeAlert() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
              StateManagerClass().remove(ref);

              /// 戻る
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
