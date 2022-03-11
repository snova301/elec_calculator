class CabelSizeClass {
  String cvCableSize = '';

  String cableSize1fai(dCurrentVal) {
    if (dCurrentVal <= 39) {
      cvCableSize = '2';
    } else if ((dCurrentVal > 39) && (dCurrentVal <= 54)) {
      cvCableSize = '3.5';
    } else if ((dCurrentVal > 54) && (dCurrentVal <= 69)) {
      cvCableSize = '5.5';
    } else if ((dCurrentVal > 69) && (dCurrentVal <= 85)) {
      cvCableSize = '8';
    } else if ((dCurrentVal > 85) && (dCurrentVal <= 115)) {
      cvCableSize = '14';
    } else if ((dCurrentVal > 115) && (dCurrentVal <= 150)) {
      cvCableSize = '22';
    } else if ((dCurrentVal > 150) && (dCurrentVal <= 205)) {
      cvCableSize = '38';
    } else if ((dCurrentVal > 205) && (dCurrentVal <= 260)) {
      cvCableSize = '60';
    } else if ((dCurrentVal > 260) && (dCurrentVal <= 345)) {
      cvCableSize = '100';
    } else if ((dCurrentVal > 345) && (dCurrentVal <= 435)) {
      cvCableSize = '150';
    } else if ((dCurrentVal > 435) && (dCurrentVal <= 505)) {
      cvCableSize = '200';
    } else if ((dCurrentVal > 505) && (dCurrentVal <= 570)) {
      cvCableSize = '250';
    } else if ((dCurrentVal > 570) && (dCurrentVal <= 650)) {
      cvCableSize = '325';
    } else if (dCurrentVal > 650) {
      cvCableSize = '要相談';
    }
    return cvCableSize;
  }

  String cableSize3fai(dCurrentVal) {
    if (dCurrentVal <= 32) {
      cvCableSize = '2';
    } else if ((dCurrentVal > 32) && (dCurrentVal <= 45)) {
      cvCableSize = '3.5';
    } else if ((dCurrentVal > 45) && (dCurrentVal <= 58)) {
      cvCableSize = '5.5';
    } else if ((dCurrentVal > 58) && (dCurrentVal <= 71)) {
      cvCableSize = '8';
    } else if ((dCurrentVal > 71) && (dCurrentVal <= 97)) {
      cvCableSize = '14';
    } else if ((dCurrentVal > 97) && (dCurrentVal <= 125)) {
      cvCableSize = '22';
    } else if ((dCurrentVal > 125) && (dCurrentVal <= 170)) {
      cvCableSize = '38';
    } else if ((dCurrentVal > 170) && (dCurrentVal <= 215)) {
      cvCableSize = '60';
    } else if ((dCurrentVal > 215) && (dCurrentVal <= 285)) {
      cvCableSize = '100';
    } else if ((dCurrentVal > 285) && (dCurrentVal <= 360)) {
      cvCableSize = '150';
    } else if ((dCurrentVal > 360) && (dCurrentVal <= 420)) {
      cvCableSize = '200';
    } else if ((dCurrentVal > 420) && (dCurrentVal <= 470)) {
      cvCableSize = '250';
    } else if ((dCurrentVal > 470) && (dCurrentVal <= 540)) {
      cvCableSize = '325';
    } else if (dCurrentVal > 540) {
      cvCableSize = '要相談';
    }
    return cvCableSize;
  }

  List cableImp(cvCableSize) {
    double dRVal = 0;
    double dXVal = 0;
    if (cvCableSize == '2') {
      dRVal = 9.42;
      dXVal = 0.119;
    } else if (cvCableSize == '3.5') {
      dRVal = 5.3;
      dXVal = 0.110;
    } else if (cvCableSize == '5.5') {
      dRVal = 3.4;
      dXVal = 0.110;
    } else if (cvCableSize == '8') {
      dRVal = 2.36;
      dXVal = 0.104;
    } else if (cvCableSize == '14') {
      dRVal = 1.34;
      dXVal = 0.0994;
    } else if (cvCableSize == '22') {
      dRVal = 0.849;
      dXVal = 0.0984;
    } else if (cvCableSize == '38') {
      dRVal = 0.491;
      dXVal = 0.0925;
    } else if (cvCableSize == '60') {
      dRVal = 0.311;
      dXVal = 0.0922;
    } else if (cvCableSize == '100') {
      dRVal = 0.187;
      dXVal = 0.0928;
    } else if (cvCableSize == '150') {
      dRVal = 0.124;
      dXVal = 0.0893;
    } else if (cvCableSize == '200') {
      dRVal = 0.093;
      dXVal = 0.0906;
    } else if (cvCableSize == '250') {
      dRVal = 0.075;
      dXVal = 0.0887;
    } else if (cvCableSize == '325') {
      dRVal = 0.058;
      dXVal = 0.0867;
    } else if (cvCableSize == '要相談') {
      dRVal = 0;
      dXVal = 0;
    }
    return [dRVal, dXVal];
  }
}
