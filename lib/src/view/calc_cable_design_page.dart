import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/view/calc_page.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_cable_design_state.dart';

/// ケーブル設計のListView Widget
class ListViewCableDesign extends ConsumerWidget {
  final double listViewPadding;
  final double blockWidth;

  const ListViewCableDesign(
      {Key? key, required this.listViewPadding, required this.blockWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 広告の初期化
    AdsSettingsClass().initCableDesignRec();

    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(cableDesignSPSetProvider);

    return ListView(
      padding: EdgeInsets.fromLTRB(listViewPadding, 10, listViewPadding, 10),
      // widget.listViewPadding, 10, widget.listViewPadding, 10),
      children: <Widget>[
        /// 入力表示
        const SeparateText(title: '計算条件'),

        /// 相選択
        CalcPhaseSelectCard(
          phase: ref.watch(cableDesignProvider).phase,
          onPressedFunc: (String value) =>
              ref.read(cableDesignProvider.notifier).updatePhase(value),
        ),

        /// ケーブル種類選択
        const CableDeignSelectCableType(),

        /// 電気容量入力
        InputTextCard(
          title: '電気容量',
          unit: 'W',
          message: '整数のみ',
          controller: ref.watch(cableDesignTxtCtrElecOutProvider),
        ),

        /// 線間電圧入力
        InputTextCard(
          title: '線間電圧',
          unit: 'V',
          message: '整数のみ',
          controller: ref.watch(cableDesignTxtCtrVoltProvider),
        ),

        /// 力率入力
        InputTextCard(
          title: '力率',
          unit: '%',
          message: '整数のみ',
          controller: ref.watch(cableDesignTxtCtrCosFaiProvider),
        ),

        /// ケーブル長入力
        InputTextCard(
          title: 'ケーブル長',
          unit: 'm',
          message: '整数のみ',
          controller: ref.watch(cableDesignTxtCtrLengthProvider),
        ),

        /// 計算実行ボタン
        CalcRunButton(
          paddingSize: blockWidth,
          // paddingSize: widget.blockWidth,
          func: () {
            /// textcontrollerのデータを取得
            final strElecOut = ref.watch(cableDesignTxtCtrElecOutProvider).text;
            final strVolt = ref.watch(cableDesignTxtCtrVoltProvider).text;
            final strCosFai = ref.watch(cableDesignTxtCtrCosFaiProvider).text;
            final strCableLength =
                ref.watch(cableDesignTxtCtrLengthProvider).text;

            /// 実行時に読み込み関係でエラーを吐き出さないか確認後実行
            if (ref.read(cableDesignProvider.notifier).isRunCheck(
                  strElecOut,
                  strVolt,
                  strCosFai,
                  strCableLength,
                )) {
              ref
                  .read(cableDesignProvider.notifier)
                  .run(strElecOut, strVolt, strCosFai, strCableLength);
            } else {
              /// snackbarでエラー表示
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return const CorrectAlertDialog();
                },
              );
            }
          },
        ),

        /// 結果表示
        const SeparateText(title: '計算結果'),

        /// 電流表示
        OutputTextCard(
          title: '電流',
          unit: 'A',
          result: ref.watch(cableDesignProvider).current,
        ),

        /// ケーブルサイズ表示
        OutputTextCard(
          title: ref.watch(cableDesignProvider).cableType,
          unit: 'mm2',
          result: ref.watch(cableDesignProvider).cableSize,
        ),

        /// 電圧降下表示
        OutputTextCard(
          title: '電圧降下',
          unit: 'V',
          result: ref.watch(cableDesignProvider).voltDrop,
        ),

        /// 電力損失表示
        OutputTextCard(
          title: '電力損失',
          unit: 'W',
          result: ref.watch(cableDesignProvider).powerLoss,
        ),

        /// 広告表示
        isAndroid || isIOS
            ? const CableDesignRecBannerContainer()
            : Container(),
      ],
    );
  }
}

/// ケーブル種類選択widget
class CableDeignSelectCableType extends ConsumerWidget {
  const CableDeignSelectCableType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// テキスト表示
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: const Tooltip(
              message: 'ドロップダウンから選択してください',
              child: Text(
                'ケーブル種類',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),

          /// ドロップダウンから選択
          Align(
            alignment: Alignment.center,
            child: DropdownButton(
              value: ref.watch(cableDesignProvider).cableType,
              items: CableData()
                  .cableTypeList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: AlignmentDirectional.centerStart,
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                ref.read(cableDesignProvider.notifier).updateCableType(value!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
