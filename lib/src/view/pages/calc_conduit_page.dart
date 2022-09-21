import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:elec_facility_calc/src/view/widgets/drawer_contents_widget.dart';
import 'package:elec_facility_calc/src/view/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/src/view/widgets/common_widgets.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/data/conduit_data.dart';
import 'package:elec_facility_calc/src/notifiers/state_manager.dart';
import 'package:elec_facility_calc/src/notifiers/calc_conduit_state.dart';

/// 電線管設計ページ
class CalcConduitPage extends ConsumerStatefulWidget {
  const CalcConduitPage({Key? key}) : super(key: key);

  @override
  CalcConduitPageState createState() => CalcConduitPageState();
}

class CalcConduitPageState extends ConsumerState<CalcConduitPage> {
  @override
  Widget build(BuildContext context) {
    /// 画面情報取得
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    // final blockWidth = screenWidth / 100 * 20;
    final listViewPadding = screenWidth / 20;

    /// 広告の初期化
    AdsSettingsClass().initStdBanner();

    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(conduitSPSetProvider);

    /// 情報カードの高さ
    double infoHeight = 100;

    /// 電線管設計用
    int maxNumCable = 20;

    /// レスポンシブ設定
    bool isDrawerFixed = checkResponsive(screenWidth);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            PageNameEnum.conduit.title,
          ),
        ),
        body: Row(
          children: [
            /// 画面幅が規定以上でメニューを左側に固定
            isDrawerFixed ? const DrawerContentsFixed() : Container(),

            /// サイズ指定されていないとエラーなのでExpandedで囲む
            Expanded(
              child: Column(
                children: [
                  /// 情報画面
                  Text(
                    'ケーブルは $maxNumCable 本まで設定できます。',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),

                  /// 広告
                  existAds ? const StdBannerContainer() : Container(),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ConduitConduitTypeCard(
                          height: infoHeight,
                        ),
                        ConduitConduitSizeCard(
                          title: '32',
                          result: ref.watch(conduitOccupancy32Provider),
                          height: infoHeight,
                        ),
                        ConduitConduitSizeCard(
                          title: '48',
                          result: ref.watch(conduitOccupancy48Provider),
                          height: infoHeight,
                        ),
                      ],
                    ),
                  ),

                  /// ケーブルの一覧
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                          listViewPadding, 10, listViewPadding, 10),
                      itemCount: ref.watch(conduitCalcProvider).length,
                      itemBuilder: (context, index) {
                        return ConduitCableCard(index: index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        /// drawer
        drawer: isDrawerFixed ? null : const DrawerContents(),

        floatingActionButton: FloatingActionButton(
          tooltip: 'ケーブル追加',
          child: const Icon(Icons.add),
          onPressed: () {
            if (ref.read(conduitCalcProvider).length < maxNumCable) {
              ref.read(conduitCalcProvider.notifier).addCable();
              ref.read(conduitCalcProvider.notifier).calcCableArea();
            } else {
              /// snackbarで警告
              SnackBarAlertClass(context: context).snackbar('これ以上追加できません');
            }
          },
        ),
      ),
    );
  }
}

/// 電線管設計電線管の種類widget
class ConduitConduitTypeCard extends ConsumerWidget {
  /// Cardの高さ
  final double height;

  const ConduitConduitTypeCard({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              '電線管の種類',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            DropdownButton(
              value: ref.watch(conduitConduitTypeProvider),
              items:
                  ConduitData().conduitTypeList.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    alignment: AlignmentDirectional.centerStart,
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              onChanged: (String? value) {
                /// 電線管の種類変更
                ref.watch(conduitConduitTypeProvider.notifier).state = value!;
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 電線管設計電線管のサイズを表示するwidget
class ConduitConduitSizeCard extends ConsumerWidget {
  /// 32%または48%の表示
  final String title;

  /// 計算後の電線管サイズ
  final String result;

  /// Cardの高さ
  final double height;

  const ConduitConduitSizeCard({
    Key? key,
    required this.title,
    required this.result,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// FEP管はJISで占有率の規定がないので参考値の表示をつける
            ref.watch(conduitConduitTypeProvider) == 'FEP管'
                ? Text(
                    '電線管サイズ\n占有率 $title %(参考値)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  )
                : Text(
                    '電線管サイズ\n占有率 $title %',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
            Text(
              result,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 電線管設計ケーブルのカード
class ConduitCableCard extends ConsumerWidget {
  final int index; // インデックス

  const ConduitCableCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 各値の取得
    String cableType = ref.watch(conduitCalcProvider)[index].cableType;
    String cableSize = ref.watch(conduitCalcProvider)[index].cableSize;

    return Card(
      child: ListTile(
        subtitle: Column(
          children: [
            /// ケーブル種類を表示するためのrow
            Row(
              children: [
                /// ケーブル種類の表示
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: const Text(
                    'ケーブル種類',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),

                /// ケーブル種類を変更するためのドロップダウンメニュー
                DropdownButton(
                  value: cableType,
                  items:
                      CableData().cableTypeList.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (String? value) {
                    /// ケーブルの種類変更
                    ref
                        .watch(conduitCalcProvider.notifier)
                        .updateCableType(index, value!);
                  },
                ),
              ],
            ),

            /// ケーブルサイズを表示するためのrow
            Row(
              children: <Widget>[
                /// ケーブルサイズの表示
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: const Text(
                    'ケーブルサイズ',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),

                /// ケーブルサイズを変更するためのドロップダウンメニュー
                DropdownButton(
                  value: cableSize,
                  items: ref
                      .watch(conduitCalcProvider.notifier)
                      .cableSizeList(index)
                      .map<DropdownMenuItem<String>>(
                    (value) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    },
                  ).toList(),
                  onChanged: (String? value) {
                    /// ケーブルのサイズ変更
                    ref
                        .watch(conduitCalcProvider.notifier)
                        .updateCableSize(index, value!);
                  },
                ),

                /// 単位表示
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: const Text(
                    'mm2',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        /// アイテム削除ボタン
        trailing: IconButton(
          icon: const Icon(
            Icons.remove_circle_outline,
            color: Colors.redAccent,
          ),
          onPressed: () {
            ref.watch(conduitCalcProvider.notifier).removeCable(index);
          },
        ),
      ),
    );
  }
}
