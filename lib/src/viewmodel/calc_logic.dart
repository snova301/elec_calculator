/// 各計算のロジック部分
class CalcLogic {
  /// 力率が0-100%の中に入っているか判定。
  /// 入っていたらtrue, 入っていなかったらfalseを返す。
  bool isCosFaiCorrect(String strCosFai) {
    double dCosFai = double.parse(strCosFai);
    return (dCosFai >= 0 && dCosFai <= 100) ? true : false;
  }
}
