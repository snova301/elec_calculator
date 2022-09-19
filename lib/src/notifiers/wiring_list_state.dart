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

/// 配線リスト入力のNotifierの定義
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

  /// 全データの更新
  void updateAll(Map<String, WiringListDataClass> data) {
    state = {...data};
  }

  /// 削除
  void remove(String id) {
    /// 新規追加または変更
    Map temp = state;
    temp.remove(id);
    state = {...temp};
  }

  /// データを初期化
  void removeAll() {
    state = {};
  }
}

/// WiringListページ間の設定クラスのProvider初期化
final wiringListSettingProvider = StateProvider((ref) {
  return WiringListSettingDataClass(
    isCreate: true,
    id: '',
    nameController: TextEditingController(text: ''),
    cableType: CableTypeEnum.cv3c6600v.str,
    // cableType: CableTypeEnum.cv2c600v.str,
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
  if (originalMap.isEmpty ||
      cableType == WiringListSearchEnum.cableData.message) {
    cableTypeMap = originalMap;
  } else {
    originalMap.forEach((key, value) {
      if (cableType == value.cableType) {
        cableTypeMap[key] = value;
      }
    });
  }

  /// 出発点の選別
  if (cableTypeMap.isEmpty ||
      startPoint == WiringListSearchEnum.start.message) {
    startMap = cableTypeMap;
  } else {
    cableTypeMap.forEach((key, value) {
      if (startPoint == value.startPoint) {
        startMap[key] = value;
      }
    });
  }

  /// 到着点の選別
  if (startMap.isEmpty || endPoint == WiringListSearchEnum.end.message) {
    endMap = startMap;
  } else {
    startMap.forEach((key, value) {
      if (endPoint == value.endPoint) {
        endMap[key] = value;
      }
    });
  }

  return endMap;
});

/// ケーブル種類絞り込みの検索単語のProvider初期化
final wiringListSearchCableTypeProvider = StateProvider((ref) {
  if (ref.watch(wiringListProvider).isEmpty) {
    return WiringListSearchEnum.cableData.message;
  }
  return WiringListSearchEnum.cableData.message;
});

/// ケーブル種類絞り込み用リストのProvider初期化
final wiringListSearchCableTypeListProvider = StateProvider((ref) {
  /// 配線リストの取得
  final originalMap = ref.watch(wiringListProvider);

  /// 一致したデータをリストに格納
  List<String> cableTypeList = [WiringListSearchEnum.cableData.message];
  originalMap.forEach((key, value) {
    if (!cableTypeList.contains(value.cableType)) {
      cableTypeList.add(value.cableType);
    }
  });

  return cableTypeList;
});

/// 出発点絞り込みの検索単語のProvider初期化
final wiringListSearchStartProvider = StateProvider((ref) {
  if (ref.watch(wiringListProvider).isEmpty) {
    return WiringListSearchEnum.start.message;
  }
  return WiringListSearchEnum.start.message;
});

/// 出発点絞り込み用リストのProvider初期化
final wiringListSearchStartListProvider = StateProvider((ref) {
  /// 配線リストの取得
  final originalMap = ref.watch(wiringListProvider);

  /// 一致したデータをリストに格納
  List<String> startList = [WiringListSearchEnum.start.message];
  originalMap.forEach((key, value) {
    if (!startList.contains(value.startPoint)) {
      startList.add(value.startPoint);
    }
  });

  return startList;
});

/// 到着点絞り込みの検索単語のProvider初期化
final wiringListSearchEndProvider = StateProvider((ref) {
  if (ref.watch(wiringListProvider).isEmpty) {
    return WiringListSearchEnum.end.message;
  }
  return WiringListSearchEnum.end.message;
});

/// 到着点絞り込み用リストのProvider初期化
final wiringListSearchEndListProvider = StateProvider((ref) {
  /// 配線リストの取得
  final originalMap = ref.watch(wiringListProvider);

  /// 一致したデータをリストに格納
  List<String> endList = [WiringListSearchEnum.end.message];
  originalMap.forEach((key, value) {
    if (!endList.contains(value.endPoint)) {
      endList.add(value.endPoint);
    }
  });

  return endList;
});
