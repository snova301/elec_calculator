import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';

/// 電力計算のProviderの定義
final elecPowerProvider =
    StateNotifierProvider<ElecPowerNotifier, ElecPowerData>((ref) {
  return ElecPowerNotifier();
});

/// 初期データ
var _initData = ElecPowerData(
  phase: PhaseNameEnum.single.str,
  volt: '100',
  voltUnit: VoltUnitEnum.v.str,
  current: '10',
  cosFai: '80',
  apparentPower: '0',
  activePower: '0',
  reactivePower: '0',
  sinFai: '0',
);

/// StateNotifierの中身を定義
class ElecPowerNotifier extends StateNotifier<ElecPowerData> {
  // 初期化
  ElecPowerNotifier() : super(_initData);

  /// 全データの更新(shaerd_prefで使用)
  void updateAll(ElecPowerData allData) {
    state = allData;
  }

  /// 相の変更
  void updatePhase(String phase) {
    state = state.copyWith(phase: phase);
  }

  /// 電圧単位の変更
  void updateVoltUnit(String voltUnit) {
    state = state.copyWith(voltUnit: voltUnit);
  }

  /// 電圧単位の倍率設定
  double calcVoltUnitRatio() {
    /// 電圧単位がVなら1倍
    if (state.voltUnit == VoltUnitEnum.v.str) {
      return 1;
    }

    /// 電圧単位がkVなら1000倍
    return 1000;
  }

  /// 皮相電力の変更
  double updateApparentPower(String phase, double volt, double current) {
    double appaPower = 0;
    double voltUnitRatio = calcVoltUnitRatio();
    if (phase == PhaseNameEnum.single.str) {
      /// 単相電力計算
      appaPower = volt * current * voltUnitRatio;
    } else if (phase == PhaseNameEnum.three.str) {
      /// 3相電力計算
      appaPower = sqrt(3) * volt * current * voltUnitRatio;
    }

    /// 小数点2桁以下を四捨五入してString型に
    String strAppaPow = (appaPower / 1000).toStringAsFixed(2);

    /// 書込み
    state = state.copyWith(apparentPower: strAppaPow);
    return appaPower;
  }

  /// 有効電力の変更
  void updateActivePower(double appaPower, double cosFai) {
    /// 計算
    double actPower = appaPower * cosFai;

    /// 小数点2桁以下を四捨五入してString型に
    String strActPower = (actPower / 1000).toStringAsFixed(2);

    /// 書込み
    state = state.copyWith(activePower: strActPower);
  }

  /// 無効電力の変更
  void updateReactivePower(double appaPower, double sinFai) {
    /// 計算
    double reactPower = appaPower * sinFai;

    /// 小数点2桁以下を四捨五入してString型に
    String strReactPower = (reactPower / 1000).toStringAsFixed(2);

    /// 書込み
    state = state.copyWith(reactivePower: strReactPower);
  }

  /// sinφの変更
  double updateSinFai(double cosFai) {
    /// cosφからsinφを算出
    double sinFai = sqrt(1 - pow(cosFai, 2));

    /// 小数点1桁以下を四捨五入してString型に
    String strSinFai = (sinFai * 100).toStringAsFixed(1);

    /// sinφを書込み
    state = state.copyWith(sinFai: strSinFai);

    return sinFai;
  }

  /// 計算実行
  void run(String strVolt, String strCurrent, String strCosFai) {
    /// Textfieldのテキストから取得し、電圧、電流、力率double型へ変換
    String phase = state.phase;
    double volt = double.parse(strVolt);
    double current = double.parse(strCurrent);
    double cosFai = double.parse(strCosFai) / 100;

    /// 皮相電力を計算
    double appaPower = updateApparentPower(phase, volt, current);

    /// sinφを計算
    double sinFai = updateSinFai(cosFai);

    /// 有効電力の計算
    updateActivePower(appaPower, cosFai);

    /// 無効電力の計算
    updateReactivePower(appaPower, sinFai);
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

      /// 入力した数値を整形してTextEditingControllerに入れる
      /// web版は問題ないがandroid版では必ず小数点が入ってしまうため
      /// 整数の場合、intからstringに変換

      /// 電圧
      if (volt.toDouble() == volt.toInt().toDouble()) {
        state = state.copyWith(
          volt: volt.toInt().toString(),
        );
      } else {
        state = state.copyWith(
          volt: volt.toString(),
        );
      }

      /// 電流
      if (current.toDouble() == current.toInt().toDouble()) {
        state = state.copyWith(
          current: current.toInt().toString(),
        );
      } else {
        state = state.copyWith(
          current: current.toString(),
        );
      }

      /// 力率
      if (cosFai.toDouble() == cosFai.toInt().toDouble()) {
        state = state.copyWith(
          cosFai: cosFai.toInt().toString(),
        );
      } else {
        state = state.copyWith(
          cosFai: cosFai.toString(),
        );
      }
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
final elecPowerTxtCtrVoltProvider = StateProvider((ref) {
  return TextEditingController(text: ref.watch(elecPowerProvider).volt);
});

final elecPowerTxtCtrCurrentProvider = StateProvider((ref) {
  return TextEditingController(text: ref.watch(elecPowerProvider).current);
});

final elecPowerTxtCtrCosFaiProvider = StateProvider((ref) {
  return TextEditingController(text: ref.watch(elecPowerProvider).cosFai);
});
