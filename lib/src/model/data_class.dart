import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_class.freezed.dart';

/// ケーブル設計入力のProvider入力データの定義
@freezed
class CableDesignData with _$CableDesignData {
  const factory CableDesignData({
    // 入力
    required String phase, // 相
    required String cableType, // ケーブル種類
    required TextEditingController elecOut, // 電気出力
    required TextEditingController volt, // 電圧
    required TextEditingController cosfai, // 力率
    required TextEditingController cableLength, // ケーブル長さ

    // 出力
    required String current, // 電流
    required String cableSize, // ケーブルサイズ
    required String voltDrop, // 電圧降下
    required String powerLoss, // 電力損失
  }) = _CableDesignData;

  // factory CableDesignData.fromJson(Map<String, Object?> json) =>
  //     _$CableDesignDataFromJson(json);
}

/// 電力計算のProviderデータの定義
@freezed
class ElecPowerData with _$ElecPowerData {
  const factory ElecPowerData({
    // 入力
    required String phase, // 相
    required TextEditingController volt, // 電圧
    required TextEditingController current, // 電流
    required TextEditingController cosFai, // 力率

    // 出力
    required String apparentPower, // 皮相電力
    required String activePower, // 有効電力
    required String reactivePower, // 無効電力
    required String sinFai, // sinφ
  }) = _ElecPowerData;

  // factory ElecPowerData.fromJson(Map<String, Object?> json) =>
  //     _$ElecPowerData(json);
}

/// 電線管設計のProviderデータの定義
@freezed
class ConduitCalcDataClass with _$ConduitCalcDataClass {
  const factory ConduitCalcDataClass({
    required List<ConduitCalcCableDataClass> items, // リスト内のアイテム
    required String conduitType, // 電線管の種類
  }) = _ConduitCalcDataClass;

  // factory ConduitCalcDataClass.fromJson(Map<String, Object?> json) =>
  //     _$ConduitCalcDataClassFromJson(json);
}

/// 電線管設計のListItemデータの定義
class ConduitCalcCableDataClass {
  String cableType; // ケーブル種類
  String cableSize; // ケーブルサイズ
  double cableRadius; // ケーブル半径

  ConduitCalcCableDataClass({
    required this.cableType,
    required this.cableSize,
    required this.cableRadius,
  });
}


// /// データモデルの定義
// class CableDesignOutData {
//   String current; // 電流
//   String cableSize; // ケーブルサイズ
//   String voltDrop; // 電圧降下
//   String powerLoss; // 電力損失

//   CableDesignOutData({
//     required this.current,
//     required this.cableSize,
//     required this.voltDrop,
//     required this.powerLoss,
//   });

  // /// Map型に変換
  // Map toMap() => {
  //       'current': current,
  //       'cableSize': cableSize,
  //       'voltDrop': voltDrop,
  //       'powerLoss': powerLoss,
  //     };

//   /// JSONオブジェクトを代入
//   CableDesignData.fromJson(Map json)
//       : phase = json['phase'],
//         current = json['current'],
//         cableSize = json['cableSize'],
//         voltDrop = json['voltDrop'],
//         powerLoss = json['powerLoss'];
// }

// /// データモデルの定義
// class ElecPowerData {
//   String phase; // 相
//   String apparentPower; // 皮相電力
//   String activePower; // 有効電力
//   String reactivePower; // 無効電力
//   String sinFai; // sinφ

//   ElecPowerData(
//     this.phase,
//     this.apparentPower,
//     this.activePower,
//     this.reactivePower,
//     this.sinFai,
//   );

//   /// Map型に変換
//   Map toJson() => {
//         'phase': phase,
//         'apparentPower': apparentPower,
//         'activePower': activePower,
//         'reactivePower': reactivePower,
//         'sinFai': sinFai,
//       };

//   /// JSONオブジェクトを代入
//   ElecPowerData.fromJson(Map json)
//       : phase = json['phase'],
//         apparentPower = json['apparentPower'],
//         activePower = json['activePower'],
//         reactivePower = json['reactivePower'],
//         sinFai = json['sinFai'];
// }
