import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/src/view/widgets/calc_widgets.dart';
import 'package:elec_facility_calc/src/view/widgets/common_widgets.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';
import 'package:elec_facility_calc/src/notifiers/state_manager.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/notifiers/calc_cable_design_state.dart';

class CalcCableDesignPage extends ConsumerStatefulWidget {
  const CalcCableDesignPage({Key? key}) : super(key: key);

  @override
  CalcCableDesignPageState createState() => CalcCableDesignPageState();
}

class CalcCableDesignPageState extends ConsumerState<CalcCableDesignPage> {
  @override
  Widget build(BuildContext context) {
    /// 画面情報取得
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    // final blockWidth = screenWidth / 100 * 20;
    final listViewPadding = screenWidth / 20;

    /// レスポンシブ設定
    bool isDrawerFixed = checkResponsive(screenWidth);

    /// 広告の初期化
    AdsSettingsClass().initCableDesignRec();

    /// shared_prefのデータ保存用非同期providerの読み込み
    ref.watch(cableDesignSPSetProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            PageNameEnum.cableDesign.title,
          ),
        ),
        body: Row(
          children: [
            /// 画面幅が規定以上でメニューを左側に固定
            isDrawerFixed ? const DrawerContentsFixed() : Container(),

            /// サイズ指定されていないとエラーなのでExpandedで囲む
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                    listViewPadding, 10, listViewPadding, 10),
                children: <Widget>[
                  /// 入力表示
                  const SeparateText(title: '計算条件'),

                  /// 相選択
                  CalcPhaseSelectCard(
                    phase: ref.watch(cableDesignProvider).phase.str,
                    onPressedFunc: (PhaseNameEnum value) => ref
                        .read(cableDesignProvider.notifier)
                        .updatePhase(value),
                  ),

                  /// ケーブル種類選択
                  const CableDeignSelectCableType(),

                  /// 電気容量入力
                  InputTextCard(
                    title: '電気容量',
                    unit: ref.watch(cableDesignProvider).powerUnit.strActive,
                    message: '整数のみ',
                    controller: ref.watch(cableDesignTxtCtrElecOutProvider),
                    onPressedPowerUnitFunc: (PowerUnitEnum value) => ref
                        .read(cableDesignProvider.notifier)
                        .updatePowerUnit(value),
                  ),

                  /// 線間電圧入力
                  InputTextCard(
                    title: '線間電圧',
                    unit: ref.watch(cableDesignProvider).voltUnit.str,
                    message: '整数のみ',
                    controller: ref.watch(cableDesignTxtCtrVoltProvider),
                    onPressedVoltUnitFunc: (VoltUnitEnum value) => ref
                        .read(cableDesignProvider.notifier)
                        .updateVoltUnit(value),
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
                    func: () {
                      /// textcontrollerのデータを取得
                      final strElecOut =
                          ref.read(cableDesignTxtCtrElecOutProvider).text;
                      final strVolt =
                          ref.read(cableDesignTxtCtrVoltProvider).text;
                      final strCosFai =
                          ref.read(cableDesignTxtCtrCosFaiProvider).text;
                      final strCableLength =
                          ref.read(cableDesignTxtCtrLengthProvider).text;

                      /// 実行時に読み込み関係でエラーを吐き出さないか確認後に実行
                      bool isRunCheck =
                          ref.read(cableDesignProvider.notifier).isRunCheck(
                                strElecOut,
                                strVolt,
                                strCosFai,
                                strCableLength,
                              );
                      if (isRunCheck) {
                        ref.read(cableDesignProvider.notifier).run();

                        /// 電圧がケーブルの定格を超えていたらsnackbarで警告
                        ref.read(cableDesignProvider).cableSize1 ==
                                '候補なし(電圧要確認)'
                            ? SnackBarAlert(context: context)
                                .snackbar('電圧がケーブルの定格電圧を超えています')
                            : null;

                        /// 電圧
                      } else {
                        /// エラー表示
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return const CorrectAlertDialog();
                          },
                        );
                      }
                    },
                  ),

                  /// 広告表示
                  existAds
                      ? const CableDesignRecBannerContainer()
                      : Container(),

                  /// 結果表示
                  const SeparateText(title: '計算結果'),

                  /// 電流表示
                  OutputTextCard(
                    title: '電流',
                    unit: 'A',
                    result: ref.watch(cableDesignCurrentProvider),
                  ),

                  /// 第1候補結果
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: const Text('ケーブル第1候補'),
                      children: [
                        /// ケーブルサイズ表示
                        OutputTextCard(
                          title: ref.watch(cableDesignProvider).cableType,
                          unit: 'mm2',
                          result: ref.watch(cableDesignProvider).cableSize1,
                        ),

                        /// 電圧降下表示
                        OutputTextCard(
                          title: '電圧降下',
                          unit: 'V',
                          result: ref.watch(cableDesignVoltDrop1Provider),
                        ),

                        /// 電力損失表示
                        OutputTextCard(
                          title: '電力損失',
                          unit: 'W',
                          result: ref.watch(cableDesignPowerLoss1Provider),
                        ),
                      ],
                    ),
                  ),

                  /// 第2候補結果
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: const Text('ケーブル第2候補'),
                      children: [
                        /// ケーブルサイズ表示
                        OutputTextCard(
                          title: ref.watch(cableDesignProvider).cableType,
                          unit: 'mm2',
                          result: ref.watch(cableDesignProvider).cableSize2,
                        ),

                        /// 電圧降下表示
                        OutputTextCard(
                          title: '電圧降下',
                          unit: 'V',
                          result: ref.watch(cableDesignVoltDrop2Provider),
                        ),

                        /// 電力損失表示
                        OutputTextCard(
                          title: '電力損失',
                          unit: 'W',
                          result: ref.watch(cableDesignPowerLoss2Provider),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        /// drawer
        drawer: isDrawerFixed ? null : const DrawerContents(),
      ),
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
