import 'dart:convert';
import 'package:elec_facility_calc/src/model/cable_design_data_model.dart';
import 'package:elec_facility_calc/src/model/conduit_calc_data_model.dart';
import 'package:elec_facility_calc/src/model/elec_power_data_model.dart';
import 'package:elec_facility_calc/src/model/elec_rate_data_model.dart';
import 'package:elec_facility_calc/src/model/setting_data_model.dart';
import 'package:elec_facility_calc/src/model/wiring_list_data_model.dart';
import 'package:elec_facility_calc/src/notifiers/calc_cable_design_state.dart';
import 'package:elec_facility_calc/src/notifiers/calc_conduit_state.dart';
import 'package:elec_facility_calc/src/notifiers/calc_elec_power_state.dart';
import 'package:elec_facility_calc/src/notifiers/calc_elec_rate_state.dart';
import 'package:elec_facility_calc/src/notifiers/wiring_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// shared_pref用のenum
enum SharedPrefEnum {
  calcCableDesign,
  calcPower,
  calcConduit,
  calcRate,
  calcWiringList,
  setting,
}

/// shared_preferencesのデータ読み込みや削除を行うクラス
class StateManagerClass {
  /// 以前の計算データをshared_preferencesから削除
  void removeCalc(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// キャッシュ削除
    prefs.remove(SharedPrefEnum.calcCableDesign.name);
    prefs.remove(SharedPrefEnum.calcPower.name);
    prefs.remove(SharedPrefEnum.calcRate.name);

    /// providerの中身を削除
    ref.read(cableDesignProvider.notifier).removeAll();
    ref.read(elecPowerProvider.notifier).removeAll();
    ref.read(elecRateProvider.notifier).removeAll();
  }

  /// 以前の電線管設計データをshared_preferencesから削除
  void removeConduitCalc(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// キャッシュ削除
    prefs.remove(SharedPrefEnum.calcConduit.name);

    /// providerの中身を削除
    ref.read(conduitCalcProvider.notifier).removeAll();
  }

  /// 以前の配線管理データをshared_preferencesから削除
  void removeWiringList(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// キャッシュ削除
    prefs.remove(SharedPrefEnum.calcWiringList.name);

    /// providerの中身を削除
    ref.read(wiringListProvider.notifier).removeAll();
  }

  /// shared_preferencesの読込み
  void getPrefs(WidgetRef ref) async {
    /// 初期化
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// データ読み込み
    var getCableDesign = prefs.getString(SharedPrefEnum.calcCableDesign.name);
    var getElecPower = prefs.getString(SharedPrefEnum.calcPower.name);
    var getConduit = prefs.getString(SharedPrefEnum.calcConduit.name);
    var getElecRate = prefs.getString(SharedPrefEnum.calcRate.name);
    var getWiringList = prefs.getString(SharedPrefEnum.calcWiringList.name);
    var getSetting = prefs.getString(SharedPrefEnum.setting.name);

    /// ケーブル設計
    /// データがない場合はnullになるので、null以外の場合でデコードする
    /// また、データクラスの変更があった場合は読み込みエラーになるので、回避
    try {
      /// jsonをデコード
      var getCableDesignData =
          CableDesignData.fromJson(jsonDecode(getCableDesign!));

      /// 値をproviderへ
      ref.read(cableDesignProvider.notifier).updateAll(getCableDesignData);
    } catch (e) {
      // print(e);
    }

    /// 電力計算
    /// データがない場合、nullになるので、null以外の場合でデコードする
    /// また、データクラスの変更があった場合は読み込みエラーになるので、回避
    try {
      var getElecPowerData = ElecPowerData.fromJson(jsonDecode(getElecPower!));

      /// 値をproviderへ
      ref.read(elecPowerProvider.notifier).updateAll(getElecPowerData);
    } catch (e) {
      // print(e);
    }

    /// 電線管設計
    /// データがない場合、nullになるので、null以外の場合でデコードする
    /// また、データクラスの変更があった場合は読み込みエラーになるので、回避
    try {
      Map getConduitJson = jsonDecode(getConduit!);
      List<ConduitCalcDataClass> conduitData = [];
      getConduitJson.forEach((key, value) {
        conduitData.add(ConduitCalcDataClass.fromJson(value));
      });

      /// 値をproviderへ
      ref.read(conduitCalcProvider.notifier).updateAll(conduitData);
    } catch (e) {
      // print(e);
    }

    /// 需要率計算
    /// データがない場合、nullになるので、null以外の場合でデコードする
    /// また、データクラスの変更があった場合は読み込みエラーになるので、回避
    try {
      var getElecRateData = ElecRateData.fromJson(jsonDecode(getElecRate!));

      /// 値をproviderへ
      ref.read(elecRateProvider.notifier).updateAll(getElecRateData);
    } catch (e) {
      // print(e);
    }

    /// 配線リスト
    /// データがない場合、nullになるので、null以外の場合でデコードする
    /// また、データクラスの変更があった場合は読み込みエラーになるので、回避
    try {
      Map getWiringListJson = jsonDecode(getWiringList!);
      Map<String, WiringListDataClass> wiringListData = {};
      getWiringListJson.forEach((key, value) {
        wiringListData[key] = WiringListDataClass.fromJson(value);
      });

      /// 値をproviderへ
      ref.read(wiringListProvider.notifier).updateAll(wiringListData);
    } catch (e) {
      // print(e);
    }

    /// 設定
    /// データがない場合、nullになるので、null以外の場合でデコードする
    /// また、データクラスの変更があった場合は読み込みエラーになるので、回避
    try {
      var getSettingData = SettingDataClass.fromJson(jsonDecode(getSetting!));

      /// 値をproviderへ
      ref
          .read(settingProvider.notifier)
          .updateDarkMode(getSettingData.darkMode);
    } catch (e) {
      // print(e);
    }
  }
}

/// 設定のProviderの定義
final settingProvider =
    StateNotifierProvider<SettingProviderNotifier, SettingDataClass>((ref) {
  return SettingProviderNotifier();
});

/// 設定のStateNotifierを定義
class SettingProviderNotifier extends StateNotifier<SettingDataClass> {
  // 空のデータとして初期化
  SettingProviderNotifier() : super(const SettingDataClass(darkMode: false));

  void updateDarkMode(bool value) {
    state = state.copyWith(darkMode: value);
  }
}

/// shared_prefでケーブル設計データを非同期で保存するprovider
final cableDesignSPSetProvider = FutureProvider((ref) async {
  /// 初期化
  SharedPreferences prefs = await SharedPreferences.getInstance();

  ///  データの整形
  var setCableDesign = jsonEncode(ref.watch(cableDesignProvider).toJson());

  ///  書込み
  prefs.setString(SharedPrefEnum.calcCableDesign.name, setCableDesign);
});

/// shared_prefで電力計算データを非同期で保存するprovider
final elecPowerSPSetProvider = FutureProvider((ref) async {
  /// 初期化
  SharedPreferences prefs = await SharedPreferences.getInstance();

  ///  データの整形
  var setElecPower = jsonEncode(ref.watch(elecPowerProvider).toJson());

  ///  書込み
  prefs.setString(SharedPrefEnum.calcPower.name, setElecPower);
});

/// shared_prefで電線管設計データを非同期で保存するprovider
final conduitSPSetProvider = FutureProvider((ref) async {
  /// 初期化
  SharedPreferences prefs = await SharedPreferences.getInstance();

  ///  データの読み込みと定義
  var conduitList = ref.watch(conduitCalcProvider);
  var conduitJsonCounter = 0;
  var conduitJsonMap = {};

  /// 各要素のデータに対してMapに変換し格納
  for (var element in conduitList) {
    conduitJsonMap[conduitJsonCounter.toString()] = element.toJson();
    conduitJsonCounter++;
  }

  /// json形式に変換
  var setConduit = jsonEncode(conduitJsonMap);

  ///  書込み
  prefs.setString(SharedPrefEnum.calcConduit.name, setConduit);
});

/// shared_prefで需要率計算データを非同期で保存するprovider
final elecRateSPSetProvider = FutureProvider((ref) async {
  /// 初期化
  SharedPreferences prefs = await SharedPreferences.getInstance();

  ///  データの整形
  var setElecRate = jsonEncode(ref.watch(elecRateProvider).toJson());

  ///  書込み
  prefs.setString(SharedPrefEnum.calcRate.name, setElecRate);
});

/// shared_prefで配線リストデータを非同期で保存するprovider
final wiringListSPSetProvider = FutureProvider((ref) async {
  /// 初期化
  SharedPreferences prefs = await SharedPreferences.getInstance();

  /// データの読み込みと定義
  var wiringMap = ref.watch(wiringListProvider);
  var wiringJsonMap = {};

  ///  各要素のデータに対してMapに変換し格納
  wiringMap.forEach((key, value) {
    wiringJsonMap[key] = value.toJson();
  });

  /// json形式に変換
  var setWiringList = jsonEncode(wiringJsonMap);

  ///  書込み
  prefs.setString(SharedPrefEnum.calcWiringList.name, setWiringList);
});

/// shared_prefで設定データを非同期で保存するprovider
final settingSPSetProvider = FutureProvider((ref) async {
  /// 初期化
  SharedPreferences prefs = await SharedPreferences.getInstance();

  ///  データの整形
  var setSetting = jsonEncode(ref.watch(settingProvider).toJson());

  ///  書込み
  prefs.setString(SharedPrefEnum.setting.name, setSetting);
});
