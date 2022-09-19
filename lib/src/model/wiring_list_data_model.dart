import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wiring_list_data_model.freezed.dart';
part 'wiring_list_data_model.g.dart';

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
