import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'data_class.freezed.dart';
part 'data_class.g.dart';

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

/// 相選択のenum
enum PhaseNameEnum { single, three }

/// 相選択のenumのextension
extension PhaseNameEnumExt on PhaseNameEnum {
  String get str {
    switch (this) {
      case PhaseNameEnum.single:
        return '単相';
      case PhaseNameEnum.three:
        return '三相';
    }
  }
}

/// 電圧単位選択のenum
enum VoltUnitEnum { v, kv }

/// 電圧単位選択のenumのextension
extension VoltUnitEnumExt on VoltUnitEnum {
  String get str {
    switch (this) {
      case VoltUnitEnum.v:
        return 'V';
      case VoltUnitEnum.kv:
        return 'KV';
    }
  }
}

/// ページ名enum
enum PageNameEnum {
  toppage,
  cableDesign,
  elecPower,
  conduit,
  wiring,
  setting,
  about,
}

/// ページ名enumのextension
extension PageNameEnumExt on PageNameEnum {
  String get title {
    switch (this) {
      case PageNameEnum.toppage:
        return 'トップページ';
      case PageNameEnum.cableDesign:
        return 'ケーブル設計';
      case PageNameEnum.elecPower:
        return '電力計算';
      case PageNameEnum.conduit:
        return '電線管設計';
      case PageNameEnum.wiring:
        return '配線管理';
      case PageNameEnum.setting:
        return '設定';
      case PageNameEnum.about:
        return 'About';
    }
  }

  IconData? get icon {
    switch (this) {
      case PageNameEnum.toppage:
        return Icons.home_rounded;
      case PageNameEnum.cableDesign:
        return Icons.design_services;
      case PageNameEnum.elecPower:
        return Icons.calculate;
      case PageNameEnum.conduit:
        return Icons.gavel_rounded;
      case PageNameEnum.wiring:
        return Icons.list_alt;
      case PageNameEnum.setting:
        return Icons.settings;
      case PageNameEnum.about:
        return null;
    }
  }
}

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
    required String elecOut,

    /// 電圧
    required String volt,

    /// 力率
    required String cosFai,

    /// ケーブル長さ
    required String cableLength,

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

  /// from Json
  factory CableDesignData.fromJson(Map<String, dynamic> json) =>
      _$CableDesignDataFromJson(json);
}

/// 電力計算のProviderデータの定義
@freezed
class ElecPowerData with _$ElecPowerData {
  const factory ElecPowerData({
    /// 入力
    /// 相
    required String phase,

    /// 電圧
    required String volt,

    /// 電圧単位
    required String? voltUnit,

    /// 電流
    required String current,

    /// 力率
    required String cosFai,

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

  /// from Json
  factory ElecPowerData.fromJson(Map<String, dynamic> json) =>
      _$ElecPowerDataFromJson(json);
}

/// 電線管設計のProviderデータの定義
@freezed
class ConduitCalcDataClass with _$ConduitCalcDataClass {
  const factory ConduitCalcDataClass({
    /// ケーブル種類
    required String cableType,

    /// ケーブルサイズ
    required String cableSize,

    /// ケーブル半径
    required double cableRadius,
  }) = _ConduitCalcDataClass;

  /// from Json
  factory ConduitCalcDataClass.fromJson(Map<String, dynamic> json) =>
      _$ConduitCalcDataClassFromJson(json);
}

/// 配線リストのデータクラス
@freezed
class WiringListDataClass with _$WiringListDataClass {
  const factory WiringListDataClass({
    /// ケーブル名称
    required String name,

    /// 出発点
    required String startPoint,

    /// 到着点
    required String endPoint,

    /// ケーブル種類
    required String cableType,

    /// 備考
    required String remarks,
  }) = _WiringListDataClass;

  /// from Json
  factory WiringListDataClass.fromJson(Map<String, dynamic> json) =>
      _$WiringListDataClassFromJson(json);
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

/// WiringListの検索設定クラス
class WiringListSearchDataClass {
  /// ケーブル種類検索用
  String dropDownCableType;

  WiringListSearchDataClass({
    required this.dropDownCableType,
  });
}

/// なぜかできないenumの進化版
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

/// 設定用のデータクラス
@freezed
class SettingDataClass with _$SettingDataClass {
  const factory SettingDataClass({
    /// ダークモード
    required bool darkMode,
  }) = _SettingDataClass;

  /// from Json
  factory SettingDataClass.fromJson(Map<String, dynamic> json) =>
      _$SettingDataClassFromJson(json);
}



// /// Map型に変換
// Map toMap() => {
//       'current': current,
//       'cableSize': cableSize,
//       'voltDrop': voltDrop,
//       'powerLoss': powerLoss,
//     };

// /// JSONオブジェクトを代入
// CableDesignData.fromJson(Map json)
//     : phase = json['phase'],
//       current = json['current'],
//       cableSize = json['cableSize'],
//       voltDrop = json['voltDrop'],
//       powerLoss = json['powerLoss'];
