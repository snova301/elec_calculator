import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_class.freezed.dart';

/// ケーブル設計入力のProvider入力データの定義
@freezed
class CableDesignData with _$CableDesignData {
  const factory CableDesignData({
    /// 入力
    /// 相
    required String phase,

    /// ケーブル種類
    required String cableType,

    /// 電気出力
    required TextEditingController elecOut,

    /// 電圧
    required TextEditingController volt,

    /// 力率
    required TextEditingController cosFai,

    /// ケーブル長さ
    required TextEditingController cableLength,

    /// 出力
    /// 電流
    required String current,

    /// ケーブルサイズ
    required String cableSize,

    /// 電圧降下
    required String voltDrop,

    /// 電力損失
    required String powerLoss,
  }) = _CableDesignData;

  // factory CableDesignData.fromJson(Map<String, Object?> json) =>
  //     _$CableDesignDataFromJson(json);
}

/// 電力計算のProviderデータの定義
@freezed
class ElecPowerData with _$ElecPowerData {
  const factory ElecPowerData({
    /// 入力
    /// 相
    required String phase,

    /// 電圧
    required TextEditingController volt,

    /// 電流
    required TextEditingController current,

    /// 力率
    required TextEditingController cosFai,

    /// 出力
    /// 皮相電力
    required String apparentPower,

    /// 有効電力
    required String activePower,

    /// 無効電力
    required String reactivePower,

    /// sinφ
    required String sinFai,
  }) = _ElecPowerData;

  // factory ElecPowerData.fromJson(Map<String, Object?> json) =>
  //     _$ElecPowerData(json);
}

/// 電線管設計のProviderデータの定義
@freezed
class ConduitCalcDataClass with _$ConduitCalcDataClass {
  const factory ConduitCalcDataClass({
    /// リスト内のアイテム
    required List<ConduitCalcCableDataClass> items,

    /// 電線管の種類
    required String conduitType,
  }) = _ConduitCalcDataClass;

  // factory ConduitCalcDataClass.fromJson(Map<String, Object?> json) =>
  //     _$ConduitCalcDataClassFromJson(json);
}

/// 電線管設計のListItemデータの定義
class ConduitCalcCableDataClass {
  /// ケーブル種類
  String cableType;

  /// ケーブルサイズ
  String cableSize;

  /// ケーブル半径
  double cableRadius;

  ConduitCalcCableDataClass({
    required this.cableType,
    required this.cableSize,
    required this.cableRadius,
  });
}

/// ケーブルのMapデータの定義
class CableDataClass {
  /// 抵抗(Ω/km)
  double rVal;

  /// リアクタンス(Ω/km)
  double xVal;

  /// 許容電流(A)
  double current;

  /// 仕上外径(mm)
  /// CVTケーブルの場合はケーブル1条あたりの外径
  double diameter;

  CableDataClass({
    required this.rVal,
    required this.xVal,
    required this.current,
    required this.diameter,
  });
}

class WiringListDataClass {
  /// ケーブル名称
  String name;

  /// 出発点
  String startPoint;

  /// 到着点
  String endPoint;

  /// ケーブル種類
  String cableType;

  /// 備考
  String remarks;

  WiringListDataClass({
    required this.name,
    required this.startPoint,
    required this.endPoint,
    required this.cableType,
    required this.remarks,
  });
}

/// WiringListページ間の設定クラス
class WiringListSettingDataClass {
  /// 新規作成ページか編集ページか
  bool isCreate;

  /// ID
  String id;

  /// ケーブル名称
  TextEditingController nameController;

  /// ケーブル種類
  String cableType;

  /// 出発点
  TextEditingController startPointController;

  /// 到着点
  TextEditingController endPointController;

  /// 備考
  TextEditingController remarksController;

  WiringListSettingDataClass({
    required this.isCreate,
    required this.id,
    required this.nameController,
    required this.cableType,
    required this.startPointController,
    required this.endPointController,
    required this.remarksController,
  });
}

/// WiringListページ間の設定クラス
class WiringListSearchDataClass {
  /// ケーブル種類検索用
  String dropDownCableType;

  WiringListSearchDataClass({
    required this.dropDownCableType,
  });
}

/// なぜかできないenumの進化版
// enum AuthException1 {
//   invalidEmail('Invalid email'),
//   emailAlreadyInUse('Email already in use'),
//   weakPassword('Password is too weak'),
//   wrongPassword('Wrong password');

//   const AuthException1(this.message);
//   final String message;
// }

// enum WiringListSearchEnum {
//   cableData('ケーブル種類'),
//   start('出発点'),
//   end('到着点');

//   const WiringListSearchEnum(this.name);
//   final String name;
// }

/// 配線リストの検索用enum
enum WiringListSearchEnum { cableData, start, end }

/// 配線リストの検索用enumのextension
extension WiringListSearchEnumExt on WiringListSearchEnum {
  String get message {
    switch (this) {
      case WiringListSearchEnum.cableData:
        return 'ケーブル種類';
      case WiringListSearchEnum.start:
        return '出発点';
      case WiringListSearchEnum.end:
        return '到着点';
    }
  }
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
