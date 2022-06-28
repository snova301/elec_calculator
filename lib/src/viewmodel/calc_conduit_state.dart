import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/data/conduit_data.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';

/// 電線管設計のProviderの定義
final conduitCalcProvider =
    StateNotifierProvider<ConduitCalcNotifier, List<ConduitCalcDataClass>>(
        (ref) {
  return ConduitCalcNotifier();
});

/// 電線管設計のStateNotifierを定義
class ConduitCalcNotifier extends StateNotifier<List<ConduitCalcDataClass>> {
  // 空のデータとして初期化
  ConduitCalcNotifier() : super([]);

  /// ケーブル面積の計算
  double calcCableArea() {
    /// ケーブルのリストを抜き出す
    final cableItems = state;

    /// ケーブルの種類と半径を抜き出し、それぞれのケーブル断面積を計算
    /// このとき、CVTケーブルなら面積を3倍にする
    /// reduce計算でケーブルの面積の合計を計算
    /// cableItemに何も入っていない場合エラーになるので強制的に0を入力
    double cableArea;
    if (cableItems.isEmpty) {
      cableArea = 0;
    } else {
      cableArea = cableItems
          .map((e) => e.cableType == CableTypeEnum.cvt600v.cableType
              ? 3 * pow(e.cableRadius / 2, 2) * pi
              : pow(e.cableRadius / 2, 2) * pi)
          .reduce((value, element) => value + element);
    }

    return cableArea;
  }

  /// ケーブルのサイズリストを返す
  List cableSizeList(int index) {
    /// ケーブルの種類を取得
    String cableType = state[index].cableType;

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
    final cableData = ConduitCalcDataClass(
      cableType: CableTypeEnum.cv2c600v.cableType,
      cableSize: '2',
      cableRadius: 10.5,
    );

    /// 値を追加
    var temp = state;

    temp.add(cableData);
    state = [...temp];
  }

  /// 全データの更新
  void updateAll(List<ConduitCalcDataClass> data) {
    state = [...data];
  }

  /// ケーブルサイズの更新
  void updateCableSize(int index, String newCableSize) {
    /// ケーブルの種類を取得
    String cableType = state[index].cableType;

    /// ケーブルの種類からケーブルのデータを取得
    Map<String, CableDataClass> newCableData =
        CableData().selectCableData(cableType);

    /// ケーブルのデータからケーブルの外径を取得
    double newCableRadius = newCableData[newCableSize]!.diameter;

    /// ケーブルアイテムを更新
    var temp = state;

    temp[index] = ConduitCalcDataClass(
      cableType: cableType,
      cableSize: newCableSize,
      cableRadius: newCableRadius,
    );

    /// 書込み
    state = [...temp];
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
    var temp = state;

    temp[index] = ConduitCalcDataClass(
      cableType: newCableType,
      cableSize: newCableSize,
      cableRadius: newCableRadius,
    );

    /// 書込み
    state = [...temp];
  }

  /// ケーブルカードの削除
  void removeCable(int index) {
    /// itemsの取得
    var temp = state;

    /// 削除
    temp.removeAt(index);

    /// 書込み
    state = [...temp];
  }

  /// データを初期化
  void removeAll() {
    state = [];
  }
}

/// 電線管種類のprovider
final conduitConduitTypeProvider = StateProvider<String>((ref) {
  return ConduitTypeEnum.pf.conduitType;
});

/// 32%占有率の計算
final conduitOccupancy32Provider = StateProvider<String>((ref) {
  /// ケーブル断面積の計算
  /// ref.watch(conduitCalcProvider) で事前に変更検知
  ref.watch(conduitCalcProvider);
  final cableArea = ref.watch(conduitCalcProvider.notifier).calcCableArea();

  /// 電線管の直径を抽出
  Map conduitRadiusMap =
      ConduitData().selectConduitData(ref.watch(conduitConduitTypeProvider));

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
  /// ref.watch(conduitCalcProvider) で事前に変更検知
  ref.watch(conduitCalcProvider);
  final cableArea = ref.watch(conduitCalcProvider.notifier).calcCableArea();

  /// 電線管の直径を抽出
  Map conduitRadiusMap =
      ConduitData().selectConduitData(ref.watch(conduitConduitTypeProvider));

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
