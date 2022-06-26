import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/data/conduit_data.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';

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
