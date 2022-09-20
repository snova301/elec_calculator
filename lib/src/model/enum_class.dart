import 'package:elec_facility_calc/src/view/pages/about_page.dart';
import 'package:elec_facility_calc/src/view/pages/calc_cable_design_page.dart';
import 'package:elec_facility_calc/src/view/pages/calc_conduit_page.dart';
import 'package:elec_facility_calc/src/view/pages/calc_elec_power_page.dart';
import 'package:elec_facility_calc/src/view/pages/setting_page.dart';
import 'package:elec_facility_calc/src/view/pages/wiring_list_page.dart';
import 'package:flutter/material.dart';

/// 相選択のenum
// enum PhaseNameEnum { single, three, singlePhaseThreeWire }

// /// 相選択のenumのextension
// extension PhaseNameEnumExt on PhaseNameEnum {
//   String get str {
//     switch (this) {
//       case PhaseNameEnum.single:
//         return '単相2線';
//       case PhaseNameEnum.three:
//         return '三相3線';
//       case PhaseNameEnum.singlePhaseThreeWire:
//         return '単相3線';
//     }
//   }
// }

enum PhaseNameEnum {
  single('単相2線'),
  three('三相3線'),
  singlePhaseThreeWire('単相3線');

  final String str;
  const PhaseNameEnum(this.str);
}

/// 電圧単位選択のenum
// enum VoltUnitEnum { v, kv }

// /// 電圧単位選択のenumのextension
// extension VoltUnitEnumExt on VoltUnitEnum {
//   String get str {
//     switch (this) {
//       case VoltUnitEnum.v:
//         return 'V';
//       case VoltUnitEnum.kv:
//         return 'kV';
//     }
//   }
// }

enum VoltUnitEnum {
  v('V'),
  kv('kV');

  final String str;
  const VoltUnitEnum(this.str);
}

/// 電力単位選択のenum
// enum PowerUnitEnum { w, kw, mw }

// /// 電力単位選択のenumのextension
// extension PowerUnitEnumExt on PowerUnitEnum {
//   /// 一般
//   String get str {
//     switch (this) {
//       case PowerUnitEnum.w:
//         return '-';
//       case PowerUnitEnum.kw:
//         return 'k';
//       case PowerUnitEnum.mw:
//         return 'M';
//     }
//   }

//   /// 皮相電力
//   String get strApparent {
//     switch (this) {
//       case PowerUnitEnum.w:
//         return 'VA';
//       case PowerUnitEnum.kw:
//         return 'kVA';
//       case PowerUnitEnum.mw:
//         return 'MVA';
//     }
//   }

//   /// 有効電力
//   String get strActive {
//     switch (this) {
//       case PowerUnitEnum.w:
//         return 'W';
//       case PowerUnitEnum.kw:
//         return 'kW';
//       case PowerUnitEnum.mw:
//         return 'MW';
//     }
//   }

//   /// 無効電力
//   String get strReactive {
//     switch (this) {
//       case PowerUnitEnum.w:
//         return 'Var';
//       case PowerUnitEnum.kw:
//         return 'kVar';
//       case PowerUnitEnum.mw:
//         return 'MVar';
//     }
//   }
// }

enum PowerUnitEnum {
  w('-', 'VA', 'W', 'Var'),
  kw('k', 'kVA', 'kW', 'kVar'),
  mw('M', 'MVA', 'MW', 'MVar');

  final String str; // 名称
  final String strApparent; // 皮相電力
  final String strActive; // 有効電力
  final String strReactive; // 無効電力

  const PowerUnitEnum(
      this.str, this.strApparent, this.strActive, this.strReactive);
}

/// ページ名enum
// enum PageNameEnum {
//   toppage,
//   cableDesign,
//   elecPower,
//   conduit,
//   wiring,
//   setting,
//   about,
// }

// /// ページ名enumのextension
// extension PageNameEnumExt on PageNameEnum {
//   String get title {
//     switch (this) {
//       case PageNameEnum.toppage:
//         return 'トップページ';
//       case PageNameEnum.cableDesign:
//         return 'ケーブル設計';
//       case PageNameEnum.elecPower:
//         return '電力計算';
//       case PageNameEnum.conduit:
//         return '電線管設計';
//       case PageNameEnum.wiring:
//         return '配線管理';
//       case PageNameEnum.setting:
//         return '設定';
//       case PageNameEnum.about:
//         return 'About';
//     }
//   }

//   IconData? get icon {
//     switch (this) {
//       case PageNameEnum.toppage:
//         return Icons.home_rounded;
//       case PageNameEnum.cableDesign:
//         return Icons.design_services;
//       case PageNameEnum.elecPower:
//         return Icons.calculate;
//       case PageNameEnum.conduit:
//         return Icons.gavel_rounded;
//       case PageNameEnum.wiring:
//         return Icons.list_alt;
//       case PageNameEnum.setting:
//         return Icons.settings;
//       case PageNameEnum.about:
//         return null;
//     }
//   }
// }

enum PageNameEnum {
  toppage('トップページ', null, Icons.home_rounded),
  cableDesign('ケーブル設計', CalcCableDesignPage(), Icons.design_services),
  elecPower('電力計算', CalcElecPowerPage(), Icons.calculate),
  conduit('電線管設計', CalcConduitPage(), Icons.gavel_rounded),
  wiring('配線管理', WiringListPage(), Icons.list_alt),
  setting('設定', SettingPage(), Icons.settings),
  about('About', AboutPage(), null);

  final String title; // ページ名
  final dynamic page; // ページ遷移
  final IconData? icon; // アイコン

  const PageNameEnum(this.title, this.page, this.icon);
}

/// 配線リストの検索用enum
// enum WiringListSearchEnum { cableData, start, end }

// /// 配線リストの検索用enumのextension
// extension WiringListSearchEnumExt on WiringListSearchEnum {
//   String get message {
//     switch (this) {
//       case WiringListSearchEnum.cableData:
//         return 'ケーブル種類';
//       case WiringListSearchEnum.start:
//         return '出発点';
//       case WiringListSearchEnum.end:
//         return '到着点';
//     }
//   }
// }

enum WiringListSearchEnum {
  cableData('ケーブル種類'),
  start('出発点'),
  end('到着点');

  final String message;
  const WiringListSearchEnum(this.message);
}
