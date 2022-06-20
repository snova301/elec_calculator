import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elec_facility_calc/main.dart';
import 'package:elec_facility_calc/src/model/cable_conduit_data_class.dart';
import 'package:elec_facility_calc/src/viewmodel/state_manager.dart';

/// 各計算のロジック部分
/// view側とは基本的にproviderで受け渡し
class CalcLogic {
  /// WidgetRefは必須
  WidgetRef ref;
  CalcLogic(
    this.ref,
  );

  /// 力率が0-100%の中に入っているか判定。
  /// 入っていたらtrue, 入っていなかったらfalseを返す。
  bool isCosFaiCorrect(String strCosFai) {
    double dCosFai = double.parse(strCosFai);
    return (dCosFai >= 0 && dCosFai <= 100) ? true : false;
  }

  /// 実行ボタンを押したときの対応
  void selectButtonRun() {
    if (ref.read(bottomNaviSelectProvider) == 0) {
      CalcLogic(ref).cableDesignCalcRun();
    } else if (ref.read(bottomNaviSelectProvider) == 1) {
      CalcLogic(ref).elecPowerCalcRun();
    }
  }

  /// ケーブル設計のロジック部分
  void cableDesignCalcRun() {
    // 計算用変数初期化
    double dCurrentVal = 0;
    double dRVal = 0;
    double dXVal = 0;
    double dK1Val = 1; // 電圧降下計算の係数
    double dK2Val = 2; // 電力損失計算の係数
    Map cableData = {}; // ケーブルのインピーダンスと許容電流のマップデータ

    // Textfieldのテキスト取り出し
    // String strElecOut = ref.read(cableDesignElecOutProvider).text;
    // String strCosFai = ref.read(cableDesignCosFaiProvider).text;
    // String strVolt = ref.read(cableDesignVoltProvider).text;
    // String strLen = ref.read(cableDesignCableLenProvider).text;
    String strElecOut = ref.read(cableDesignInProvider).elecOut.text;
    String strCosFai = ref.read(cableDesignInProvider).cosfai.text;
    String strVolt = ref.read(cableDesignInProvider).volt.text;
    String strLen = ref.read(cableDesignInProvider).cableLength.text;

    // string2double
    double dElecOut = double.parse(strElecOut);
    double dCosFai = double.parse(strCosFai) / 100;
    double dVolt = double.parse(strVolt);
    double dLen = double.parse(strLen) / 1000;

    // cosφからsinφを算出
    double dSinFai = sqrt(1 - pow(dCosFai, 2));

    // 相ごとの計算(単相)
    if ((ref.read(cableDesignPhaseProvider) == '単相') && (dCosFai <= 1)) {
      // 単相の電流計算と計算係数設定
      dCurrentVal = dElecOut / (dVolt * dCosFai);
      dK1Val = 1;
      dK2Val = 2;
    }
    // 相ごとの計算(三相)
    else if ((ref.read(cableDesignPhaseProvider) == '三相') && (dCosFai <= 1)) {
      // 三相の電流計算と計算係数設定
      dCurrentVal = dElecOut / (sqrt(3) * dVolt * dCosFai);
      dK1Val = sqrt(3);
      dK2Val = 3;
    }

    /// ケーブル種類からデータを取得
    cableData = CableConduitDataClass()
        .selectCableData(ref.read(cableDesignCableTypeProvider));

    /// ケーブル許容電流から600V CV-3Cケーブルの太さを選定
    /// 許容電流を満たすケーブルサイズをリストに追加
    List cableAnswerList = [];
    cableData.forEach((key, value) {
      if (value[2] >= dCurrentVal) {
        cableAnswerList.add([key, value[0], value[1]]); // [ケーブルサイズ, 抵抗, リアクタンス]
      }
    });

    /// 許容電流が満たせない場合は'規格なし'を返す。
    /// ケーブルサイズをproviderに書き込み
    String cableSize = '';
    if (cableAnswerList.isEmpty) {
      cableSize = '規格なし';
      dRVal = dXVal = 0;
    } else {
      cableSize = cableAnswerList[0][0];
      dRVal = cableAnswerList[0][1];
      dXVal = cableAnswerList[0][2];
    }
    ref.read(cableDesignCableSizeProvider.state).state = cableSize;

    // 電流値小数点の長さ固定して文字列に変換
    ref.read(cableDesignCurrentProvider.state).state =
        dCurrentVal.toStringAsFixed(1);

    // ケーブル電圧降下計算
    double dVoltDrop =
        dK1Val * dCurrentVal * dLen * (dRVal * dCosFai + dXVal * dSinFai);
    ref.read(cableDesignVoltDropProvider.state).state =
        dVoltDrop.toStringAsFixed(1);

    // ケーブル電力損失計算
    double dPowLoss = dK2Val * dRVal * dCurrentVal * dCurrentVal * dLen;
    ref.read(cableDesignPowerLossProvider.state).state =
        dPowLoss.toStringAsFixed(1);

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }

  /// 電線管設計でケーブルカードのケーブル種別を変更するメソッド。
  void conduitCardSelectType(int index, String? value) {
    /// ケーブル種類の変更
    ref.read(conduitListItemProvider.state).state[index]['type'] = value!;

    /// ケーブルサイズの変更
    Map cableData = CableConduitDataClass().selectCableData(value);
    ref.read(conduitListItemProvider.state).state[index]['size'] =
        cableData.keys.toList()[0].toString();

    /// ケーブル外径の変更
    ref.read(conduitListItemProvider.state).state[index]['radius'] =
        cableData.values.toList()[0][3];

    /// ケーブルサイズリストの更新
    ref.read(conduitCableSizeListProvider.state).state[index] =
        cableData.keys.toList();

    /// 各Listの更新
    ref.read(conduitListItemProvider.state).state = [
      ...ref.read(conduitListItemProvider)
    ];
    ref.read(conduitCableSizeListProvider.state).state = [
      ...ref.read(conduitCableSizeListProvider)
    ];

    /// 電線管設計実行
    conduitCalcRun();
  }

  /// 電線管設計でケーブルカードのケーブルサイズを変更するメソッド。
  void conduitCardSelectSize(int index, String? value) {
    /// ケーブルサイズの変更
    ref.read(conduitListItemProvider.state).state[index]['size'] = value;

    /// ケーブル外径の変更
    Map cableData = CableConduitDataClass().selectCableData(
        ref.read(conduitListItemProvider.state).state[index]['type']);
    ref.read(conduitListItemProvider.state).state[index]['radius'] =
        cableData[value][3];

    /// Listの更新
    ref.read(conduitListItemProvider.state).state = [
      ...ref.read(conduitListItemProvider)
    ];

    /// 電線管設計実行
    conduitCalcRun();
  }

  /// 電線管設計でケーブルカードのケーブルサイズを変更するメソッド。
  void conduitCableAddRun() {
    /// ケーブル種類とサイズを追加
    /// 追加は固定で、600V CV-2C 2sq
    ref
        .read(conduitListItemProvider)
        .add({'type': '600V CV-2C', 'size': '2', 'radius': 10.5});
    ref.read(conduitListItemProvider.state).state = [
      ...ref.read(conduitListItemProvider)
    ];

    /// ケーブル種類からデータを取得
    Map cableData = CableConduitDataClass().selectCableData('600V CV-2C');

    /// ケーブルサイズリストを変更
    ref.read(conduitCableSizeListProvider).add(cableData.keys.toList());
    ref.read(conduitCableSizeListProvider.state).state = [
      ...ref.read(conduitCableSizeListProvider)
    ];

    /// 電線管設計実行
    conduitCalcRun();
  }

  /// 電線管設計でケーブルカードを削除するメソッド
  void conduitCableRemove(index) {
    /// リストから削除
    ref.read(conduitListItemProvider).removeAt(index);
    ref.read(conduitListItemProvider.state).state = [
      ...ref.read(conduitListItemProvider)
    ];

    /// ケーブルサイズから削除
    ref.read(conduitCableSizeListProvider).removeAt(index);

    /// 電線管設計実行
    conduitCalcRun();

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }

  /// 電線管設計の電線管種類変更
  void conduitTypeChange(String? value) {
    ref.read(conduitConduitTypeProvider.state).state = value!;

    /// 電線管設計実行
    conduitCalcRun();
  }

  /// 電線管設計実行
  void conduitCalcRun() {
    // print(ref.read(conduitListItemProvider));

    /// conduitListItemProvider内の直径からケーブル面積を計算
    List cableAreaList = ref
        .watch(conduitListItemProvider)
        .map((e) => {'type': e['type'], 'area': pow(e['radius'] / 2, 2) * pi})
        .toList();

    /// CVTケーブルなら面積を3倍にし、ケーブルの直径のListからケーブル面積の合計を計算
    double cableArea = 0;
    for (var i in cableAreaList) {
      cableArea += i['type'] == '600V CVT' ? i['area'] * 3 : i['area'];
    }

    /// 電線管の直径を抽出
    Map conduitRadiusMap = CableConduitDataClass()
        .selectConduitData(ref.watch(conduitConduitTypeProvider));

    /// 電線管の直径のListから電線管の断面積を計算と比較
    List conduitArea32List = [];
    List conduitArea48List = [];
    double conduitArea;
    conduitRadiusMap.forEach((key, value) {
      conduitArea = pow(value / 2, 2) * pi;
      if (conduitArea * 0.32 > cableArea) {
        conduitArea32List.add(key);
      }
      if (conduitArea * 0.48 > cableArea) {
        conduitArea48List.add(key);
      }
    });

    /// conduitConduitSizeProviderの変更
    /// emptyなら'規格なし'を返す
    ref.read(conduitConduitSize32Provider.state).state =
        conduitArea32List.isNotEmpty ? conduitArea32List[0] : '規格なし';
    ref.read(conduitConduitSize48Provider.state).state =
        conduitArea48List.isNotEmpty ? conduitArea48List[0] : '規格なし';

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }

  /// 電力計算のロジック部分
  void elecPowerCalcRun() {
    // Textfieldのテキスト取り出し
    String strCalcVolt = ref.read(elecPowerVoltProvider).text;
    String strCalcCur = ref.read(elecPowerCurrentProvider).text;
    String strCalcCosFai = ref.read(elecPowerCosFaiProvider).text;

    // string2double
    double dCalcVolt = double.parse(strCalcVolt);
    double dCalcCur = double.parse(strCalcCur);
    double dCalcCosFai = double.parse(strCalcCosFai) / 100;
    double dCalcAppaPowVal = 0;

    // cosφからsinφを算出
    double dCalcSinFai = sqrt(1 - pow(dCalcCosFai, 2));

    if (ref.read(elecPowerPhaseProvider) == '単相') {
      // 単相電力計算
      dCalcAppaPowVal = dCalcVolt * dCalcCur;
    } else if (ref.read(elecPowerPhaseProvider) == '三相') {
      // 3相電力計算
      dCalcAppaPowVal = sqrt(3) * dCalcVolt * dCalcCur;
    }
    double dCalcActPowVal = dCalcAppaPowVal * dCalcCosFai;
    double dCalcReactPowVal = dCalcAppaPowVal * dCalcSinFai;

    // double2string
    ref.read(elecPowerApparentPowerProvider.state).state =
        (dCalcAppaPowVal / 1000).toStringAsFixed(2);
    ref.read(elecPowerActivePowerProvider.state).state =
        (dCalcActPowVal / 1000).toStringAsFixed(2);
    ref.read(elecPowerReactivePowerProvider.state).state =
        (dCalcReactPowVal / 1000).toStringAsFixed(2);
    ref.read(elecPowerSinFaiProvider.state).state =
        (dCalcSinFai * 100).toStringAsFixed(1);

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }
}
