import 'dart:math';
import 'package:elec_facility_calc/src/model/elec_rate_data_model.dart';
import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 需要率計算のProviderの定義
final elecRateProvider =
    StateNotifierProvider<ElecRateNotifier, ElecRateData>((ref) {
  return ElecRateNotifier();
});

/// 初期データ
const _initData = ElecRateData(
  ratePowerUnit: PowerUnitEnum.w,
  ratePowerUnitAppa: PowerUnitEnum.w,
  rateAllInstCapa: 0,
  rateMaxDemandPower: 0,
  rateIsLoadFactor: false,
  rateAveDemandPower: 0,
  rateDemandRate: 0,
  rateLoadRate: 0,
  powerPowerUnit: PowerUnitEnum.w,
  powerPowerUnitAppa: PowerUnitEnum.w,
  powerAllInstCapa: 0,
  powerMaxDemandPower: 0,
  powerIsLoadFactor: false,
  powerAveDemandPower: 0,
  powerDemandRate: 0,
  powerLoadRate: 0,
);

/// StateNotifierの中身を定義
class ElecRateNotifier extends StateNotifier<ElecRateData> {
  // 初期化
  ElecRateNotifier() : super(_initData);

  /// 全データの更新(shaerd_prefで使用)
  void updateAll(ElecRateData allData) {
    state = allData;
  }

  /// 電力単位の変更
  void updatePowerUnit(PowerUnitEnum powerUnit) {
    state = state.copyWith(ratePowerUnit: powerUnit);
  }

  /// 電圧単位の倍率設定
  double calcVoltUnitRatio() {
    /// 電圧単位がVなら1倍
    if (state.ratePowerUnit == VoltUnitEnum.v) {
      return 1;
    }

    /// 電圧単位がkVなら1000倍
    return 1000;
  }

  /// 電力単位の倍率設定
  double calcPowerUnitRatio() {
    /// 電力単位がwなら1倍
    if (state.ratePowerUnit == PowerUnitEnum.w) {
      return 1;
    }

    /// 電力単位がkwなら1,000倍
    else if (state.ratePowerUnit == PowerUnitEnum.kw) {
      return 1000;
    }

    /// 電力単位がMWなら1,000,000倍
    return 1000000;
  }

  /// 皮相電力の変更
  void updateApparentPower() {
    /// 読み出し
    double current = state.rateAllInstCapa;

    /// 初期化
    double appaPower = 0;
    double voltUnitRatio = calcVoltUnitRatio();

    // if (phase == PhaseNameEnum.single) {
    //   /// 単相2線電力計算
    //   appaPower = volt * current * voltUnitRatio;
    // } else if (phase == PhaseNameEnum.singlePhaseThreeWire) {
    //   /// 単相3線電力計算
    //   appaPower = 2 * volt * current * voltUnitRatio;
    // } else if (phase == PhaseNameEnum.three) {
    //   /// 三相3線電力計算
    //   appaPower = sqrt(3) * volt * current * voltUnitRatio;
    // }

    /// 書込み
    state = state.copyWith(rateAllInstCapa: appaPower);
  }

  /// 計算実行
  void run() {
    /// 皮相電力を計算
    updateApparentPower();
  }

  /// runメソッドが実行できるか確認するメソッド
  bool isRunCheck(String strVolt, String strCurrent, String strCosFai) {
    try {
      /// 数値に変換できるか確認
      double volt = double.parse(strVolt);
      double current = double.parse(strCurrent);
      double cosFai = double.parse(strCosFai);

      /// 力率が0-100%以外ならfalseを返す
      if (cosFai < 0 || cosFai > 100) {
        return false;
      }

      /// 入力した数値をTextEditingControllerに入れる
      // state = state.copyWith(
      //   volt: volt,
      //   current: current,
      //   cosFai: cosFai,
      // );
    } catch (e) {
      /// 数値変換や整形に失敗した場合、falseを返す
      return false;
    }

    /// すべてクリアだった場合trueを返す
    return true;
  }

  /// 削除
  void removeAll() {
    state = _initData;
  }
}

/// texteditingcontrollerの定義
/// web版は問題ないがandroid版では必ず小数点が入ってしまうため
/// 整数の場合、intからstringに変換

/// 電圧
final elecRateTxtCtrVoltProvider = StateProvider((ref) {
  double volt = ref.watch(elecRateProvider).rateAllInstCapa;
  return TextEditingController(
      text: volt == volt.toInt().toDouble()
          ? volt.toInt().toString()
          : volt.toString());
});

/// 結果の値
/// 皮相電力
final elecRateApparentPowerProvider = StateProvider<String>((ref) {
  /// 読み込み
  double power = ref.watch(elecRateProvider).rateAllInstCapa;
  double powerUnitRatio =
      ref.watch(elecRateProvider.notifier).calcPowerUnitRatio();

  /// 小数点1桁以下を四捨五入してString型に
  String strPower = (power / powerUnitRatio).toStringAsFixed(1);
  return strPower;
});
