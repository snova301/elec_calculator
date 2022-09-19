import 'package:flutter/material.dart';

/// 相選択のenum
enum PhaseNameEnum { single, three, singlePhaseThreeWire }

/// 相選択のenumのextension
extension PhaseNameEnumExt on PhaseNameEnum {
  String get str {
    switch (this) {
      case PhaseNameEnum.single:
        return '単相2線';
      case PhaseNameEnum.three:
        return '三相3線';
      case PhaseNameEnum.singlePhaseThreeWire:
        return '単相3線';
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
        return 'kV';
    }
  }
}

/// 電力単位選択のenum
enum PowerUnitEnum { w, kw, mw }

/// 電力単位選択のenumのextension
extension PowerUnitEnumExt on PowerUnitEnum {
  /// 一般
  String get str {
    switch (this) {
      case PowerUnitEnum.w:
        return '-';
      case PowerUnitEnum.kw:
        return 'k';
      case PowerUnitEnum.mw:
        return 'M';
    }
  }

  /// 皮相電力
  String get strApparent {
    switch (this) {
      case PowerUnitEnum.w:
        return 'VA';
      case PowerUnitEnum.kw:
        return 'kVA';
      case PowerUnitEnum.mw:
        return 'MVA';
    }
  }

  /// 有効電力
  String get strActive {
    switch (this) {
      case PowerUnitEnum.w:
        return 'W';
      case PowerUnitEnum.kw:
        return 'kW';
      case PowerUnitEnum.mw:
        return 'MW';
    }
  }

  /// 無効電力
  String get strReactive {
    switch (this) {
      case PowerUnitEnum.w:
        return 'Var';
      case PowerUnitEnum.kw:
        return 'kVar';
      case PowerUnitEnum.mw:
        return 'MVar';
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
