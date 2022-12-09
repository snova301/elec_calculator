import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'elec_rate_data_model.freezed.dart';
part 'elec_rate_data_model.g.dart';

/// 需要率計算のProviderデータの定義
@freezed
class ElecRateData with _$ElecRateData {
  const factory ElecRateData({
    /// 需要率計算タブのデータ定義
    /// 電力接頭語単位
    required PowerUnitEnum ratePowerUnit,

    /// 電力単位(皮相と有効)
    required PowerUnitEnum ratePowerUnitAppa,

    /// 全設備容量
    required double rateAllInstCapa,

    /// 最大需要電力
    required double rateMaxDemandPower,

    /// 負荷率の計算の有無
    required bool rateIsLoadFactor,

    /// 平均需要電力
    required double rateAveDemandPower,

    /// 需要率
    required double rateDemandRate,

    /// 負荷率
    required double rateLoadRate,

    /// 最大需要電力計算タブのデータ定義
    /// 電力接頭語単位
    required PowerUnitEnum powerPowerUnit,

    /// 電力単位(皮相と有効)
    required PowerUnitEnum powerPowerUnitAppa,

    /// 全設備容量
    required double powerAllInstCapa,

    /// 最大需要電力
    required double powerMaxDemandPower,

    /// 負荷率の計算の有無
    required bool powerIsLoadFactor,

    /// 平均需要電力
    required double powerAveDemandPower,

    /// 需要率
    required double powerDemandRate,

    /// 負荷率
    required double powerLoadRate,
  }) = _ElecRateData;

  /// from Json
  factory ElecRateData.fromJson(Map<String, dynamic> json) =>
      _$ElecRateDataFromJson(json);
}
