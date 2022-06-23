import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';

/// 各計算のロジック部分
/// view側とは基本的にproviderで受け渡し
class CalcLogic {
  /// WidgetRefは必須
  WidgetRef ref;
  CalcLogic(
    this.ref,
  );

  /// 力率が0-100%の中に入っているか判定。
  /// 入っていたらtrue, 入っていなかったらfalseを返す。
  bool isCosFaiCorrect(String strCosFai) {
    double dCosFai = double.parse(strCosFai);
    return (dCosFai >= 0 && dCosFai <= 100) ? true : false;
  }

  /// ケーブル設計のロジック部分
  void cableDesignCalcRun() {
    // 計算用変数初期化
    double dCurrentVal = 0;
    double dRVal = 0;
    double dXVal = 0;
    double dK1Val = 1; // 電圧降下計算の係数
    double dK2Val = 2; // 電力損失計算の係数
    Map cableDataMap = {}; // ケーブルのインピーダンスと許容電流のマップデータ

    // Textfieldのテキスト取り出し
    String strPhase = ref.read(cableDesignProvider).phase;
    String strElecOut = ref.read(cableDesignProvider).elecOut.text;
    String strCosFai = ref.read(cableDesignProvider).cosfai.text;
    String strVolt = ref.read(cableDesignProvider).volt.text;
    String strLen = ref.read(cableDesignProvider).cableLength.text;
    String strCableType = ref.read(cableDesignProvider).cableType;

    // string2double
    double dElecOut = double.parse(strElecOut);
    double dCosFai = double.parse(strCosFai) / 100;
    double dVolt = double.parse(strVolt);
    double dLen = double.parse(strLen) / 1000;

    // cosφからsinφを算出
    double dSinFai = sqrt(1 - pow(dCosFai, 2));

    // 相ごとの計算(単相)
    if ((strPhase == '単相') && (dCosFai <= 1)) {
      // 単相の電流計算と計算係数設定
      dCurrentVal = dElecOut / (dVolt * dCosFai);
      dK1Val = 1;
      dK2Val = 2;
    }
    // 相ごとの計算(三相)
    else if ((strPhase == '三相') && (dCosFai <= 1)) {
      // 三相の電流計算と計算係数設定
      dCurrentVal = dElecOut / (sqrt(3) * dVolt * dCosFai);
      dK1Val = sqrt(3);
      dK2Val = 3;
    }

    /// ケーブル種類からデータを取得
    cableDataMap = CableData().selectCableData(strCableType);

    /// ケーブル許容電流から600V CV-3Cケーブルの太さを選定
    /// 許容電流を満たすケーブルサイズをリストに追加
    List cableAnswerList = [];
    cableDataMap.forEach((key, value) {
      if (value[2] >= dCurrentVal) {
        cableAnswerList.add([key, value[0], value[1]]); // [ケーブルサイズ, 抵抗, リアクタンス]
      }
    });

    /// 許容電流が満たせない場合は'規格なし'を返す。
    String cableSize = '';
    if (cableAnswerList.isEmpty) {
      cableSize = '規格なし';
      dRVal = dXVal = 0;
    } else {
      cableSize = cableAnswerList[0][0];
      dRVal = cableAnswerList[0][1];
      dXVal = cableAnswerList[0][2];
    }

    /// ケーブルサイズをproviderに書き込み
    ref.read(cableDesignProvider.notifier).cableSizeUpdate(cableSize);

    /// 電流値小数点の長さ固定して文字列に変換
    /// providerに書込み
    String strCurrentVal = dCurrentVal.toStringAsFixed(1);
    ref.read(cableDesignProvider.notifier).currentUpdate(strCurrentVal);

    /// ケーブル電圧降下計算
    /// providerに書込み
    double dVoltDrop =
        dK1Val * dCurrentVal * dLen * (dRVal * dCosFai + dXVal * dSinFai);
    String strVoltDrop = dVoltDrop.toStringAsFixed(1);
    ref.read(cableDesignProvider.notifier).voltDropUpdate(strVoltDrop);

    /// ケーブル電力損失計算
    /// providerに書込み
    double dPowLoss = dK2Val * dRVal * dCurrentVal * dCurrentVal * dLen;
    String strPowLoss = dPowLoss.toStringAsFixed(1);
    ref.read(cableDesignProvider.notifier).powerLossUpdate(strPowLoss);

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }

  /// 電力計算のロジック部分
  void elecPowerCalcRun() {
    // Textfieldのテキスト取り出し
    // String strVolt = ref.read(elecPowerVoltProvider).text;
    // String strCurrent = ref.read(elecPowerCurrentProvider).text;
    // String strCosFai = ref.read(elecPowerCosFaiProvider).text;

    String strPhase = ref.read(elecPowerProvider).phase;
    String strVolt = ref.read(elecPowerProvider).volt.text;
    String strCurrent = ref.read(elecPowerProvider).current.text;
    String strCosFai = ref.read(elecPowerProvider).cosFai.text;

    // string2double
    double dVolt = double.parse(strVolt);
    double dCurrent = double.parse(strCurrent);
    double dCosFai = double.parse(strCosFai) / 100;
    double dAppaPow = 0;

    // cosφからsinφを算出
    double dSinFai = sqrt(1 - pow(dCosFai, 2));

    if (strPhase == '単相') {
      /// 単相電力計算
      dAppaPow = dVolt * dCurrent;
    } else if (strPhase == '三相') {
      /// 3相電力計算
      dAppaPow = sqrt(3) * dVolt * dCurrent;
    }

    /// 有効電力と無効電力の計算
    double dActPow = dAppaPow * dCosFai;
    double dReactPow = dAppaPow * dSinFai;

    /// double2string
    String strAppaPow = (dAppaPow / 1000).toStringAsFixed(2);
    String strActPow = (dActPow / 1000).toStringAsFixed(2);
    String strReactPow = (dReactPow / 1000).toStringAsFixed(2);
    String strSinFai = (dSinFai * 100).toStringAsFixed(1);

    /// providerに書込み
    // ref.read(elecPowerApparentPowerProvider.state).state = strAppaPow;
    // ref.read(elecPowerActivePowerProvider.state).state = strActPow;
    // ref.read(elecPowerReactivePowerProvider.state).state = strReactPow;
    // ref.read(elecPowerSinFaiProvider.state).state = strSinFai;
    ref.read(elecPowerProvider.notifier).apparentPowerUpdate(strAppaPow);
    ref.read(elecPowerProvider.notifier).activePowerUpdate(strActPow);
    ref.read(elecPowerProvider.notifier).reactivePowerUpdate(strReactPow);
    ref.read(elecPowerProvider.notifier).sinFaiUpdate(strSinFai);

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }
}
