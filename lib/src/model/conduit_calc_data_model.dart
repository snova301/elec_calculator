import 'package:freezed_annotation/freezed_annotation.dart';

part 'conduit_calc_data_model.freezed.dart';
part 'conduit_calc_data_model.g.dart';

/// 電線管設計のProviderデータの定義
@freezed
class ConduitCalcDataClass with _$ConduitCalcDataClass {
  const factory ConduitCalcDataClass({
    /// ケーブル種類
    required String cableType,

    /// ケーブルサイズ
    required String cableSize,

    /// ケーブル半径
    required double cableRadius,
  }) = _ConduitCalcDataClass;

  /// from Json
  factory ConduitCalcDataClass.fromJson(Map<String, dynamic> json) =>
      _$ConduitCalcDataClassFromJson(json);
}
