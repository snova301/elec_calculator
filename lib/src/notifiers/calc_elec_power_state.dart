import 'dart:math';
import 'package:elec_facility_calc/src/model/elec_power_data_model.dart';
import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 電力計算のProviderの定義
final elecPowerProvider =
    StateNotifierProvider<ElecPowerNotifier, ElecPowerData>((ref) {
  return ElecPowerNotifier();
});

/// 初期データ
const _initData = ElecPowerData(
  phase: PhaseNameEnum.single,
  volt: 100,
  voltUnit: VoltUnitEnum.v,
  current: 10,
  cosFai: 80,
  apparentPower: 0,
  activePower: 0,
  reactivePower: 0,
  sinFai: 0,
  powerUnit: PowerUnitEnum.w,
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
  void updatePhase(PhaseNameEnum phase) {
    state = state.copyWith(phase: phase);
  }

  /// 電圧単位の変更
  void updateVoltUnit(VoltUnitEnum voltUnit) {
    state = state.copyWith(voltUnit: voltUnit);
  }

  /// 電力単位の変更
  void updatePowerUnit(PowerUnitEnum powerUnit) {
    state = state.copyWith(powerUnit: powerUnit);
  }

  /// 電圧単位の倍率設定
  double calcVoltUnitRatio() {
    /// 電圧単位がVなら1倍
    if (state.voltUnit == VoltUnitEnum.v) {
      return 1;
    }

    /// 電圧単位がkVなら1000倍
    return 1000;
  }

  /// 電力単位の倍率設定
  double calcPowerUnitRatio() {
    /// 電力単位がwなら1倍
    if (state.powerUnit == PowerUnitEnum.w) {
      return 1;
    }

    /// 電力単位がkwなら1,000倍
    else if (state.powerUnit == PowerUnitEnum.kw) {
      return 1000;
    }

    /// 電力単位がMWなら1,000,000倍
    return 1000000;
  }

  /// 皮相電力の変更
  void updateApparentPower() {
    /// 読み出し
    PhaseNameEnum phase = state.phase;
    double volt = state.volt;
    double current = state.current;

    /// 初期化
    double appaPower = 0;
    double voltUnitRatio = calcVoltUnitRatio();

    if (phase == PhaseNameEnum.single) {
      /// 単相2線電力計算
      appaPower = volt * current * voltUnitRatio;
    } else if (phase == PhaseNameEnum.singlePhaseThreeWire) {
      /// 単相3線電力計算
      appaPower = 2 * volt * current * voltUnitRatio;
    } else if (phase == PhaseNameEnum.three) {
      /// 三相3線電力計算
      appaPower = sqrt(3) * volt * current * voltUnitRatio;
    }

    /// 書込み
    state = state.copyWith(apparentPower: appaPower);
  }

  /// 有効電力の変更
  void updateActivePower() {
    /// 読み込み
    double appaPower = state.apparentPower;
    double cosFai = state.cosFai / 100;

    /// 計算
    double actPower = appaPower * cosFai;

    /// 書込み
    state = state.copyWith(activePower: actPower);
  }

  /// 無効電力の変更
  void updateReactivePower() {
    /// 読み込み
    double appaPower = state.apparentPower;
    double sinFai = state.sinFai;

    /// 計算
    double reactPower = appaPower * sinFai;

    /// 書込み
    state = state.copyWith(reactivePower: reactPower);
  }

  /// sinφの変更
  void updateSinFai() {
    /// 読み込み
    double cosFai = state.cosFai / 100;

    /// cosφからsinφを算出
    double sinFai = sqrt(1 - pow(cosFai, 2));

    /// sinφを書込み
    state = state.copyWith(sinFai: sinFai);
  }

  /// 計算実行
  void run() {
    /// 皮相電力を計算
    updateApparentPower();

    /// sinφを計算
    updateSinFai();

    /// 有効電力の計算
    updateActivePower();

    /// 無効電力の計算
    updateReactivePower();
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
      state = state.copyWith(
        volt: volt,
        current: current,
        cosFai: cosFai,
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

/// 電圧
final elecPowerTxtCtrVoltProvider = StateProvider((ref) {
  double volt = ref.watch(elecPowerProvider).volt;
  return TextEditingController(
      text: volt == volt.toInt().toDouble()
          ? volt.toInt().toString()
          : volt.toString());
});

/// 電流
final elecPowerTxtCtrCurrentProvider = StateProvider((ref) {
  double current = ref.watch(elecPowerProvider).current;
  return TextEditingController(
      text: current == current.toInt().toDouble()
          ? current.toInt().toString()
          : current.toString());
});

/// 力率
final elecPowerTxtCtrCosFaiProvider = StateProvider((ref) {
  double cosFai = ref.watch(elecPowerProvider).cosFai;
  return TextEditingController(
      text: cosFai == cosFai.toInt().toDouble()
          ? cosFai.toInt().toString()
          : cosFai.toString());
});

/// 結果の値
/// 皮相電力
final elecPowerApparentPowerProvider = StateProvider<String>((ref) {
  /// 読み込み
  double power = ref.watch(elecPowerProvider).apparentPower;
  double powerUnitRatio =
      ref.watch(elecPowerProvider.notifier).calcPowerUnitRatio();

  /// 小数点1桁以下を四捨五入してString型に
  String strPower = (power / powerUnitRatio).toStringAsFixed(1);
  return strPower;
});

/// 有効電力
final elecPowerActivePowerProvider = StateProvider((ref) {
  /// 読み込み
  double power = ref.watch(elecPowerProvider).activePower;
  double powerUnitRatio =
      ref.watch(elecPowerProvider.notifier).calcPowerUnitRatio();

  /// 小数点3桁以下を四捨五入してString型に
  String strPower = (power / powerUnitRatio).toStringAsFixed(1);
  return strPower;
});

/// 無効電力
final elecPowerReactivePowerProvider = StateProvider((ref) {
  /// 読み込み
  double power = ref.watch(elecPowerProvider).reactivePower;
  double powerUnitRatio =
      ref.watch(elecPowerProvider.notifier).calcPowerUnitRatio();

  /// 小数点3桁以下を四捨五入してString型に
  String strPower = (power / powerUnitRatio).toStringAsFixed(1);
  return strPower;
});

/// sinφ
final elecPowerSinFaiProvider = StateProvider((ref) {
  /// 読み込み
  double sinFai = ref.watch(elecPowerProvider).sinFai;

  /// 小数点1桁以下を四捨五入してString型に
  String strSinFai = (sinFai * 100).toStringAsFixed(1);
  return strSinFai;
});
