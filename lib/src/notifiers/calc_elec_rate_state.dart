import 'dart:math';
import 'package:elec_facility_calc/src/model/elec_rate_data_model.dart';
import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 需要率計算のProviderの定義
final elecRateProvider =
    StateNotifierProvider<ElecRateNotifier, ElecRateData>((ref) {
  return ElecRateNotifier();
});

/// 初期データ
const _initData = ElecRateData(
  ratePowerUnit: PowerUnitEnum.w,
  ratePowerType: PowerTypeEnum.apparent,
  rateAllInstCapa: 0,
  rateMaxDemandPower: 0,
  rateIsLoadFactor: false,
  rateAveDemandPower: 0,
  rateDemandRate: 0,
  rateLoadRate: 0,
  powerPowerUnit: PowerUnitEnum.w,
  powerPowerType: PowerTypeEnum.apparent,
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
  void updateRatePowerUnit(PowerUnitEnum powerUnit) {
    state = state.copyWith(ratePowerUnit: powerUnit);
  }

  /// 電力単位の変更
  void updateRatePowerType(PowerTypeEnum powerType) {
    state = state.copyWith(ratePowerType: powerType);
  }

  /// 負荷率計算の判断チェックボックスの変更
  void updateRateIsLoadFactor(bool val) {
    state = state.copyWith(rateIsLoadFactor: val);
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

  /// 需要率の計算
  void updateDemandRate() {
    /// 読み出し
    double allInstCapa = state.rateAllInstCapa;
    double maxDemandPower = state.rateMaxDemandPower;

    /// 需要率 = 最大需要電力 / 全設備容量 * 100%
    double demandRate = maxDemandPower / allInstCapa * 100;

    /// 書込み
    state = state.copyWith(rateDemandRate: demandRate);
  }

  /// 計算実行
  void run() {
    /// 需要率の計算
    updateDemandRate();
  }

  /// runメソッドが実行できるか確認するメソッド
  bool isRunCheck(
    String strAllInstCapa,
    String strMaxDemandPower,
    String strAveDemandPower,
  ) {
    try {
      /// 読み込み
      bool isLoadFactor = state.rateIsLoadFactor;

      /// 数値に変換できるか確認
      double allInstCapa = double.parse(strAllInstCapa);
      double maxDemandPower = double.parse(strMaxDemandPower);
      double aveDemandPower = double.parse(strAveDemandPower);

      /// 全設備容量が最大需要電力以下ならfalseを返す
      if (allInstCapa < maxDemandPower) {
        return false;
      }

      /// 負荷率を計算するとき、最大需要電力が平均需要電力以下ならfalseを返す
      if (isLoadFactor && maxDemandPower < aveDemandPower) {
        return false;
      }

      /// 全設備容量、最大需要電力が0ならfalseを返す
      if (allInstCapa == 0 || maxDemandPower == 0) {
        return false;
      }

      /// 負荷率を計算するとき、平均需要電力が0ならfalseを返す
      if (isLoadFactor && aveDemandPower == 0) {
        return false;
      }

      /// 入力した数値をstateに入れる
      state = state.copyWith(
        rateAllInstCapa: allInstCapa,
        rateMaxDemandPower: maxDemandPower,
        rateAveDemandPower: aveDemandPower,
      );
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

/// 全設備容量
final elecRateTxtCtrAllInstCapaProvider = StateProvider((ref) {
  double allInstCapa = ref.watch(elecRateProvider).rateAllInstCapa;
  return TextEditingController(
      text: allInstCapa == allInstCapa.toInt().toDouble()
          ? allInstCapa.toInt().toString()
          : allInstCapa.toString());
});

/// 最大需要電力
final elecRateTxtCtrMaxDemandPowerProvider = StateProvider((ref) {
  double maxDemandPower = ref.watch(elecRateProvider).rateMaxDemandPower;
  return TextEditingController(
      text: maxDemandPower == maxDemandPower.toInt().toDouble()
          ? maxDemandPower.toInt().toString()
          : maxDemandPower.toString());
});

/// 平均需要電力
final elecRateTxtCtrAveDemandPowerProvider = StateProvider((ref) {
  double aveDemandPower = ref.watch(elecRateProvider).rateAveDemandPower;
  return TextEditingController(
      text: aveDemandPower == aveDemandPower.toInt().toDouble()
          ? aveDemandPower.toInt().toString()
          : aveDemandPower.toString());
});

/// 結果の値
/// 皮相電力
final elecRateTyperentPowerProvider = StateProvider<String>((ref) {
  /// 読み込み
  double power = ref.watch(elecRateProvider).rateAllInstCapa;
  double powerUnitRatio =
      ref.watch(elecRateProvider.notifier).calcPowerUnitRatio();

  /// 小数点1桁以下を四捨五入してString型に
  String strPower = (power / powerUnitRatio).toStringAsFixed(1);
  return strPower;
});
