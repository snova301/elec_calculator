import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'rewarded_ads_model.freezed.dart';
// part 'rewarded_ads_model.g.dart';

/// リワード広告のデータクラス
@freezed
class RewardedAdsClass with _$RewardedAdsClass {
  const factory RewardedAdsClass({
    /// リワード広告のインスタンス
    required RewardedAd? rewardedAd,
  }) = _RewardedAdsClass;

  /// from Json
  // factory RewardedAdsClass.fromJson(Map<String, dynamic> json) =>
  //     _$RewardedAdsClassFromJson(json);
}
