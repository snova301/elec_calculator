/// ケーブルのMapデータの定義
class CableDataClass {
  /// 抵抗(Ω/km)
  double rVal;

  /// リアクタンス(Ω/km)
  double xVal;

  /// 許容電流(A)
  double current;

  /// 仕上外径(mm)
  /// CVTケーブルの場合はケーブル1条あたりの外径
  double diameter;

  CableDataClass({
    required this.rVal,
    required this.xVal,
    required this.current,
    required this.diameter,
  });
}


// /// Map型に変換
// Map toMap() => {
//       'current': current,
//       'cableSize': cableSize,
//       'voltDrop': voltDrop,
//       'powerLoss': powerLoss,
//     };

// /// JSONオブジェクトを代入
// CableDesignData.fromJson(Map json)
//     : phase = json['phase'],
//       current = json['current'],
//       cableSize = json['cableSize'],
//       voltDrop = json['voltDrop'],
//       powerLoss = json['powerLoss'];
