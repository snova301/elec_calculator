import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/view/home_page.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';

class WiringCreatePage extends ConsumerWidget {
  const WiringCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCreate = ref.watch(wiringListSettingProvider).isCreate;

    /// idの取得
    final id = ref.watch(wiringListSettingProvider).id;

    /// TextEditingControllerの初期化
    final nameController = ref.watch(wiringListSettingProvider).nameController;
    final startPointController =
        ref.watch(wiringListSettingProvider).startPointController;
    final endPointController =
        ref.watch(wiringListSettingProvider).endPointController;
    final remarksController =
        ref.watch(wiringListSettingProvider).remarksController;

    return Scaffold(
      appBar: AppBar(
        title: Text(isCreate ? 'ケーブル追加' : 'ケーブル編集'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          WiringCreateTextFieldMain(
            controller: nameController,
            labelText: 'ケーブル名称',
          ),
          const WiringCreateCableTypeSelect(),
          WiringCreateTextFieldMain(
            controller: startPointController,
            labelText: '出発点',
          ),
          WiringCreateTextFieldMain(
            controller: endPointController,
            labelText: '到着点',
          ),
          WiringCreateTextFieldSub(
            controller: remarksController,
            labelText: '備考',
          ),
          ElevatedButton(
            onPressed: () {
              /// 名前と発着点が空白ではない場合
              if (nameController.text.isNotEmpty &&
                  startPointController.text.isNotEmpty &&
                  endPointController.text.isNotEmpty) {
                /// データ保存
                ref.read(wiringListProvider.notifier).update(
                      id,
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarAlert(title: '未入力項目があります'),
                );
              }
            },
            style: ButtonStyle(
                // backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
            child: Text(isCreate ? '新規保存' : '変更'),
          ),
        ],
      ),
    );
  }
}

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
          labelText: '$labelText ( 必須 )',
          border: const OutlineInputBorder(),
          // helperText: '* 必須',
          // errorText: controller.text.isEmpty ? '必須項目です。' : null,
        ),
      ),
    );
  }
}

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
        minLines: 5,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: labelText,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

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
        menuMaxHeight: 200,
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
