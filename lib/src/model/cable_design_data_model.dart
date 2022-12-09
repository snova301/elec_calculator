import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cable_design_data_model.freezed.dart';
part 'cable_design_data_model.g.dart';

/// ケーブル設計入力のProvider入力データの定義
@freezed
class CableDesignData with _$CableDesignData {
  const factory CableDesignData({
    /// 入力
    /// 相
    required PhaseNameEnum phase,

    /// ケーブル種類
    required String cableType,

    /// 電気出力
    required double elecOut,

    /// 電圧
    required double volt,

    /// 力率
    required double cosFai,

    /// ケーブル長さ
    required double cableLength,

    /// 電圧単位
    required VoltUnitEnum voltUnit,

    /// 電力接頭語単位
    required PowerUnitEnum powerUnit,

    /// 出力
    /// 電流
    required double current,

    /// ケーブルサイズ(第1候補)
    required String cableSize1,

    /// 電圧降下(第1候補)
    required double voltDrop1,

    /// 電力損失(第1候補)
    required double powerLoss1,

    /// ケーブルサイズ(第2候補)
    required String cableSize2,

    /// 電圧降下(第2候補)
    required double voltDrop2,

    /// 電力損失(第2候補)
    required double powerLoss2,
  }) = _CableDesignData;

  /// from Json
  factory CableDesignData.fromJson(Map<String, dynamic> json) =>
      _$CableDesignDataFromJson(json);
}
