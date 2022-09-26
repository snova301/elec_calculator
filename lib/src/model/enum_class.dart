import 'package:elec_facility_calc/src/view/pages/about_page.dart';
import 'package:elec_facility_calc/src/view/pages/calc_cable_design_page.dart';
import 'package:elec_facility_calc/src/view/pages/calc_conduit_page.dart';
import 'package:elec_facility_calc/src/view/pages/calc_elec_power_page.dart';
import 'package:elec_facility_calc/src/view/pages/home_page.dart';
import 'package:elec_facility_calc/src/view/pages/setting_page.dart';
import 'package:elec_facility_calc/src/view/pages/show_law_select_page.dart';
import 'package:elec_facility_calc/src/view/pages/wiring_list_page.dart';
import 'package:flutter/material.dart';

/// 相選択のenum
enum PhaseNameEnum {
  single('単相2線'),
  three('三相3線'),
  singlePhaseThreeWire('単相3線');

  final String str;
  const PhaseNameEnum(this.str);
}

/// 電圧単位選択のenum
enum VoltUnitEnum {
  v('V'),
  kv('kV');

  final String str;
  const VoltUnitEnum(this.str);
}

/// 電力単位選択のenum
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
enum PageNameEnum {
  toppage('トップページ', MyHomePage(), Icons.home_rounded),
  cableDesign('ケーブル設計', CalcCableDesignPage(), Icons.design_services),
  elecPower('電力計算', CalcElecPowerPage(), Icons.calculate),
  conduit('電線管設計', CalcConduitPage(), Icons.gavel_rounded),
  wiring('配線管理', WiringListPage(), Icons.list_alt),
  showLaw('法律表示', ShowLawPage(), Icons.list_alt),
  setting('設定', SettingPage(), Icons.settings),
  about('About', AboutPage(), null);

  final String title; // ページ名
  final dynamic page; // ページ遷移
  final IconData? icon; // アイコン

  const PageNameEnum(this.title, this.page, this.icon);
}

/// 配線リストの検索用enum
enum WiringListSearchEnum {
  cableData('ケーブル種類'),
  start('出発点'),
  end('到着点');

  final String message;
  const WiringListSearchEnum(this.message);
}
