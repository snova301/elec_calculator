import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';

/// ケーブル設計入力のProviderの定義
final cableDesignProvider =
    StateNotifierProvider<CableDesignNotifier, CableDesignData>((ref) {
  return CableDesignNotifier();
});

/// ケーブル設計のNotifierの定義
class CableDesignNotifier extends StateNotifier<CableDesignData> {
  // 空のデータとして初期化
  CableDesignNotifier()
      : super(CableDesignData(
          phase: '単相',
          cableType: '600V CV-2C',
          elecOut: TextEditingController(text: '1500'),
          volt: TextEditingController(text: '200'),
          cosFai: TextEditingController(text: '80'),
          cableLength: TextEditingController(text: '10'),
          current: '0',
          cableSize: '0',
          voltDrop: '0',
          powerLoss: '0',
        ));

  /// 相の変更
  void updatePhase(String phase) {
    state = state.copyWith(phase: phase);
  }

  /// ケーブル種類の変更
  void updateCableType(String cableType) {
    state = state.copyWith(cableType: cableType);
  }

  /// 電流の変更
  double updateCurrent(
      String phase, double elecOut, double volt, double cosFai) {
    double current = 0;

    /// 相ごとの計算
    if ((phase == '単相') && (cosFai <= 1)) {
      // 単相の電流計算と計算係数設定
      current = elecOut / (volt * cosFai);
    } else if ((phase == '三相') && (cosFai <= 1)) {
      // 三相の電流計算と計算係数設定
      current = elecOut / (sqrt(3) * volt * cosFai);
    }

    /// 小数点2桁以下を四捨五入してString型に
    String strCurrent = current.toStringAsFixed(1);

    /// 書込み
    state = state.copyWith(current: strCurrent);

    return current;
  }

  /// ケーブルサイズの変更
  Map updateCableSize(double current) {
    /// 計算用変数初期化
    double rVal = 0;
    double xVal = 0;
    String cableType = state.cableType;

    /// ケーブル種類からデータを取得
    /// ケーブルのインピーダンスと許容電流のマップデータ
    Map<String, CableDataClass> cableDataMap =
        CableData().selectCableData(cableType);

    /// ケーブル許容電流からケーブルの太さを選定
    /// 許容電流を満たすケーブルサイズをリストに追加
    List cableAnswerList = [];
    cableDataMap.forEach((key, value) {
      if (value.current >= current) {
        cableAnswerList
            .add([key, value.rVal, value.xVal]); // [ケーブルサイズ, 抵抗, リアクタンス]
      }
    });

    /// 許容電流が満たせない場合は'規格なし'を返す。
    String cableSize = '';
    if (cableAnswerList.isEmpty) {
      cableSize = '規格なし';
      rVal = xVal = 0;
    } else {
      cableSize = cableAnswerList[0][0];
      rVal = cableAnswerList[0][1];
      xVal = cableAnswerList[0][2];
    }

    /// 書込み
    state = state.copyWith(cableSize: cableSize);

    return {'cableSize': cableSize, 'rVal': rVal, 'xVal': xVal};
  }

  /// 電圧降下の変更
  void updateVoltDrop(
    String phase,
    double current,
    double cableLength,
    double rVal,
    double xVal,
    double cosFai,
    double sinFai,
  ) {
    /// 電圧降下計算の係数
    double kVal = 1;

    /// 相ごとの電圧降下計算の係数設定
    if (phase == '単相') {
      kVal = 2;
    } else if (phase == '三相') {
      kVal = sqrt(3);
    }

    /// 電圧降下の計算
    double dVoltDrop =
        kVal * current * cableLength * (rVal * cosFai + xVal * sinFai);

    /// 小数点2桁以下を四捨五入してString型に
    String strVoltDrop = dVoltDrop.toStringAsFixed(1);

    /// 書込み
    state = state.copyWith(voltDrop: strVoltDrop);
  }

  /// 電力損失の変更
  void updatePowerLoss(
    String phase,
    double current,
    double rVal,
    double cableLength,
  ) {
    /// 電力損失計算の係数
    double kVal = 2;

    /// 相ごとの電力損失計算の係数設定
    if (phase == '単相') {
      kVal = 2;
    } else if (phase == '三相') {
      kVal = 3;
    }

    /// 電力損失計算
    double dPowLoss = kVal * rVal * current * current * cableLength;

    /// 小数点2桁以下を四捨五入してString型に
    String strPowLoss = dPowLoss.toStringAsFixed(1);

    /// 書込み
    state = state.copyWith(powerLoss: strPowLoss);
  }

  /// 計算実行
  void run() {
    /// Textfieldのテキストを取得し、doubleに変換
    String phase = state.phase;
    double elecOut = double.parse(state.elecOut.text);
    double cosFai = double.parse(state.cosFai.text) / 100;
    double volt = double.parse(state.volt.text);
    double cableLength = double.parse(state.cableLength.text) / 1000;

    /// cosφからsinφを算出
    double sinFai = sqrt(1 - pow(cosFai, 2));

    /// 電流値の計算
    double current = updateCurrent(phase, elecOut, volt, cosFai);

    /// ケーブルサイズ計算
    Map temp = updateCableSize(current);
    double rVal = temp['rVal'];
    double xVal = temp['xVal'];

    /// ケーブル電圧降下計算
    updateVoltDrop(phase, current, cableLength, rVal, xVal, cosFai, sinFai);

    /// ケーブル電力損失計算
    updatePowerLoss(phase, current, rVal, cableLength);
  }

  /// runメソッドが実行できるか確認するメソッド
  bool isRunCheck() {
    try {
      /// 数値に変換できるか確認
      double elecOut = double.parse(state.elecOut.text);
      double cosFai = double.parse(state.cosFai.text);
      double volt = double.parse(state.volt.text);
      double cableLength = double.parse(state.cableLength.text);

      /// 力率が0-100%以外ならfalseを返す
      if (cosFai < 0 || cosFai > 100) {
        return false;
      }

      /// 入力した数値を整形してTextEditingControllerに入れる
      state = state.copyWith(
        elecOut: TextEditingController(text: elecOut.toString()),
      );
      state = state.copyWith(
        volt: TextEditingController(text: volt.toString()),
      );
      state = state.copyWith(
        cosFai: TextEditingController(text: cosFai.toString()),
      );
      state = state.copyWith(
        cableLength: TextEditingController(text: cableLength.toString()),
      );
    } catch (e) {
      /// 数値変換や整形に失敗した場合、falseを返す
      return false;
    }

    /// すべてクリアだった場合trueを返す
    return true;
  }
}
