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
  void updatePhase(String phase) {
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
    String phase = state.phase;
    double volt = state.volt;
    double current = state.current;

    /// 初期化
    double appaPower = 0;
    double voltUnitRatio = calcVoltUnitRatio();

    if (phase == PhaseNameEnum.single.str) {
      /// 単相電力計算
      appaPower = volt * current * voltUnitRatio;
    } else if (phase == PhaseNameEnum.three.str) {
      /// 3相電力計算
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

      /// 入力した数値を整形してTextEditingControllerに入れる
      /// web版は問題ないがandroid版では必ず小数点が入ってしまうため
      /// 整数の場合、intからstringに変換

      /// 電圧
      if (volt == volt.toInt().toDouble()) {
        state = state.copyWith(
          volt: volt.toInt().toDouble(),
        );
      } else {
        state = state.copyWith(
          volt: volt,
        );
      }

      /// 電流
      if (current == current.toInt().toDouble()) {
        state = state.copyWith(
          current: current.toInt().toDouble(),
        );
      } else {
        state = state.copyWith(
          current: current,
        );
      }

      /// 力率
      if (cosFai == cosFai.toInt().toDouble()) {
        state = state.copyWith(
          cosFai: cosFai.toInt().toDouble(),
        );
      } else {
        state = state.copyWith(
          cosFai: cosFai,
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
  return TextEditingController(
      text: ref.watch(elecPowerProvider).volt.toString());
});

final elecPowerTxtCtrCurrentProvider = StateProvider((ref) {
  return TextEditingController(
      text: ref.watch(elecPowerProvider).current.toString());
});

final elecPowerTxtCtrCosFaiProvider = StateProvider((ref) {
  return TextEditingController(
      text: ref.watch(elecPowerProvider).cosFai.toString());
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
