import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elec_facility_calc/main.dart';

class StateManagerClass {
  /// shared_preferenceで保存するためのMap
  final sharedPrefMapProvider = StateProvider((ref) => {
        /// shared_preferenceでケーブル設計を保存するためのMap
        // 'cable design phase': ref.watch(cableDesignPhaseProvider),
        // 'cable design type': ref.watch(cableDesignCableTypeProvider),
        // 'cable design elec out': ref.watch(cableDesignElecOutProvider).text,
        // 'cable design cosfai': ref.watch(cableDesignCosFaiProvider).text,
        // 'cable design volt': ref.watch(cableDesignVoltProvider).text,
        // 'cable design cable length':
        //     ref.watch(cableDesignCableLenProvider).text,
        // 'cable design current': ref.watch(cableDesignCurrentProvider),
        // 'cable design cable size': ref.watch(cableDesignCableSizeProvider),
        // 'cable design volt drop': ref.watch(cableDesignVoltDropProvider),
        // 'cable design power loss': ref.watch(cableDesignPowerLossProvider),

        /// shared_preferenceで電線管設計を保存するためのMap
        // 'conduit list': ref.watch(conduitListItemProvider),
        // 'conduit cable size list': ref.watch(conduitCableSizeListProvider),
        // 'conduit select cable type': ref.watch(conduitConduitTypeProvider),
        // 'conduit select cable size32': ref.watch(conduitConduitSize32Provider),
        // 'conduit select cable size48': ref.watch(conduitConduitSize48Provider),

        /// shared_preferenceで電力計算を保存するためのMap
        // 'elec power phase': ref.watch(elecPowerPhaseProvider),
        // 'elec power volt': ref.watch(elecPowerVoltProvider).text,
        // 'elec power current': ref.watch(elecPowerCurrentProvider).text,
        // 'elec power cosfai': ref.watch(elecPowerCosFaiProvider).text,
        // 'elec power apparent power': ref.watch(elecPowerApparentPowerProvider),
        // 'elec power active power': ref.watch(elecPowerActivePowerProvider),
        // 'elec power reactive power': ref.watch(elecPowerReactivePowerProvider),
        // 'elec power sinfai': ref.watch(elecPowerSinFaiProvider),
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
    var getData = prefs.getString('CulcData') ?? '';
    if (getData != '') {
      var getDataMap = json.decode(getData);

      /// ケーブル設計
      // ref.watch(cableDesignPhaseProvider.state).state =
      //     getDataMap['cable design phase'];
      // ref.watch(cableDesignCableTypeProvider.state).state =
      //     getDataMap['cable design type'];
      // cableDesignElecOutProvider = StateProvider((ref) {
      //   return TextEditingController(text: getDataMap['cable design elec out']);
      // });
      // cableDesignCosFaiProvider = StateProvider((ref) {
      //   return TextEditingController(text: getDataMap['cable design cosfai']);
      // });
      // cableDesignVoltProvider = StateProvider((ref) {
      //   return TextEditingController(text: getDataMap['cable design volt']);
      // });
      // cableDesignCableLenProvider = StateProvider((ref) {
      //   return TextEditingController(
      //       text: getDataMap['cable design cable length']);
      // });
      // ref.watch(cableDesignCurrentProvider.state).state =
      //     getDataMap['cable design current'];
      // ref.watch(cableDesignCableSizeProvider.state).state =
      //     getDataMap['cable design cable size'];
      // ref.watch(cableDesignVoltDropProvider.state).state =
      //     getDataMap['cable design volt drop'];
      // ref.watch(cableDesignPowerLossProvider.state).state =
      //     getDataMap['cable design power loss'];

      /// 電線管設計
      // ref.watch(conduitListItemProvider.state).state =
      //     getDataMap['conduit list'];
      // ref.watch(conduitCableSizeListProvider.state).state =
      //     getDataMap['conduit cable size list'];
      // ref.watch(conduitConduitTypeProvider.state).state =
      //     getDataMap['conduit select cable type'];
      // ref.watch(conduitConduitSize32Provider.state).state =
      //     getDataMap['conduit select cable size32'];
      // ref.watch(conduitConduitSize48Provider.state).state =
      //     getDataMap['conduit select cable size48'];

      /// 電力計算
      // ref.watch(elecPowerPhaseProvider.state).state =
      //     getDataMap['elec power phase'];
      // elecPowerVoltProvider = StateProvider((ref) {
      //   return TextEditingController(text: getDataMap['elec power volt']);
      // });
      // elecPowerCurrentProvider = StateProvider((ref) {
      //   return TextEditingController(text: getDataMap['elec power current']);
      // });
      // elecPowerCosFaiProvider = StateProvider((ref) {
      //   return TextEditingController(text: getDataMap['elec power cosfai']);
      // });
      // ref.watch(elecPowerApparentPowerProvider.state).state =
      //     getDataMap['elec power apparent power'];
      // ref.watch(elecPowerActivePowerProvider.state).state =
      //     getDataMap['elec power active power'];
      // ref.watch(elecPowerReactivePowerProvider.state).state =
      //     getDataMap['elec power reactive power'];
      // ref.watch(elecPowerSinFaiProvider.state).state =
      //     getDataMap['elec power sinfai'];
    }
  }

  /// 計算結果をshared_preferencesに書き込み
  void setCalcData(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var setData = json.encode(ref.read(sharedPrefMapProvider));
    prefs.setString('CulcData', setData);
  }

  /// 以前の計算データをshared_preferencesから削除
  void removeCalcData(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// 設定
    prefs.remove('CulcData');
    ref.read(sharedPrefMapProvider).clear();

    /// ケーブル設計
    // ref.read(cableDesignCurrentProvider.state).state = '0';
    // ref.read(cableDesignCableSizeProvider.state).state = '0';
    // ref.read(cableDesignVoltDropProvider.state).state = '0';
    // ref.read(cableDesignPowerLossProvider.state).state = '0';

    /// 電線管設計
    // ref.read(conduitListItemProvider.state).state = [];
    // ref.read(conduitCableSizeListProvider.state).state = [];
    // ref.read(conduitConduitTypeProvider.state).state = 'PF管';
    // ref.read(conduitConduitSize32Provider.state).state = '';
    // ref.read(conduitConduitSize48Provider.state).state = '';

    /// 電力計算
    // ref.read(elecPowerApparentPowerProvider.state).state = '0';
    // ref.read(elecPowerActivePowerProvider.state).state = '0';
    // ref.read(elecPowerReactivePowerProvider.state).state = '0';
    // ref.read(elecPowerSinFaiProvider.state).state = '0';
  }
}
