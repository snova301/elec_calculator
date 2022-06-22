import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_logic.dart';

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
    print(ref.watch(conduitCalcProvider));
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
        title: DropdownButton(
          value: ref.watch(conduitCalcProvider).conduitType,
          items: <String>['PF管', 'C管(薄鋼)', 'G管(厚鋼)', 'FEP管']
              .map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.centerStart,
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          onChanged: (String? value) {
            CalcLogic(ref).conduitTypeChange(value);
          },
        ),
      ),
    );
  }
}

/// 電線管設計ケーブルのカード
class ConduitCableCard extends ConsumerWidget {
  final int index;

  const ConduitCableCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // String cableType = '600V CV-2C';
    // String cableSize = '2';
    String cableType = ref.watch(conduitCalcProvider).items[index].cableType;
    String cableSize = ref.watch(conduitCalcProvider).items[index].cableSize;
    // String cableType = ref.watch(conduitCalcProvider).items[index]['type'];
    // String cableSize = ref.watch(conduitCalcProvider).items[index]['size'];

    return Card(
      child: ListTile(
        subtitle: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: const Text(
                    'ケーブル種類',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                DropdownButton(
                  value: cableType,
                  items: <String>['600V CV-2C', '600V CV-3C', '600V CVT', 'IV']
                      .map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (String? value) {
                    CalcLogic(ref).conduitCardSelectType(index, value);
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: const Text(
                    'ケーブルサイズ',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                // DropdownButton(
                //   value: cableSize,
                //   // items: ref
                //   //     .watch(conduitCalcProvider)
                //   //     .cableSizeList[index]
                //   items: ref
                //       .watch(conduitCableSizeListProvider)[index]
                //       .map<DropdownMenuItem<String>>(
                //     (value) {
                //       return DropdownMenuItem<String>(
                //         alignment: AlignmentDirectional.centerStart,
                //         value: value.toString(),
                //         child: Text(value.toString()),
                //       );
                //     },
                //   ).toList(),
                //   onChanged: (String? value) {
                //     CalcLogic(ref).conduitCardSelectSize(index, value);
                //   },
                // ),

                /// 単位
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
            CalcLogic(ref).conduitCableRemove(index);
          },
        ),
      ),
    );
  }
}

/// 電線管設計電線管のサイズwidget
class ConduitConduitSizeCard extends ConsumerWidget {
  final String title;
  final String result;
  // final StateProvider<String> provider;

  const ConduitConduitSizeCard({
    Key? key,
    required this.title,
    required this.result,
    // required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            /// FEP管はJISで占有率の規定がないので参考値
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
              // ref.watch(provider),
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
