import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:elec_facility_calc/src/view/common_page.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';
import 'package:elec_facility_calc/src/viewmodel/wiring_list_state.dart';
import 'package:elec_facility_calc/src/view/wiring_list_create_page.dart';

/// 配線管理リストのページ
class WiringListPage extends ConsumerStatefulWidget {
  const WiringListPage({Key? key}) : super(key: key);

  @override
  WiringListPageState createState() => WiringListPageState();
}

class WiringListPageState extends ConsumerState<WiringListPage> {
  @override
  Widget build(BuildContext context) {
    /// 画面情報取得
    // final mediaQueryData = MediaQuery.of(context);
    // final screenWidth = mediaQueryData.size.width;

    /// 項目の最大数
    const maxNum = 3;

    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(wiringListSPSetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Tooltip(
          message: '配線管理リストの項目は $maxNum 個まで',
          child: Text('配線管理リスト'),
        ),
      ),
      body: Column(
        children: const <Widget>[
          /// 絞り込み用widget
          WiringSearchView(),

          /// リスト
          Expanded(
            child: WiringView(),
          ),
        ],
      ),
      drawer: const DrawerContents(),
      floatingActionButton: const WiringAddFAB(maxNum: maxNum),
    );
  }
}

/// 絞り込み
class WiringSearchView extends ConsumerWidget {
  const WiringSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          // const Text('絞り込み'),

          /// ケーブル種類の絞り込み
          WiringListSearchCard(
            providerStr: wiringListSearchCableTypeProvider,
            providerList: wiringListSearchCableTypeListProvider,
          ),

          /// 出発点の絞り込み
          WiringListSearchCard(
            providerStr: wiringListSearchStartProvider,
            providerList: wiringListSearchStartListProvider,
          ),

          /// 到着点の絞り込み
          WiringListSearchCard(
            providerStr: wiringListSearchEndProvider,
            providerList: wiringListSearchEndListProvider,
          ),
        ],
      ),
    );
  }
}

/// 絞り込みwidget
class WiringListSearchCard extends ConsumerWidget {
  final StateProvider<String> providerStr;
  final StateProvider<List<String>> providerList;

  const WiringListSearchCard({
    Key? key,
    required this.providerStr,
    required this.providerList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(30),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButton(
          alignment: AlignmentDirectional.center,
          menuMaxHeight: 200,
          value: ref.watch(providerStr),
          items: ref.watch(providerList).map<DropdownMenuItem<String>>(
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
            ref.read(providerStr.state).state = value!;
          },
        ),
      ),
    );
  }
}

/// 配線リスト本体
class WiringView extends ConsumerWidget {
  const WiringView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 定義
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

/// 追加用FAB
class WiringAddFAB extends ConsumerWidget {
  final int maxNum;

  const WiringAddFAB({
    Key? key,
    required this.maxNum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        if (ref.watch(wiringListProvider).length < maxNum) {
          /// データ更新
          ref.read(wiringListSettingProvider.state).state =
              WiringListSettingDataClass(
            isCreate: true,
            id: const Uuid().v4(),
            nameController: TextEditingController(text: ''),
            cableType: CableTypeEnum.cv2c600v.cableType,
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
          SnackBarAlert(context: context).snackbar('これ以上追加できません');
        }
      },
    );
  }
}
