import 'package:elec_facility_calc/src/view/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';

/// 設定ページ
class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(settingSPSetProvider);

    /// レスポンシブ設定
    final screenWidth = MediaQuery.of(context).size.width;
    bool isDrawerFixed = checkResponsive(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: Text(PageNameEnum.setting.title),
      ),
      body: Row(
        children: [
          /// 画面幅が規定以上でメニューを左側に固定
          isDrawerFixed ? const DrawerContentsFixed() : Container(),

          /// サイズ指定されていないとエラーなのでExpandedで囲む
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                /// ダークモードの設定
                const _DarkmodeCard(),

                /// 電線管設計データの削除
                _DataRemoveCard(
                  title: '電線管設計',
                  func: () {
                    StateManagerClass().removeConduitCalc(ref);
                  },
                ),

                /// 配線管理データの削除
                _DataRemoveCard(
                  title: '配線管理',
                  func: () {
                    StateManagerClass().removeWiringList(ref);
                  },
                ),
              ],
            ),
          ),
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

/// 電線管設計キャッシュデータ削除のwidget
class _DataRemoveCard extends ConsumerWidget {
  final String title;
  final Function() func;
  const _DataRemoveCard({
    Key? key,
    required this.title,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text('$title データを削除'),
        textColor: Colors.red,
        iconColor: Colors.red,
        contentPadding: const EdgeInsets.all(10),
        leading: const Icon(Icons.delete_outline),
        onTap: () {
          /// ダイアログ表示後削除
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('注意'),
              content: Text('以前の $title データが削除されます。'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    /// shared_prefのデータを削除
                    // StateManagerClass().removeCalc(ref);
                    func();

                    /// 戻る
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
