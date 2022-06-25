import 'dart:convert';
import 'dart:math';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/data/conduit_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';

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

/// ケーブル設計入力のProviderの定義
final cableDesignProvider =
    StateNotifierProvider<CableDesignNotifier, CableDesignData>((ref) {
  return CableDesignNotifier();
});

/// ケーブル設計のNotifierの定義
class CableDesignNotifier extends StateNotifier<CableDesignData> {
  // 空のデータとして初期化
  CableDesignNotifier()
      : super(CableDesignData(
          phase: '単相',
          cableType: '600V CV-2C',
          elecOut: TextEditingController(text: '1500'),
          volt: TextEditingController(text: '200'),
          cosFai: TextEditingController(text: '80'),
          cableLength: TextEditingController(text: '10'),
          current: '0',
          cableSize: '0',
          voltDrop: '0',
          powerLoss: '0',
        ));

  /// 相の変更
  void updatePhase(String phase) {
    state = state.copyWith(phase: phase);
  }

  /// ケーブル種類の変更
  void updateCableType(String cableType) {
    state = state.copyWith(cableType: cableType);
  }

  /// 電流の変更
  double updateCurrent(
      String phase, double elecOut, double volt, double cosFai) {
    double current = 0;

    /// 相ごとの計算
    if ((phase == '単相') && (cosFai <= 1)) {
      // 単相の電流計算と計算係数設定
      current = elecOut / (volt * cosFai);
    } else if ((phase == '三相') && (cosFai <= 1)) {
      // 三相の電流計算と計算係数設定
      current = elecOut / (sqrt(3) * volt * cosFai);
    }

    /// 小数点2桁以下を四捨五入してString型に
    String strCurrent = current.toStringAsFixed(1);

    /// 書込み
    state = state.copyWith(current: strCurrent);

    return current;
  }

  /// ケーブルサイズの変更
  Map updateCableSize(double current) {
    /// 計算用変数初期化
    double rVal = 0;
    double xVal = 0;
    String cableType = state.cableType;

    /// ケーブル種類からデータを取得
    /// ケーブルのインピーダンスと許容電流のマップデータ
    Map<String, CableDataClass> cableDataMap =
        CableData().selectCableData(cableType);

    /// ケーブル許容電流からケーブルの太さを選定
    /// 許容電流を満たすケーブルサイズをリストに追加
    List cableAnswerList = [];
    cableDataMap.forEach((key, value) {
      if (value.current >= current) {
        cableAnswerList
            .add([key, value.rVal, value.xVal]); // [ケーブルサイズ, 抵抗, リアクタンス]
      }
    });

    /// 許容電流が満たせない場合は'規格なし'を返す。
    String cableSize = '';
    if (cableAnswerList.isEmpty) {
      cableSize = '規格なし';
      rVal = xVal = 0;
    } else {
      cableSize = cableAnswerList[0][0];
      rVal = cableAnswerList[0][1];
      xVal = cableAnswerList[0][2];
    }

    /// 書込み
    state = state.copyWith(cableSize: cableSize);

    return {'cableSize': cableSize, 'rVal': rVal, 'xVal': xVal};
  }

  /// 電圧降下の変更
  void updateVoltDrop(
    String phase,
    double current,
    double cableLength,
    double rVal,
    double xVal,
    double cosFai,
    double sinFai,
  ) {
    /// 電圧降下計算の係数
    double kVal = 1;

    /// 相ごとの電圧降下計算の係数設定
    if (phase == '単相') {
      kVal = 2;
    } else if (phase == '三相') {
      kVal = sqrt(3);
    }

    /// 電圧降下の計算
    double dVoltDrop =
        kVal * current * cableLength * (rVal * cosFai + xVal * sinFai);

    /// 小数点2桁以下を四捨五入してString型に
    String strVoltDrop = dVoltDrop.toStringAsFixed(1);

    /// 書込み
    state = state.copyWith(voltDrop: strVoltDrop);
  }

  /// 電力損失の変更
  void updatePowerLoss(
    String phase,
    double current,
    double rVal,
    double cableLength,
  ) {
    /// 電力損失計算の係数
    double kVal = 2;

    /// 相ごとの電力損失計算の係数設定
    if (phase == '単相') {
      kVal = 2;
    } else if (phase == '三相') {
      kVal = 3;
    }

    /// 電力損失計算
    double dPowLoss = kVal * rVal * current * current * cableLength;

    /// 小数点2桁以下を四捨五入してString型に
    String strPowLoss = dPowLoss.toStringAsFixed(1);

    /// 書込み
    state = state.copyWith(powerLoss: strPowLoss);
  }

  /// 計算実行
  void run() {
    /// Textfieldのテキストを取得し、doubleに変換
    String phase = state.phase;
    double elecOut = double.parse(state.elecOut.text);
    double cosFai = double.parse(state.cosFai.text) / 100;
    double volt = double.parse(state.volt.text);
    double cableLength = double.parse(state.cableLength.text) / 1000;

    /// cosφからsinφを算出
    double sinFai = sqrt(1 - pow(cosFai, 2));

    /// 電流値の計算
    double current = updateCurrent(phase, elecOut, volt, cosFai);

    /// ケーブルサイズ計算
    Map temp = updateCableSize(current);
    double rVal = temp['rVal'];
    double xVal = temp['xVal'];

    /// ケーブル電圧降下計算
    updateVoltDrop(phase, current, cableLength, rVal, xVal, cosFai, sinFai);

    /// ケーブル電力損失計算
    updatePowerLoss(phase, current, rVal, cableLength);
  }

  /// runメソッドが実行できるか確認するメソッド
  bool isRunCheck() {
    try {
      /// 数値に変換できるか確認
      double elecOut = double.parse(state.elecOut.text);
      double cosFai = double.parse(state.cosFai.text);
      double volt = double.parse(state.volt.text);
      double cableLength = double.parse(state.cableLength.text);

      /// 力率が0-100%以外ならfalseを返す
      if (cosFai < 0 || cosFai > 100) {
        return false;
      }

      /// 入力した数値を整形してTextEditingControllerに入れる
      state = state.copyWith(
        elecOut: TextEditingController(text: elecOut.toString()),
      );
      state = state.copyWith(
        volt: TextEditingController(text: volt.toString()),
      );
      state = state.copyWith(
        cosFai: TextEditingController(text: cosFai.toString()),
      );
      state = state.copyWith(
        cableLength: TextEditingController(text: cableLength.toString()),
      );
    } catch (e) {
      /// 数値変換や整形に失敗した場合、falseを返す
      return false;
    }

    /// すべてクリアだった場合trueを返す
    return true;
  }
}

/// 電力計算のProviderの定義
final elecPowerProvider =
    StateNotifierProvider<ElecPowerNotifier, ElecPowerData>((ref) {
  return ElecPowerNotifier();
});

/// StateNotifierの中身を定義
class ElecPowerNotifier extends StateNotifier<ElecPowerData> {
  // 空のマップとして初期化
  ElecPowerNotifier()
      : super(
          ElecPowerData(
            phase: '単相',
            volt: TextEditingController(text: '100'),
            current: TextEditingController(text: '10'),
            cosFai: TextEditingController(text: '80'),
            apparentPower: '0',
            activePower: '0',
            reactivePower: '0',
            sinFai: '0',
          ),
        );

  /// 相の変更
  void updatePhase(String phase) {
    state = state.copyWith(phase: phase);
  }

  /// 皮相電力の変更
  double updateApparentPower(String phase, double volt, double current) {
    double appaPower = 0;
    if (phase == '単相') {
      /// 単相電力計算
      appaPower = volt * current;
    } else if (phase == '三相') {
      /// 3相電力計算
      appaPower = sqrt(3) * volt * current;
    }

    /// 小数点2桁以下を四捨五入してString型に
    String strAppaPow = (appaPower / 1000).toStringAsFixed(2);

    /// 書込み
    state = state.copyWith(apparentPower: strAppaPow);
    return appaPower;
  }

  /// 有効電力の変更
  void updateActivePower(double appaPower, double cosFai) {
    /// 計算
    double actPower = appaPower * cosFai;

    /// 小数点2桁以下を四捨五入してString型に
    String strActPower = (actPower / 1000).toStringAsFixed(2);

    /// 書込み
    state = state.copyWith(activePower: strActPower);
  }

  /// 無効電力の変更
  void updateReactivePower(double appaPower, double sinFai) {
    /// 計算
    double reactPower = appaPower * sinFai;

    /// 小数点2桁以下を四捨五入してString型に
    String strReactPower = (reactPower / 1000).toStringAsFixed(2);

    /// 書込み
    state = state.copyWith(reactivePower: strReactPower);
  }

  /// sinφの変更
  double updateSinFai(double cosFai) {
    /// cosφからsinφを算出
    double sinFai = sqrt(1 - pow(cosFai, 2));

    /// 小数点1桁以下を四捨五入してString型に
    String strSinFai = (sinFai * 100).toStringAsFixed(1);

    /// sinφを書込み
    state = state.copyWith(sinFai: strSinFai);

    return sinFai;
  }

  /// 計算実行
  void run() {
    /// Textfieldのテキストから取得し、電圧、電流、力率double型へ変換
    String phase = state.phase;
    double volt = double.parse(state.volt.text);
    double current = double.parse(state.current.text);
    double cosFai = double.parse(state.cosFai.text) / 100;

    /// 皮相電力を計算
    double appaPower = updateApparentPower(phase, volt, current);

    /// sinφを計算
    double sinFai = updateSinFai(cosFai);

    /// 有効電力の計算
    updateActivePower(appaPower, cosFai);

    /// 無効電力の計算
    updateReactivePower(appaPower, sinFai);
  }

  /// runメソッドが実行できるか確認するメソッド
  bool isRunCheck() {
    try {
      /// 数値に変換できるか確認
      double volt = double.parse(state.volt.text);
      double current = double.parse(state.current.text);
      double cosFai = double.parse(state.cosFai.text);

      /// 力率が0-100%以外ならfalseを返す
      if (cosFai < 0 || cosFai > 100) {
        return false;
      }

      /// 入力した数値を整形してTextEditingControllerに入れる
      state = state.copyWith(
        volt: TextEditingController(text: volt.toString()),
      );
      state = state.copyWith(
        current: TextEditingController(text: current.toString()),
      );
      state = state.copyWith(
        cosFai: TextEditingController(text: cosFai.toString()),
      );
    } catch (e) {
      /// 数値変換や整形に失敗した場合、falseを返す
      return false;
    }

    /// すべてクリアだった場合trueを返す
    return true;
  }
}

/// 電線管設計のProviderの定義
final conduitCalcProvider =
    StateNotifierProvider<ConduitCalcNotifier, ConduitCalcDataClass>((ref) {
  return ConduitCalcNotifier();
});

/// StateNotifierの中身を定義
class ConduitCalcNotifier extends StateNotifier<ConduitCalcDataClass> {
  // 空のデータとして初期化
  ConduitCalcNotifier()
      : super(
          const ConduitCalcDataClass(
            items: <ConduitCalcCableDataClass>[],
            conduitType: 'PF管',
          ),
        );

  /// ケーブル面積の計算
  double calcCableArea() {
    /// ケーブルのリストを抜き出す
    final cableItems = [...state.items];

    /// ケーブルの種類と半径を抜き出し、それぞれのケーブル断面積を計算
    /// このとき、CVTケーブルなら面積を3倍にする
    /// reduce計算でケーブルの面積の合計を計算
    /// cableItemに何も入っていない場合エラーになるので強制的に0を入力
    double cableArea;
    if (cableItems.isEmpty) {
      cableArea = 0;
    } else {
      cableArea = cableItems
          .map((e) => e.cableType == '600V CVT'
              ? 3 * pow(e.cableRadius / 2, 2) * pi
              : pow(e.cableRadius / 2, 2) * pi)
          .reduce((value, element) => value + element);
    }

    return cableArea;
  }

  /// ケーブルのサイズリストを返す
  List cableSizeList(int index) {
    /// ケーブルの種類を取得
    String cableType = [...state.items][index].cableType;

    /// ケーブルのデータを取得
    Map<String, CableDataClass> cableData =
        CableData().selectCableData(cableType);

    /// ケーブルサイズのリストを取得
    List cableSizeList = cableData.keys.toList();

    return cableSizeList;
  }

  /// ケーブルの追加
  void addCable() {
    /// ケーブル種類、サイズ、仕上外径を追加
    /// 追加は固定で、600V CV-2C 2sq
    final cableData = ConduitCalcCableDataClass(
      cableType: '600V CV-2C',
      cableSize: '2',
      cableRadius: 10.5,
    );

    /// 値を追加
    var temp = [...state.items];
    temp.add(cableData);
    state = state.copyWith(items: temp);
  }

  /// ケーブルサイズの更新
  void updateCableSize(int index, String newCableSize) {
    /// ケーブルの種類を取得
    String cableType = state.items[index].cableType;

    /// ケーブルの種類からケーブルのデータを取得
    Map<String, CableDataClass> newCableData =
        CableData().selectCableData(cableType);

    /// ケーブルのデータからケーブルの外径を取得
    double newCableRadius = newCableData[newCableSize]!.diameter;

    /// ケーブルアイテムを更新
    var temp = [...state.items];
    temp[index] = ConduitCalcCableDataClass(
      cableType: cableType,
      cableSize: newCableSize,
      cableRadius: newCableRadius,
    );

    /// 書込み
    state = state.copyWith(items: temp);
  }

  /// ケーブル種類の更新
  void updateCableType(int index, String newCableType) {
    /// ケーブルの種類からケーブルのデータを取得
    Map<String, CableDataClass> newCableData =
        CableData().selectCableData(newCableType);

    /// ケーブルの種類からケーブルのデータを取得
    String newCableSize = newCableData.keys.first;

    /// ケーブルのデータからケーブルの外径を取得
    double newCableRadius = newCableData[newCableSize]!.diameter;

    /// ケーブルアイテムを更新
    var temp = [...state.items];
    temp[index] = ConduitCalcCableDataClass(
      cableType: newCableType,
      cableSize: newCableSize,
      cableRadius: newCableRadius,
    );

    /// 書込み
    state = state.copyWith(items: temp);
  }

  /// ケーブル種類の更新
  void updateConduitType(String newConduitType) {
    /// 書込み
    state = state.copyWith(conduitType: newConduitType);
  }

  /// ケーブルカードの削除
  void removeCable(int index) {
    /// itemsの取得
    var temp = [...state.items];

    /// 削除
    temp.removeAt(index);

    /// 書込み
    state = state.copyWith(items: temp);
  }
}

/// 32%占有率の計算
final conduitOccupancy32Provider = StateProvider<String>((ref) {
  /// ケーブル断面積の計算
  final cableArea = ref.watch(conduitCalcProvider.notifier).calcCableArea();

  /// 電線管の直径を抽出
  Map conduitRadiusMap = ConduitData()
      .selectConduitData(ref.watch(conduitCalcProvider).conduitType);

  /// 電線管の直径のListから電線管の断面積を計算と比較
  List conduitAreaList = [];
  double conduitArea;
  conduitRadiusMap.forEach((key, value) {
    conduitArea = pow(value / 2, 2) * pi;
    if (cableArea < conduitArea * 0.32) {
      conduitAreaList.add(key);
    }
  });

  /// emptyなら'規格なし'を返す
  return conduitAreaList.isEmpty ? '規格なし' : conduitAreaList[0];
});

/// 48%占有率の計算
final conduitOccupancy48Provider = StateProvider<String>((ref) {
  /// ケーブル断面積の計算
  final cableArea = ref.watch(conduitCalcProvider.notifier).calcCableArea();

  /// 電線管の直径を抽出
  Map conduitRadiusMap = ConduitData()
      .selectConduitData(ref.watch(conduitCalcProvider).conduitType);

  /// 電線管の直径のListから電線管の断面積を計算と比較
  List conduitAreaList = [];
  double conduitArea;
  conduitRadiusMap.forEach((key, value) {
    conduitArea = pow(value / 2, 2) * pi;
    if (cableArea < conduitArea * 0.48) {
      conduitAreaList.add(key);
    }
  });

  /// emptyなら'規格なし'を返す
  return conduitAreaList.isEmpty ? '規格なし' : conduitAreaList[0];
});

/// ケーブル設計入力のProviderの定義
final wiringListProvider =
    StateNotifierProvider<WiringListNotifier, Map<String, WiringListDataClass>>(
        (ref) {
  return WiringListNotifier();
});

/// ケーブル設計のNotifierの定義
class WiringListNotifier
    extends StateNotifier<Map<String, WiringListDataClass>> {
  // 空のデータとして初期化
  WiringListNotifier() : super({});

  /// データの更新
  void update(
    String id,
    String name,
    String cableType,
    String startPoint,
    String endPoint,
    String remarks,
  ) {
    /// データクラスに入れる
    WiringListDataClass data = WiringListDataClass(
      name: name,
      cableType: cableType,
      startPoint: startPoint,
      endPoint: endPoint,
      remarks: remarks,
    );

    /// 新規追加または変更
    Map temp = state;
    temp[id] = data;
    state = {...temp};
  }

  /// 削除
  void remove(String id) {
    /// 新規追加または変更
    Map temp = state;
    temp.remove(id);
    state = {...temp};
  }
}

/// WiringListページ間の設定クラスのProvider初期化
final wiringListSettingProvider = StateProvider((ref) {
  return WiringListSettingDataClass(
    isCreate: true,
    id: '',
    nameController: TextEditingController(text: ''),
    cableType: CableData().cableTypeList.first,
    startPointController: TextEditingController(text: ''),
    endPointController: TextEditingController(text: ''),
    remarksController: TextEditingController(text: ''),
  );
});

/// WiringListページクラスのProvider初期化
final wiringListShowProvider = StateProvider((ref) {
  /// オリジナルのMap
  final originalMap = ref.watch(wiringListProvider);

  /// 検索単語
  final cableType = ref.watch(wiringListSearchCableTypeProvider);
  final startPoint = ref.watch(wiringListSearchStartProvider);
  final endPoint = ref.watch(wiringListSearchEndProvider);

  /// mapの初期化
  Map cableTypeMap = {};
  Map startMap = {};

  /// ケーブル種類の選別
  if (cableType == WiringListSearchEnum.cableData.name) {
    cableTypeMap = originalMap;
  } else {
    originalMap.forEach((key, value) {
      if (cableType == value.cableType) {
        cableTypeMap[key] = value;
      }
    });
  }

  /// 出発点の選別
  if (startPoint == WiringListSearchEnum.start.name) {
    startMap = cableTypeMap;
  } else {
    cableTypeMap.forEach((key, value) {
      if (startPoint == value.cableType) {
        startMap[key] = value;
      }
    });
  }

  print(startMap);
  return startMap;
});

/// WiringListページの検索のProvider初期化
final wiringListSearchCableTypeProvider = StateProvider((ref) {
  return WiringListSearchEnum.cableData.name;
});

/// ケーブル種類絞り込み用リスト
final wiringListSearchCableTypeListProvider = StateProvider((ref) {
  final originalMap = ref.watch(wiringListShowProvider);
  // final originalMap = ref.watch(wiringListProvider);

  List<String> cableTypeList = [WiringListSearchEnum.cableData.name];
  originalMap.forEach((key, value) {
    if (!cableTypeList.contains(value.cableType)) {
      cableTypeList.add(value.cableType);
    }
  });

  return cableTypeList;
});

/// WiringListページの検索のProvider初期化
final wiringListSearchStartProvider = StateProvider((ref) {
  return WiringListSearchEnum.start.name;
});

/// ケーブル種類絞り込み用リスト
final wiringListSearchStartListProvider = StateProvider((ref) {
  final originalMap = ref.watch(wiringListShowProvider);
  // final originalMap = ref.watch(wiringListProvider);

  List<String> startList = [WiringListSearchEnum.start.name];
  originalMap.forEach((key, value) {
    if (!startList.contains(value.startPoint)) {
      startList.add(value.startPoint);
    }
  });

  return startList;
});

/// WiringListページの検索のProvider初期化
final wiringListSearchEndProvider = StateProvider((ref) {
  return WiringListSearchEnum.end.name;
});

/// ケーブル種類絞り込み用リスト
final wiringListSearchEndListProvider = StateProvider((ref) {
  final originalMap = ref.watch(wiringListShowProvider);
  // final originalMap = ref.watch(wiringListProvider);

  List<String> endList = [WiringListSearchEnum.end.name];
  originalMap.forEach((key, value) {
    if (!endList.contains(value.endPoint)) {
      endList.add(value.endPoint);
    }
  });

  return endList;
});
