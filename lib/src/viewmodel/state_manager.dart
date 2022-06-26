import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elec_facility_calc/main.dart';

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
}
