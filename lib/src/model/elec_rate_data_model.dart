import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'elec_rate_data_model.freezed.dart';
part 'elec_rate_data_model.g.dart';

/// 需要率計算のProviderデータの定義
@freezed
class ElecRateData with _$ElecRateData {
  const factory ElecRateData({
    /// 入力
    /// 相
    required PhaseNameEnum phase,

    /// 電圧
    required double volt,

    /// 電圧単位
    required VoltUnitEnum voltUnit,

    /// 電流
    required double current,

    /// 力率
    required double cosFai,

    /// 出力
    /// 皮相電力
    required double apparentPower,

    /// 有効電力
    required double activePower,

    /// 無効電力
    required double reactivePower,

    /// sinφ
    required double sinFai,

    /// 電力単位
    required PowerUnitEnum powerUnit,
  }) = _ElecRateData;

  /// from Json
  factory ElecRateData.fromJson(Map<String, dynamic> json) =>
      _$ElecRateDataFromJson(json);
}
