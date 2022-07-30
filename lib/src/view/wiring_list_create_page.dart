import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/viewmodel/wiring_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/view/common_widgets.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';

/// 配線リスト作成ページ
class WiringCreatePage extends ConsumerWidget {
  const WiringCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 広告の初期化
    AdsSettingsClass().initWiringListRec();

    /// 新規作成画面か編集画面かの判断
    final isCreate = ref.watch(wiringListSettingProvider).isCreate;

    /// 各TextEditingControllerの初期化
    final nameController = ref.watch(wiringListSettingProvider).nameController;
    final startPointController =
        ref.watch(wiringListSettingProvider).startPointController;
    final endPointController =
        ref.watch(wiringListSettingProvider).endPointController;
    final remarksController =
        ref.watch(wiringListSettingProvider).remarksController;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isCreate ? 'ケーブル追加' : 'ケーブル編集'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            /// ケーブル名称
            WiringCreateTextFieldMain(
              controller: nameController,
              labelText: 'ケーブル名称',
            ),

            /// ケーブル種類の選択
            const WiringCreateCableTypeSelect(),

            /// 出発点の選択
            WiringCreateTextFieldMain(
              controller: startPointController,
              labelText: '出発点',
            ),

            /// 到着点の選択
            WiringCreateTextFieldMain(
              controller: endPointController,
              labelText: '到着点',
            ),

            /// 備考
            WiringCreateTextFieldSub(
              controller: remarksController,
              labelText: '備考',
            ),

            /// 実行ボタン
            const WiringCreateRunButton(),

            /// 広告
            existAds ? const WiringListRecBannerContainer() : Container(),
          ],
        ),
      ),
    );
  }
}

/// テキスト入力(必須項目)
class WiringCreateTextFieldMain extends ConsumerWidget {
  final TextEditingController controller;
  final String labelText;

  const WiringCreateTextFieldMain({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      minVerticalPadding: 10,
      title: TextFormField(
        controller: controller,
        maxLength: 30,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          helperText: '必須',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return '空白です';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

/// テキスト入力(備考)
class WiringCreateTextFieldSub extends ConsumerWidget {
  final TextEditingController controller;
  final String labelText;

  const WiringCreateTextFieldSub({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      minVerticalPadding: 10,
      title: TextFormField(
        controller: controller,
        maxLength: 300,
        minLines: 3,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: labelText,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// ケーブル種類選択
class WiringCreateCableTypeSelect extends ConsumerWidget {
  const WiringCreateCableTypeSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      minVerticalPadding: 10,
      title: DropdownButtonFormField(
        decoration: const InputDecoration(
          labelText: 'ケーブル種類',
          border: OutlineInputBorder(),
        ),
        alignment: AlignmentDirectional.center,
        menuMaxHeight: 320,
        value: ref.watch(wiringListSettingProvider).cableType,
        items: CableData().cableTypeList.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              alignment: AlignmentDirectional.centerStart,
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
        onChanged: (String? value) {
          /// 変更
          ref.read(wiringListSettingProvider.state).state.cableType = value!;
        },
      ),
    );
  }
}

/// 作成実行ボタン
class WiringCreateRunButton extends ConsumerWidget {
  const WiringCreateRunButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 新規作成画面か編集画面かの判断
    final isCreate = ref.watch(wiringListSettingProvider).isCreate;

    /// 各TextEditingControllerの初期化
    final nameController = ref.watch(wiringListSettingProvider).nameController;
    final startPointController =
        ref.watch(wiringListSettingProvider).startPointController;
    final endPointController =
        ref.watch(wiringListSettingProvider).endPointController;
    final remarksController =
        ref.watch(wiringListSettingProvider).remarksController;

    return ElevatedButton(
      onPressed: () {
        /// 名前と発着点が空白ではない場合
        if (nameController.text.isNotEmpty &&
            startPointController.text.isNotEmpty &&
            endPointController.text.isNotEmpty) {
          /// データ保存
          ref.read(wiringListProvider.notifier).update(
                ref.watch(wiringListSettingProvider).id,
                nameController.text,
                ref.watch(wiringListSettingProvider).cableType,
                startPointController.text,
                endPointController.text,
                remarksController.text,
              );

          /// 戻る
          Navigator.pop(context);
        } else {
          /// 未入力項目がある場合はSnackbarで警告
          SnackBarAlert(context: context).snackbar('未入力項目があります');
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(const EdgeInsets.all(20.0)),
      ),
      child: Text(isCreate ? '新規保存' : '変更'),
    );
  }
}
