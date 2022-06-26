import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/data/cable_data.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';

/// 配線リスト入力のProviderの定義
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
  Map<String, WiringListDataClass> cableTypeMap = {};
  Map<String, WiringListDataClass> startMap = {};
  Map<String, WiringListDataClass> endMap = {};

  /// ケーブル種類の選別
  if (originalMap.isEmpty || cableType == WiringListSearchEnum.cableData.name) {
    cableTypeMap = originalMap;
  } else {
    originalMap.forEach((key, value) {
      if (cableType == value.cableType) {
        cableTypeMap[key] = value;
      }
    });
  }

  /// 出発点の選別
  if (cableTypeMap.isEmpty || startPoint == WiringListSearchEnum.start.name) {
    startMap = cableTypeMap;
  } else {
    cableTypeMap.forEach((key, value) {
      if (startPoint == value.startPoint) {
        startMap[key] = value;
      }
    });
  }

  /// 到着点の選別
  if (startMap.isEmpty || endPoint == WiringListSearchEnum.end.name) {
    endMap = startMap;
  } else {
    startMap.forEach((key, value) {
      if (endPoint == value.endPoint) {
        endMap[key] = value;
      }
    });
  }

  print(endMap);
  return endMap;
});

/// WiringListページの検索のProvider初期化
final wiringListSearchCableTypeProvider = StateProvider((ref) {
  return WiringListSearchEnum.cableData.name;
});

/// ケーブル種類絞り込み用リスト
final wiringListSearchCableTypeListProvider = StateProvider((ref) {
  // final originalMap = ref.watch(wiringListShowProvider);
  final originalMap = ref.watch(wiringListProvider);

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
  // final originalMap = ref.watch(wiringListShowProvider);
  final originalMap = ref.watch(wiringListProvider);

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
  // final originalMap = ref.watch(wiringListShowProvider);
  final originalMap = ref.watch(wiringListProvider);

  List<String> endList = [WiringListSearchEnum.end.name];
  originalMap.forEach((key, value) {
    if (!endList.contains(value.endPoint)) {
      endList.add(value.endPoint);
    }
  });

  return endList;
});
