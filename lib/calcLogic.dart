import 'dart:math';
import 'package:elec_facility_calc/stateManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cableConduitDataClass.dart';
import 'main.dart';

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
  bool isCosFaiCorrect(String _strCosFai) {
    double dCosFai = double.parse(_strCosFai);
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
    double _dCurrentVal = 0;
    double _dRVal = 0;
    double _dXVal = 0;
    double _dK1Val = 1; // 電圧降下計算の係数
    double _dK2Val = 2; // 電力損失計算の係数
    Map _cableData = {}; // ケーブルのインピーダンスと許容電流のマップデータ

    // Textfieldのテキスト取り出し
    String _strElecOut = ref.read(cableDesignElecOutProvider).text;
    String _strCosFai = ref.read(cableDesignCosFaiProvider).text;
    String _strVolt = ref.read(cableDesignVoltProvider).text;
    String _strLen = ref.read(cableDesignCableLenProvider).text;

    // string2double
    double _dElecOut = double.parse(_strElecOut);
    double _dCosFai = double.parse(_strCosFai) / 100;
    double _dVolt = double.parse(_strVolt);
    double _dLen = double.parse(_strLen) / 1000;

    // cosφからsinφを算出
    double _dSinFai = sqrt(1 - pow(_dCosFai, 2));

    // 相ごとの計算(単相)
    if ((ref.read(cableDesignPhaseProvider) == '単相') && (_dCosFai <= 1)) {
      // 単相の電流計算と計算係数設定
      _dCurrentVal = _dElecOut / (_dVolt * _dCosFai);
      _dK1Val = 1;
      _dK2Val = 2;
    }
    // 相ごとの計算(三相)
    else if ((ref.read(cableDesignPhaseProvider) == '三相') && (_dCosFai <= 1)) {
      // 三相の電流計算と計算係数設定
      _dCurrentVal = _dElecOut / (sqrt(3) * _dVolt * _dCosFai);
      _dK1Val = sqrt(3);
      _dK2Val = 3;
    }

    /// ケーブル種類からデータを取得
    _cableData = CableConduitDataClass()
        .selectCableData(ref.read(cableDesignCableTypeProvider));

    /// ケーブル許容電流から600V CV-3Cケーブルの太さを選定
    /// 許容電流を満たすケーブルサイズをリストに追加
    List _cableAnswerList = [];
    _cableData.forEach((key, value) {
      if (value[2] >= _dCurrentVal) {
        _cableAnswerList
            .add([key, value[0], value[1]]); // [ケーブルサイズ, 抵抗, リアクタンス]
      }
    });

    /// 許容電流が満たせない場合は'規格なし'を返す。
    /// ケーブルサイズをproviderに書き込み
    String _cableSize = '';
    if (_cableAnswerList.isEmpty) {
      _cableSize = '規格なし';
      _dRVal = _dXVal = 0;
    } else {
      _cableSize = _cableAnswerList[0][0];
      _dRVal = _cableAnswerList[0][1];
      _dXVal = _cableAnswerList[0][2];
    }
    ref.read(cableDesignCableSizeProvider.state).state = _cableSize;

    // 電流値小数点の長さ固定して文字列に変換
    ref.read(cableDesignCurrentProvider.state).state =
        _dCurrentVal.toStringAsFixed(1);

    // ケーブル電圧降下計算
    double _dVoltDrop = _dK1Val *
        _dCurrentVal *
        _dLen *
        (_dRVal * _dCosFai + _dXVal * _dSinFai);
    ref.read(cableDesignVoltDropProvider.state).state =
        _dVoltDrop.toStringAsFixed(1);

    // ケーブル電力損失計算
    double _dPowLoss = _dK2Val * _dRVal * _dCurrentVal * _dCurrentVal * _dLen;
    ref.read(cableDesignPowerLossProvider.state).state =
        _dPowLoss.toStringAsFixed(1);

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }

  /// 電線管設計でケーブルカードのケーブル種別を変更するメソッド。
  void conduitCardSelectType(int _index, String? _value) {
    /// ケーブル種類の変更
    ref.read(conduitListItemProvider.state).state[_index]['type'] = _value!;

    /// ケーブルサイズの変更
    Map _cableData = CableConduitDataClass().selectCableData(_value);
    ref.read(conduitListItemProvider.state).state[_index]['size'] =
        _cableData.keys.toList()[0].toString();

    /// ケーブル外径の変更
    ref.read(conduitListItemProvider.state).state[_index]['radius'] =
        _cableData.values.toList()[0][3];

    /// ケーブルサイズリストの更新
    ref.read(conduitCableSizeListProvider.state).state[_index] =
        _cableData.keys.toList();

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
  void conduitCardSelectSize(int _index, String? _value) {
    /// ケーブルサイズの変更
    ref.read(conduitListItemProvider.state).state[_index]['size'] = _value;

    /// ケーブル外径の変更
    Map _cableData = CableConduitDataClass().selectCableData(
        ref.read(conduitListItemProvider.state).state[_index]['type']);
    ref.read(conduitListItemProvider.state).state[_index]['radius'] =
        _cableData[_value][3];

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
    Map _cableData = CableConduitDataClass().selectCableData('600V CV-2C');

    /// ケーブルサイズリストを変更
    ref.read(conduitCableSizeListProvider).add(_cableData.keys.toList());
    ref.read(conduitCableSizeListProvider.state).state = [
      ...ref.read(conduitCableSizeListProvider)
    ];

    /// 電線管設計実行
    conduitCalcRun();
  }

  /// 電線管設計でケーブルカードを削除するメソッド
  void conduitCableRemove(_index) {
    /// リストから削除
    ref.read(conduitListItemProvider).removeAt(_index);
    ref.read(conduitListItemProvider.state).state = [
      ...ref.read(conduitListItemProvider)
    ];

    /// ケーブルサイズから削除
    ref.read(conduitCableSizeListProvider).removeAt(_index);

    /// 電線管設計実行
    conduitCalcRun();

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }

  /// 電線管設計の電線管種類変更
  void conduitTypeChange(String? _value) {
    ref.read(conduitConduitTypeProvider.state).state = _value!;

    /// 電線管設計実行
    conduitCalcRun();
  }

  /// 電線管設計実行
  void conduitCalcRun() {
    // print(ref.read(conduitListItemProvider));

    /// conduitListItemProvider内の直径からケーブル面積を計算
    List _cableAreaList = ref
        .watch(conduitListItemProvider)
        .map((e) => {'type': e['type'], 'area': pow(e['radius'] / 2, 2) * pi})
        .toList();

    /// CVTケーブルなら面積を3倍にし、ケーブルの直径のListからケーブル面積の合計を計算
    double _cableArea = 0;
    for (var _i in _cableAreaList) {
      _cableArea += _i['type'] == '600V CVT' ? _i['area'] * 3 : _i['area'];
    }

    /// 電線管の直径を抽出
    Map _conduitRadiusMap = CableConduitDataClass()
        .selectConduitData(ref.watch(conduitConduitTypeProvider));

    /// 電線管の直径のListから電線管の断面積を計算と比較
    List _conduitArea32List = [];
    List _conduitArea48List = [];
    double _conduitArea;
    _conduitRadiusMap.forEach((key, value) {
      _conduitArea = pow(value / 2, 2) * pi;
      if (_conduitArea * 0.32 > _cableArea) {
        _conduitArea32List.add(key);
      }
      if (_conduitArea * 0.48 > _cableArea) {
        _conduitArea48List.add(key);
      }
    });

    /// conduitConduitSizeProviderの変更
    /// emptyなら'規格なし'を返す
    ref.read(conduitConduitSize32Provider.state).state =
        _conduitArea32List.isNotEmpty ? _conduitArea32List[0] : '規格なし';
    ref.read(conduitConduitSize48Provider.state).state =
        _conduitArea48List.isNotEmpty ? _conduitArea48List[0] : '規格なし';

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }

  /// 電力計算のロジック部分
  void elecPowerCalcRun() {
    // Textfieldのテキスト取り出し
    String _strCalcVolt = ref.read(elecPowerVoltProvider).text;
    String _strCalcCur = ref.read(elecPowerCurrentProvider).text;
    String _strCalcCosFai = ref.read(elecPowerCosFaiProvider).text;

    // string2double
    double _dCalcVolt = double.parse(_strCalcVolt);
    double _dCalcCur = double.parse(_strCalcCur);
    double _dCalcCosFai = double.parse(_strCalcCosFai) / 100;
    double _dCalcAppaPowVal = 0;

    // cosφからsinφを算出
    double _dCalcSinFai = sqrt(1 - pow(_dCalcCosFai, 2));

    if (ref.read(elecPowerPhaseProvider) == '単相') {
      // 単相電力計算
      _dCalcAppaPowVal = _dCalcVolt * _dCalcCur;
    } else if (ref.read(elecPowerPhaseProvider) == '三相') {
      // 3相電力計算
      _dCalcAppaPowVal = sqrt(3) * _dCalcVolt * _dCalcCur;
    }
    double _dCalcActPowVal = _dCalcAppaPowVal * _dCalcCosFai;
    double _dCalcReactPowVal = _dCalcAppaPowVal * _dCalcSinFai;

    // double2string
    ref.read(elecPowerApparentPowerProvider.state).state =
        (_dCalcAppaPowVal / 1000).toStringAsFixed(2);
    ref.read(elecPowerActivePowerProvider.state).state =
        (_dCalcActPowVal / 1000).toStringAsFixed(2);
    ref.read(elecPowerReactivePowerProvider.state).state =
        (_dCalcReactPowVal / 1000).toStringAsFixed(2);
    ref.read(elecPowerSinFaiProvider.state).state =
        (_dCalcSinFai * 100).toStringAsFixed(1);

    /// shared_prefに保存
    StateManagerClass().setCalcData(ref);
  }
}
