import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';

/// 電力計算のProviderの定義
final elecPowerProvider =
    StateNotifierProvider<ElecPowerNotifier, ElecPowerData>((ref) {
  return ElecPowerNotifier();
});

/// StateNotifierの中身を定義
class ElecPowerNotifier extends StateNotifier<ElecPowerData> {
  // 空のマップとして初期化
  ElecPowerNotifier()
      : super(
          ElecPowerData(
            phase: '単相',
            volt: TextEditingController(text: '100'),
            current: TextEditingController(text: '10'),
            cosFai: TextEditingController(text: '80'),
            apparentPower: '0',
            activePower: '0',
            reactivePower: '0',
            sinFai: '0',
          ),
        );

  /// 相の変更
  void updatePhase(String phase) {
    state = state.copyWith(phase: phase);
  }

  /// 皮相電力の変更
  double updateApparentPower(String phase, double volt, double current) {
    double appaPower = 0;
    if (phase == '単相') {
      /// 単相電力計算
      appaPower = volt * current;
    } else if (phase == '三相') {
      /// 3相電力計算
      appaPower = sqrt(3) * volt * current;
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
  void run() {
    /// Textfieldのテキストから取得し、電圧、電流、力率double型へ変換
    String phase = state.phase;
    double volt = double.parse(state.volt.text);
    double current = double.parse(state.current.text);
    double cosFai = double.parse(state.cosFai.text) / 100;

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
  bool isRunCheck() {
    try {
      /// 数値に変換できるか確認
      double volt = double.parse(state.volt.text);
      double current = double.parse(state.current.text);
      double cosFai = double.parse(state.cosFai.text);

      /// 力率が0-100%以外ならfalseを返す
      if (cosFai < 0 || cosFai > 100) {
        return false;
      }

      /// 入力した数値を整形してTextEditingControllerに入れる
      state = state.copyWith(
        volt: TextEditingController(text: volt.toString()),
      );
      state = state.copyWith(
        current: TextEditingController(text: current.toString()),
      );
      state = state.copyWith(
        cosFai: TextEditingController(text: cosFai.toString()),
      );
    } catch (e) {
      /// 数値変換や整形に失敗した場合、falseを返す
      return false;
    }

    /// すべてクリアだった場合trueを返す
    return true;
  }
}
