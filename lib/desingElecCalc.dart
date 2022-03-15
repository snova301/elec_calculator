import 'dart:math';

import 'homePage.dart';
import 'cableSizeClass.dart';

class DesignElecCalc extends MyHomePageState {
  List designCalcDetail(strElecOut, strCosFai, strVolt, strLen, ddPhaseVal) {
    // string2double
    double dElecOut = double.parse(strElecOut);
    double dCosFai = double.parse(strCosFai) / 100;
    double dVolt = double.parse(strVolt);
    double dLen = double.parse(strLen) / 1000;

    // cosφからsinφを算出
    double dSinFai = sqrt(1 - pow(dCosFai, 2));

    // 相ごとの計算(エラー処理)
    if ((dCosFai > 1) || (dCosFai < 0)) {
      currentVal = 'Error';
      cvCableSize = 'Error';
      voltDropVal = 'Error';
      powLossVal = 'Error';

      // 相ごとの計算(単相)
    } else if ((ddPhaseVal == '単相') && (dCosFai <= 1)) {
      // 単相の電流計算と計算係数設定
      dCurrentVal = dElecOut / (dVolt * dCosFai);
      dK1Val = 1;
      dK2Val = 2;

      // ケーブル許容電流から600V CV-2Cケーブルの太さを選定
      cvCableSize = CabelSizeClass().cableSize1fai(dCurrentVal);

      // 相ごとの計算(三相)
    } else if ((ddPhaseVal == '三相') && (dCosFai <= 1)) {
      // 三相の電流計算と計算係数設定
      dCurrentVal = dElecOut / (sqrt(3) * dVolt * dCosFai);
      dK1Val = sqrt(3);
      dK2Val = 3;

      // ケーブル許容電流から600V CV-3Cケーブルの太さを選定
      cvCableSize = CabelSizeClass().cableSize3fai(dCurrentVal);
    }

    // CV-2Cと3Cはインピーダンスが同じだと仮定し
    List listImp = CabelSizeClass().cableImp(cvCableSize);
    dRVal = listImp[0];
    dXVal = listImp[1];

    // 電流値小数点の長さ固定して文字列に変換
    currentVal = dCurrentVal.toStringAsFixed(1);

    // ケーブル電圧降下計算
    double dVoltDrop =
        dK1Val * dCurrentVal * dLen * (dRVal * dCosFai + dXVal * dSinFai);
    voltDropVal = dVoltDrop.toStringAsFixed(1);

    // ケーブル電力損失計算
    double dPowLoss = dK2Val * dRVal * dCurrentVal * dCurrentVal * dLen;
    powLossVal = dPowLoss.toStringAsFixed(1);

    return [currentVal, cvCableSize, voltDropVal, powLossVal];
  }

  List elecPowCalcDetail(strCalcVolt, strCalcCur, strCalcCosFai, calcPhaseVal) {
    // string2double
    double dCalcVolt = double.parse(strCalcVolt);
    double dCalcCur = double.parse(strCalcCur);
    double dCalcCosFai = double.parse(strCalcCosFai) / 100;

    // cosφからsinφを算出
    double dCalcSinFai = sqrt(1 - pow(dCalcCosFai, 2));

    if (calcPhaseVal == '単相') {
      // 単相電力計算
      dCalcAppaPowVal = dCalcVolt * dCalcCur;
    } else if (calcPhaseVal == '三相') {
      // 3相電力計算
      dCalcAppaPowVal = sqrt(3) * dCalcVolt * dCalcCur;
    }
    double dCalcActPowVal = dCalcAppaPowVal * dCalcCosFai;
    double dCalcReactPowVal = dCalcAppaPowVal * dCalcSinFai;

    // double2string
    calcAppaPowVal = (dCalcAppaPowVal / 1000).toStringAsFixed(2);
    calcActPowVal = (dCalcActPowVal / 1000).toStringAsFixed(2);
    calcReactPowVal = (dCalcReactPowVal / 1000).toStringAsFixed(2);
    calcSinFaiVal = (dCalcSinFai * 100).toStringAsFixed(1);

    return [calcAppaPowVal, calcActPowVal, calcReactPowVal, calcSinFaiVal];
  }
}
