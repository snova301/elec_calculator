import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:elec_facility_calc/src/model/wiring_list_data_model.dart';
import 'package:elec_facility_calc/src/view/pages/wiring_list_create_page.dart';
import 'package:elec_facility_calc/src/view/widgets/common_widgets.dart';
import 'package:elec_facility_calc/src/view/widgets/drawer_contents_widget.dart';
import 'package:elec_facility_calc/src/view/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/src/notifiers/state_manager.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/notifiers/wiring_list_state.dart';

/// 配線管理リストのページ
class WiringListPage extends ConsumerStatefulWidget {
  const WiringListPage({Key? key}) : super(key: key);

  @override
  WiringListPageState createState() => WiringListPageState();
}

class WiringListPageState extends ConsumerState<WiringListPage> {
  @override
  Widget build(BuildContext context) {
    /// 広告の初期化
    AdsSettingsClass().initStdBanner();

    /// 画面情報取得
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;

    /// レスポンシブ設定
    bool isDrawerFixed = checkResponsive(screenWidth);

    /// 項目の最大数
    const maxNum = 50;

    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(wiringListSPSetProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(PageNameEnum.wiring.title),
      ),
      body: Row(
        children: [
          /// 画面幅が規定以上でメニューを左側に固定
          isDrawerFixed ? const DrawerContentsFixed() : Container(),

          /// サイズ指定されていないとエラーなのでExpandedで囲む
          Expanded(
            child: Column(
              children: <Widget>[
                /// 情報画面
                const Text(
                  'ケーブルは $maxNum 本まで設定できます。',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),

                /// 広告
                existAds ? const StdBannerContainer() : Container(),

                /// 絞り込み用widget
                const WiringSearchView(),

                /// リスト
                const Expanded(
                  child: WiringView(),
                ),
              ],
            ),
          ),
        ],
      ),

      /// Drawer
      drawer: isDrawerFixed ? null : const DrawerContents(),

      floatingActionButton: const WiringAddFAB(maxNum: maxNum),
    );
  }
}

/// 絞り込みwidgetのrow
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

/// 絞り込みwidget個別
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: DropdownButton(
          alignment: AlignmentDirectional.center,
          menuMaxHeight: 240,
          value: ref.watch(providerStr),
          underline: Container(),
          items: ref.watch(providerList).map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.centerStart,
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (String? value) {
            /// 変更
            ref.read(providerStr.notifier).state = value!;
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
                  Text('ケーブル種類 : $cableType'),
                  Text('出発点 : $startPoint'),
                  Text('到着点 : $endPoint'),
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
                ref.read(wiringListSettingProvider.notifier).state =
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
                /// 下から上に上がるアニメーション
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const WiringCreatePage();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween(
                            begin: const Offset(0.0, 1.0),
                            end: Offset.zero,
                          ).chain(
                            CurveTween(
                              curve: Curves.easeInOut,
                            ),
                          ),
                        ),
                        child: child,
                      );
                    },
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
          ref.read(wiringListSettingProvider.notifier).state =
              WiringListSettingDataClass(
            isCreate: true,
            id: const Uuid().v4(),
            nameController: TextEditingController(text: ''),
            cableType: CableTypeEnum.cv2c600v.str,
            startPointController: TextEditingController(text: ''),
            endPointController: TextEditingController(text: ''),
            remarksController: TextEditingController(text: ''),
          );

          /// ページ遷移
          /// 下から上に上がるアニメーション
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const WiringCreatePage();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).chain(
                      CurveTween(
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  child: child,
                );
              },
            ),
          );
        } else {
          /// 数がオーバーしたらSnackbarで警告
          SnackBarAlertClass(context: context).snackbar('これ以上追加できません');
        }
      },
    );
  }
}
