import 'dart:convert';
import 'package:elec_facility_calc/src/model/data_class.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_cable_design_state.dart';
import 'package:elec_facility_calc/src/viewmodel/calc_elec_power_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateManagerClass {
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
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // var getData = prefs.getString('CulcData') ?? '';
    // if (getData != '') {
    //   var getDataMap = json.decode(getData);
    // }
  }

  /// 計算結果をshared_preferencesに書き込み
  void setCalcData(WidgetRef ref) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var setData = json.encode(ref.read(sharedPrefMapProvider));
    // prefs.setString('CulcData', setData);
  }

  /// 以前の計算データをshared_preferencesから削除
  void removeCalcData(WidgetRef ref) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    /// 設定
    // prefs.remove('CulcData');
    // ref.read(sharedPrefMapProvider).clear();
  }

  /// shared_preferencesの読込み
  void getSettingPref(WidgetRef ref) async {
    /// 初期化
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// ケーブル設計のデータ読み込み
    var getCableDesign = prefs.getString(SharedPrefEnum.calcCableDesign.name);
    // print(getCableDesign);
    /// データがない場合、nullになるので、null以外の場合でデコードする
    if (getCableDesign != null) {
      var getCableDesignData =
          CableDesignData.fromJson(jsonDecode(getCableDesign));
      print(getCableDesignData);
      ref.read(cableDesignProvider.notifier).updateAll(getCableDesignData);
    }

    /// 電力計算のデータ読み込み
    var getElecPower = prefs.getString(SharedPrefEnum.calcPower.name);
    // print(getElecPower);
    /// データがない場合、nullになるので、null以外の場合でデコードする
    if (getElecPower != null) {
      var getElecPowerData = ElecPowerData.fromJson(jsonDecode(getElecPower));
      print(getElecPowerData);
      ref.read(elecPowerProvider.notifier).updateAll(getElecPowerData);
    }
  }

  /// shared_preferencesの読込み
  void setSettingPref(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var setCableDesign = jsonEncode(ref.read(cableDesignProvider).toJson());
    print(setCableDesign);
    prefs.setString(SharedPrefEnum.calcCableDesign.name, setCableDesign);

    var setElecPower = jsonEncode(ref.read(elecPowerProvider).toJson());
    print(setElecPower);
    prefs.setString(SharedPrefEnum.calcPower.name, setElecPower);
  }
}

/// shared_pref用のenum
enum SharedPrefEnum {
  setting,
  calcCableDesign,
  calcPower,
  calcConduit,
  calcWiringList,
}

/// initiallize provider for setteings
final isDarkmodeProvider = StateProvider((ref) => true);
final bottomNaviSelectProvider = StateProvider((ref) => 0);
final settingProvider = StateProvider<SettingDataClass>((ref) {
  return SettingDataClass(
    isDarkMode: true,
  );
});
