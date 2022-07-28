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

/// 初期値
var _initData = CableDesignData(
  phase: PhaseNameEnum.single,
  cableType: CableTypeEnum.cv2c600v.str,
  elecOut: 1500,
  volt: 200,
  cosFai: 80,
  cableLength: 10,
  current: 0,
  cableSize1: '0',
  voltDrop1: 0,
  powerLoss1: 0,
  cableSize2: '0',
  voltDrop2: 0,
  powerLoss2: 0,
  powerUnit: PowerUnitEnum.w,
  voltUnit: VoltUnitEnum.v,
);

/// ケーブル設計のNotifierの定義
class CableDesignNotifier extends StateNotifier<CableDesignData> {
  /// 空のデータとして初期化
  CableDesignNotifier() : super(_initData);

  /// 全データの更新(shaerd_prefで使用)
  void updateAll(CableDesignData allData) {
    state = allData;
  }

  /// 相の変更
  void updatePhase(PhaseNameEnum phase) {
    state = state.copyWith(phase: phase);
  }

  /// ケーブル種類の変更
  void updateCableType(String cableType) {
    state = state.copyWith(cableType: cableType);
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

  /// 電流の変更
  void updateCurrent() {
    /// 倍率読み込み
    double powerUnitRatio = calcPowerUnitRatio();
    double voltUnitRatio = calcVoltUnitRatio();

    /// 読み込み
    PhaseNameEnum phase = state.phase;
    double elecOut = state.elecOut * powerUnitRatio;
    double volt = state.volt * voltUnitRatio;
    double cosFai = state.cosFai / 100;

    /// 初期化
    double current = 0;

    /// 相ごとの計算
    if ((phase == PhaseNameEnum.single) && (cosFai <= 1)) {
      // 単相2線の電流計算と計算係数設定
      current = elecOut / (volt * cosFai);
    } else if ((phase == PhaseNameEnum.three) && (cosFai <= 1)) {
      // 三相3線の電流計算と計算係数設定
      current = elecOut / (sqrt(3) * volt * cosFai);
    } else if ((phase == PhaseNameEnum.singlePhaseThreeWire) && (cosFai <= 1)) {
      // 単相3線の電流計算と計算係数設定
      current = elecOut / (volt * cosFai);
    }

    /// 書込み
    state = state.copyWith(current: current);
  }

  List calcCableSize() {
    /// 計算用変数初期化
    String cableType = state.cableType;
    double current = state.current;

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

    return cableAnswerList;
  }

  /// ケーブルサイズの変更
  Map updateCableSize() {
    /// 読み込み
    double voltUnitRatio = calcVoltUnitRatio();
    double volt = state.volt * voltUnitRatio;
    String cableType = state.cableType;

    /// 計算用変数初期化
    String cableSize1 = '候補なし';
    String cableSize2 = '候補なし';
    double rVal1 = 0;
    double xVal1 = 0;
    double rVal2 = 0;
    double xVal2 = 0;
    List cableAnswerList = [];

    /// 計算電圧が選択されたケーブルの最高電圧以下かを調査
    List cableTypeList = CableData().cableTypeVoltList(volt);
    bool containsCableType = cableTypeList.contains(cableType);

    /// ケーブル候補の選定
    if (containsCableType) {
      cableAnswerList = calcCableSize();
    }

    /// 第1候補の選定
    /// 許容電流が満たせない場合は'候補なし'を返す。
    if (cableAnswerList.isEmpty) {
      rVal1 = xVal1 = 0;
    } else {
      cableSize1 = cableAnswerList[0][0];
      rVal1 = cableAnswerList[0][1];
      xVal1 = cableAnswerList[0][2];

      /// 第2候補の選定
      /// 許容電流が満たせない場合は'候補なし'を返す。
      cableAnswerList.removeAt(0);
      if (cableAnswerList.isEmpty) {
        rVal2 = xVal2 = 0;
      } else {
        cableSize2 = cableAnswerList[0][0];
        rVal2 = cableAnswerList[0][1];
        xVal2 = cableAnswerList[0][2];
      }
    }

    /// 書込み
    state = state.copyWith(cableSize1: cableSize1);
    state = state.copyWith(cableSize2: cableSize2);

    return {'rVal1': rVal1, 'xVal1': xVal1, 'rVal2': rVal2, 'xVal2': xVal2};
  }

  /// 電圧降下の変更
  void updateVoltDrop(double rVal, double xVal, double sinFai, int sizeNum) {
    /// 読み込み
    PhaseNameEnum phase = state.phase;
    double current = state.current;
    double cosFai = state.cosFai / 100;
    double cableLength = state.cableLength / 1000;

    /// 電圧降下計算の係数
    double kVal = 0;

    /// 相ごとの電圧降下計算の係数設定
    if (phase == PhaseNameEnum.single) {
      kVal = 2;
    } else if (phase == PhaseNameEnum.three) {
      kVal = sqrt(3);
    } else if (phase == PhaseNameEnum.singlePhaseThreeWire) {
      kVal = 1;
    }

    /// 電圧降下の計算
    double dVoltDrop =
        kVal * current * cableLength * (rVal * cosFai + xVal * sinFai);

    /// 書込み
    if (sizeNum == 1) {
      /// 第1候補
      state = state.copyWith(voltDrop1: dVoltDrop);
    } else if (sizeNum == 2) {
      /// 第2候補
      state = state.copyWith(voltDrop2: dVoltDrop);
    }
  }

  /// 電力損失の変更
  void updatePowerLoss(double rVal, int sizeNum) {
    /// 読み込み
    PhaseNameEnum phase = state.phase;
    double current = state.current;
    double cableLength = state.cableLength / 1000;

    /// 電力損失計算の係数
    double kVal = 0;

    /// 相ごとの電力損失計算の係数設定
    if (phase == PhaseNameEnum.single) {
      kVal = 2;
    } else if (phase == PhaseNameEnum.three) {
      kVal = 3;
    } else if (phase == PhaseNameEnum.singlePhaseThreeWire) {
      kVal = 2;
    }

    /// 電力損失計算
    double dPowLoss = kVal * rVal * current * current * cableLength;

    /// 書込み
    if (sizeNum == 1) {
      /// 第1候補
      state = state.copyWith(powerLoss1: dPowLoss);
    } else if (sizeNum == 2) {
      /// 第2候補
      state = state.copyWith(powerLoss2: dPowLoss);
    }
  }

  /// 計算実行
  void run() {
    /// Textfieldのテキストを取得し、doubleに変換
    double cosFai = state.cosFai / 100;

    /// cosφからsinφを算出
    double sinFai = sqrt(1 - pow(cosFai, 2));

    /// 電流値の計算
    updateCurrent();

    /// ケーブルサイズ計算
    Map temp = updateCableSize();
    double rVal1 = temp['rVal1'];
    double xVal1 = temp['xVal1'];
    double rVal2 = temp['rVal2'];
    double xVal2 = temp['xVal2'];

    /// 第1候補の計算
    /// ケーブル電圧降下計算
    updateVoltDrop(rVal1, xVal1, sinFai, 1);

    /// ケーブル電力損失計算
    updatePowerLoss(rVal1, 1);

    /// 第2候補の計算
    /// ケーブル電圧降下計算
    updateVoltDrop(rVal2, xVal2, sinFai, 2);

    /// ケーブル電力損失計算
    updatePowerLoss(rVal2, 2);
  }

  /// runメソッドが実行できるか確認するメソッド
  bool isRunCheck(
    String strElecOut,
    String strVolt,
    String strCosFai,
    String strCableLength,
  ) {
    try {
      /// 数値に変換できるか確認
      double elecOut = double.parse(strElecOut);
      double volt = double.parse(strVolt);
      double cosFai = double.parse(strCosFai);
      double cableLength = double.parse(strCableLength);

      /// 力率が0-100%以外ならfalseを返す
      if (cosFai < 0 || cosFai > 100) {
        return false;
      }

      /// 入力した数値を整形してTextEditingControllerに入れる
      /// web版は問題ないがandroid版では必ず小数点が入ってしまうため
      /// 整数の場合、intからstringに変換

      /// 電気出力
      if (elecOut == elecOut.toInt().toDouble()) {
        state = state.copyWith(
          elecOut: elecOut.toInt().toDouble(),
        );
      } else {
        state = state.copyWith(
          elecOut: elecOut,
        );
      }

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

      /// ケーブル長
      if (cableLength == cableLength.toInt().toDouble()) {
        state = state.copyWith(
          cableLength: cableLength.toInt().toDouble(),
        );
      } else {
        state = state.copyWith(
          cableLength: cableLength,
        );
      }
    } catch (e) {
      /// 数値変換や整形に失敗した場合、falseを返す
      return false;
    }

    /// すべてクリアだった場合trueを返す
    return true;
  }

  /// クリア
  void removeAll() {
    state = _initData;
  }
}

/// texteditingcontrollerの定義
final cableDesignTxtCtrElecOutProvider = StateProvider((ref) {
  return TextEditingController(
      text: ref.watch(cableDesignProvider).elecOut.toString());
});

final cableDesignTxtCtrVoltProvider = StateProvider((ref) {
  return TextEditingController(
      text: ref.watch(cableDesignProvider).volt.toString());
});

final cableDesignTxtCtrCosFaiProvider = StateProvider((ref) {
  return TextEditingController(
      text: ref.watch(cableDesignProvider).cosFai.toString());
});

final cableDesignTxtCtrLengthProvider = StateProvider((ref) {
  return TextEditingController(
      text: ref.watch(cableDesignProvider).cableLength.toString());
});

// /// ケーブル種類のドロップダウンメニューリスト
// final cableDesignCableTypeDDMenuProvider = StateProvider<List<String>>((ref) {
//   /// 読み込み
//   double volt =
//   List<String> cableTypeList = CableData().cableTypeVoltList(volt);
//   // List<String> cableTypeList = CableData().cableTypeList;

//   return cableTypeList;
// });

/// 結果の値
/// 電流
final cableDesignCurrentProvider = StateProvider<String>((ref) {
  /// 読み込み
  double current = ref.watch(cableDesignProvider).current;

  /// 小数点1桁以下を四捨五入してString型に
  String strPower = current.toStringAsFixed(1);
  return strPower;
});

/// 電圧降下
final cableDesignVoltDrop1Provider = StateProvider((ref) {
  /// 読み込み
  double voltDrop = ref.watch(cableDesignProvider).voltDrop1;

  /// 小数点3桁以下を四捨五入してString型に
  String strVoltDrop = voltDrop.toStringAsFixed(1);
  return strVoltDrop;
});

/// 電力損失
final cableDesignPowerLoss1Provider = StateProvider((ref) {
  /// 読み込み
  double powerLoss = ref.watch(cableDesignProvider).powerLoss1;

  /// 小数点3桁以下を四捨五入してString型に
  String strPowerLoss = powerLoss.toStringAsFixed(1);
  return strPowerLoss;
});

/// 電圧降下
final cableDesignVoltDrop2Provider = StateProvider((ref) {
  /// 読み込み
  double voltDrop = ref.watch(cableDesignProvider).voltDrop2;

  /// 小数点3桁以下を四捨五入してString型に
  String strVoltDrop = voltDrop.toStringAsFixed(1);
  return strVoltDrop;
});

/// 電力損失
final cableDesignPowerLoss2Provider = StateProvider((ref) {
  /// 読み込み
  double powerLoss = ref.watch(cableDesignProvider).powerLoss2;

  /// 小数点3桁以下を四捨五入してString型に
  String strPowerLoss = powerLoss.toStringAsFixed(1);
  return strPowerLoss;
});
