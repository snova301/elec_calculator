import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';
import 'package:elec_facility_calc/src/view/home_page.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/view/wiring_list_create_page.dart';
import 'package:uuid/uuid.dart';

class WiringListPage extends ConsumerStatefulWidget {
  const WiringListPage({Key? key}) : super(key: key);

  @override
  WiringListPageState createState() => WiringListPageState();
}

class WiringListPageState extends ConsumerState<WiringListPage> {
  @override
  Widget build(BuildContext context) {
    /// 画面情報取得
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final listViewPadding = screenWidth / 20;

    final wiringMapLength = ref.watch(wiringListProvider).length;
    const maxNum = 3;
    print(ref.watch(wiringListProvider));

    return Scaffold(
        appBar: AppBar(
          title: const Text('配線管理リスト'),
        ),
        body: Column(
          children: const <Widget>[
            Text('配線管理リストの項目は $maxNum まで'),
            WiringSearchView(),
            Expanded(
              child: WiringView(),
            ),
          ],
        ),
        floatingActionButton: WiringAddFAB(
          maxNum: maxNum,
          wiringMapLength: wiringMapLength,
        ));
  }
}

/// 絞り込み
class WiringSearchView extends ConsumerWidget {
  const WiringSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cableTypeList = ref.watch(wiringListSearchCableTypeListProvider);
    final startPointList = ref.watch(wiringListSearchStartListProvider);
    final endPointList = ref.watch(wiringListSearchEndListProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          // const Text('絞り込み'),

          /// ケーブル種類の絞り込み
          Card(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(30),
            // ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton(
                alignment: AlignmentDirectional.center,
                menuMaxHeight: 200,
                value: ref.watch(wiringListSearchCableTypeProvider),
                items: ref
                    .watch(wiringListSearchCableTypeListProvider)
                    .map<DropdownMenuItem<String>>(
                  // items: cableTypeList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      alignment: AlignmentDirectional.centerStart,
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                            // fontSize: 12,
                            ),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (String? value) {
                  /// 変更
                  ref.read(wiringListSearchCableTypeProvider.state).state =
                      value!;
                },
              ),
            ),
          ),

          /// ケーブル出発点の絞り込み
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton(
                alignment: AlignmentDirectional.center,
                menuMaxHeight: 200,
                value: ref.watch(wiringListSearchStartProvider),
                items: ref
                    .watch(wiringListSearchStartListProvider)
                    .map<DropdownMenuItem<String>>(
                  // items: startPointList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      alignment: AlignmentDirectional.centerStart,
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                            // fontSize: 12,
                            ),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (String? value) {
                  /// 変更
                  ref.read(wiringListSearchStartProvider.state).state = value!;
                },
              ),
            ),
          ),

          /// ケーブル到着点の絞り込み
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton(
                alignment: AlignmentDirectional.center,
                menuMaxHeight: 200,
                value: ref.watch(wiringListSearchEndProvider),
                items: ref
                    .watch(wiringListSearchEndListProvider)
                    .map<DropdownMenuItem<String>>(
                  // items: endPointList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      alignment: AlignmentDirectional.centerStart,
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                            // fontSize: 12,
                            ),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (String? value) {
                  /// 変更
                  ref.read(wiringListSearchEndProvider.state).state = value!;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 配線リスト本体
class WiringView extends ConsumerWidget {
  const WiringView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wiringMap = ref.watch(wiringListShowProvider);
    final wiringMapKeyList = wiringMap.keys.toList();
    final wiringMapValueList = wiringMap.values.toList();

    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: wiringMap.length,
        itemBuilder: (context, index) {
          /// 定義
          final id = wiringMapKeyList[index];
          final name = wiringMapValueList[index].name;
          final cableType = wiringMapValueList[index].cableType;
          final startPoint = wiringMapValueList[index].startPoint;
          final endPoint = wiringMapValueList[index].endPoint;
          final remarks = wiringMapValueList[index].remarks;

          /// ケーブルの表示
          return Card(
            margin: const EdgeInsets.all(5),
            child: ListTile(
              /// 番号表示
              leading: Text('${index + 1}'),

              /// 名前表示
              title: Text(wiringMapValueList[index].name),

              /// ケーブル種類とケーブルルート表示
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cable Type : $cableType'),
                  Text('Cable Route : $startPoint ---> $endPoint'),
                ],
              ),

              /// 削除ボタン
              trailing: IconButton(
                onPressed: () {
                  ref.read(wiringListProvider.notifier).remove(id);
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                ),
              ),

              /// タップ時編集モードに遷移
              onTap: () {
                /// 新規作成モードをOFFにし、各値を入れ込む
                ref.read(wiringListSettingProvider.state).state =
                    WiringListSettingDataClass(
                  isCreate: false,
                  id: wiringMapKeyList[index],
                  nameController: TextEditingController(text: name),
                  cableType: cableType,
                  startPointController: TextEditingController(text: startPoint),
                  endPointController: TextEditingController(text: endPoint),
                  remarksController: TextEditingController(text: remarks),
                );
                ref.read(wiringListSettingProvider);

                /// ページ遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WiringCreatePage(),
                  ),
                );
              },
            ),
          );
        });
  }
}

/// FAB
class WiringAddFAB extends ConsumerWidget {
  final int maxNum;
  final int wiringMapLength;

  const WiringAddFAB({
    Key? key,
    required this.maxNum,
    required this.wiringMapLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        if (wiringMapLength < maxNum) {
          /// データ更新
          ref.read(wiringListSettingProvider.state).state =
              WiringListSettingDataClass(
            isCreate: true,
            id: const Uuid().v4(),
            nameController: TextEditingController(text: ''),
            cableType: CableData().cableTypeList.first,
            startPointController: TextEditingController(text: ''),
            endPointController: TextEditingController(text: ''),
            remarksController: TextEditingController(text: ''),
          );

          /// ページ遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WiringCreatePage(),
            ),
          );
        } else {
          /// 数がオーバーしたらSnackbarで警告
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarAlert(title: 'これ以上追加できません'),
          );
        }
      },
    );
  }
}
