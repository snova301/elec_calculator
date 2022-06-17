import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:elec_facility_calc/main.dart';

class StateManagerClass {
  /// shared_preferenceで保存するためのMap
  final sharedPrefMapProvider = StateProvider((ref) => {
        /// shared_preferenceでケーブル設計を保存するためのMap
        'cable design phase': ref.watch(cableDesignPhaseProvider),
        'cable design type': ref.watch(cableDesignCableTypeProvider),
        'cable design elec out': ref.watch(cableDesignElecOutProvider).text,
        'cable design cosfai': ref.watch(cableDesignCosFaiProvider).text,
        'cable design volt': ref.watch(cableDesignVoltProvider).text,
        'cable design cable length':
            ref.watch(cableDesignCableLenProvider).text,
        'cable design current': ref.watch(cableDesignCurrentProvider),
        'cable design cable size': ref.watch(cableDesignCableSizeProvider),
        'cable design volt drop': ref.watch(cableDesignVoltDropProvider),
        'cable design power loss': ref.watch(cableDesignPowerLossProvider),

        /// shared_preferenceで電線管設計を保存するためのMap
        'conduit list': ref.watch(conduitListItemProvider),
        'conduit cable size list': ref.watch(conduitCableSizeListProvider),
        'conduit select cable type': ref.watch(conduitConduitTypeProvider),
        'conduit select cable size32': ref.watch(conduitConduitSize32Provider),
        'conduit select cable size48': ref.watch(conduitConduitSize48Provider),

        /// shared_preferenceで電力計算を保存するためのMap
        'elec power phase': ref.watch(elecPowerPhaseProvider),
        'elec power volt': ref.watch(elecPowerVoltProvider).text,
        'elec power current': ref.watch(elecPowerCurrentProvider).text,
        'elec power cosfai': ref.watch(elecPowerCosFaiProvider).text,
        'elec power apparent power': ref.watch(elecPowerApparentPowerProvider),
        'elec power active power': ref.watch(elecPowerActivePowerProvider),
        'elec power reactive power': ref.watch(elecPowerReactivePowerProvider),
        'elec power sinfai': ref.watch(elecPowerSinFaiProvider),
      });

  /// ダークモード状態をshared_preferencesで取得
  void getDarkmodeVal(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ref.watch(isDarkmodeProvider.state).state =
        prefs.getBool('darkmode') ?? true;
  }

  /// ダークモード状態をshared_preferencesに書き込み
  void setDarkmodeVal(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkmode', ref.read(isDarkmodeProvider));
  }

  /// 以前の計算結果をshared_preferencesで取得
  void getCalcData(WidgetRef ref) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var _getData = prefs.getString('CulcData') ?? '';
    if (_getData != '') {
      var _getDataMap = json.decode(_getData);

      /// ケーブル設計
      ref.watch(cableDesignPhaseProvider.state).state =
          _getDataMap['cable design phase'];
      ref.watch(cableDesignCableTypeProvider.state).state =
          _getDataMap['cable design type'];
      cableDesignElecOutProvider = StateProvider((ref) {
        return TextEditingController(
            text: _getDataMap['cable design elec out']);
      });
      cableDesignCosFaiProvider = StateProvider((ref) {
        return TextEditingController(text: _getDataMap['cable design cosfai']);
      });
      cableDesignVoltProvider = StateProvider((ref) {
        return TextEditingController(text: _getDataMap['cable design volt']);
      });
      cableDesignCableLenProvider = StateProvider((ref) {
        return TextEditingController(
            text: _getDataMap['cable design cable length']);
      });
      ref.watch(cableDesignCurrentProvider.state).state =
          _getDataMap['cable design current'];
      ref.watch(cableDesignCableSizeProvider.state).state =
          _getDataMap['cable design cable size'];
      ref.watch(cableDesignVoltDropProvider.state).state =
          _getDataMap['cable design volt drop'];
      ref.watch(cableDesignPowerLossProvider.state).state =
          _getDataMap['cable design power loss'];

      /// 電線管設計
      ref.watch(conduitListItemProvider.state).state =
          _getDataMap['conduit list'];
      ref.watch(conduitCableSizeListProvider.state).state =
          _getDataMap['conduit cable size list'];
      ref.watch(conduitConduitTypeProvider.state).state =
          _getDataMap['conduit select cable type'];
      ref.watch(conduitConduitSize32Provider.state).state =
          _getDataMap['conduit select cable size32'];
      ref.watch(conduitConduitSize48Provider.state).state =
          _getDataMap['conduit select cable size48'];

      /// 電力計算
      ref.watch(elecPowerPhaseProvider.state).state =
          _getDataMap['elec power phase'];
      elecPowerVoltProvider = StateProvider((ref) {
        return TextEditingController(text: _getDataMap['elec power volt']);
      });
      elecPowerCurrentProvider = StateProvider((ref) {
        return TextEditingController(text: _getDataMap['elec power current']);
      });
      elecPowerCosFaiProvider = StateProvider((ref) {
        return TextEditingController(text: _getDataMap['elec power cosfai']);
      });
      ref.watch(elecPowerApparentPowerProvider.state).state =
          _getDataMap['elec power apparent power'];
      ref.watch(elecPowerActivePowerProvider.state).state =
          _getDataMap['elec power active power'];
      ref.watch(elecPowerReactivePowerProvider.state).state =
          _getDataMap['elec power reactive power'];
      ref.watch(elecPowerSinFaiProvider.state).state =
          _getDataMap['elec power sinfai'];
    }
  }

  /// 計算結果をshared_preferencesに書き込み
  void setCalcData(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _setData = json.encode(ref.read(sharedPrefMapProvider));
    prefs.setString('CulcData', _setData);
  }

  /// 以前の計算データをshared_preferencesから削除
  void removeCalcData(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// 設定
    prefs.remove('CulcData');
    ref.read(sharedPrefMapProvider).clear();

    /// ケーブル設計
    ref.read(cableDesignCurrentProvider.state).state = '0';
    ref.read(cableDesignCableSizeProvider.state).state = '0';
    ref.read(cableDesignVoltDropProvider.state).state = '0';
    ref.read(cableDesignPowerLossProvider.state).state = '0';

    /// 電線管設計
    ref.read(conduitListItemProvider.state).state = [];
    ref.read(conduitCableSizeListProvider.state).state = [];
    ref.read(conduitConduitTypeProvider.state).state = 'PF管';
    ref.read(conduitConduitSize32Provider.state).state = '';
    ref.read(conduitConduitSize48Provider.state).state = '';

    /// 電力計算
    ref.read(elecPowerApparentPowerProvider.state).state = '0';
    ref.read(elecPowerActivePowerProvider.state).state = '0';
    ref.read(elecPowerReactivePowerProvider.state).state = '0';
    ref.read(elecPowerSinFaiProvider.state).state = '0';
  }
}

// /// データモデルの定義
// class CableDesignData {
//   String phase; // 相
//   String current; // 電流
//   String cableSize; // ケーブルサイズ
//   String voltDrop; // 電圧降下
//   String powerLoss; // 電力損失
//   CableDesignData(
//     this.phase,
//     this.current,
//     this.cableSize,
//     this.voltDrop,
//     this.powerLoss,
//   );

//   /// Map型に変換
//   Map toJson() => {
//         'phase': phase,
//         'current': current,
//         'cableSize': cableSize,
//         'voltDrop': voltDrop,
//         'powerLoss': powerLoss,
//       };

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
