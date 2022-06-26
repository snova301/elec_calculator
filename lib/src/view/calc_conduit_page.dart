import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/data/conduit_data.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_conduit_state.dart';

/// 電線管設計のListView Widget
class ListViewConduit extends ConsumerWidget {
  final double listViewPadding;
  final double blockWidth;
  final int maxNumCable;

  const ListViewConduit({
    Key? key,
    required this.listViewPadding,
    required this.blockWidth,
    required this.maxNumCable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        /// 情報画面
        Text('ケーブルは $maxNumCable 本まで設定できます。'),
        Container(
          padding:
              EdgeInsets.fromLTRB(listViewPadding, 10, listViewPadding, 10),
          child: const ConduitConduitTypeCard(),
        ),

        /// ケーブルの一覧
        Expanded(
          child: ListView.builder(
            padding:
                EdgeInsets.fromLTRB(listViewPadding, 10, listViewPadding, 10),
            itemCount: ref.watch(conduitCalcProvider).items.length,
            itemBuilder: (context, index) {
              return ConduitCableCard(index: index);
            },
          ),
        ),

        /// 結果表示
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConduitConduitSizeCard(
                title: '32', result: ref.watch(conduitOccupancy32Provider)),
            ConduitConduitSizeCard(
                title: '48', result: ref.watch(conduitOccupancy48Provider)),
          ],
        ),
      ],
    );
  }
}

/// 電線管設計電線管の種類widget
class ConduitConduitTypeCard extends ConsumerWidget {
  const ConduitConduitTypeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: const Text(
          '電線管の種類',
          style: TextStyle(
            fontSize: 13,
          ),
        ),

        /// 電線管の種類を変更するドロップダウンメニュー
        title: DropdownButton(
          value: ref.watch(conduitCalcProvider).conduitType,
          items: ConduitData().conduitTypeList.map<DropdownMenuItem<String>>(
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
            ref.watch(conduitCalcProvider.notifier).updateConduitType(value!);
          },
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
    String cableType = ref.watch(conduitCalcProvider).items[index].cableType;
    String cableSize = ref.watch(conduitCalcProvider).items[index].cableSize;

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

/// 電線管設計電線管のサイズを表示するwidget
class ConduitConduitSizeCard extends ConsumerWidget {
  /// 32%または48%の表示
  final String title;

  /// 計算後の電線管サイズ
  final String result;

  const ConduitConduitSizeCard({
    Key? key,
    required this.title,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            /// FEP管はJISで占有率の規定がないので参考値の表示をつける
            ref.watch(conduitCalcProvider).conduitType == 'FEP管'
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
