import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart'; // 広告用

import 'desingElecCalc.dart';
import 'methodPage.dart';
import 'settingPage.dart';
import 'aboutPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // ケーブル設計初期化
  String ddPhaseVal = '単相';
  String currentVal = '0';
  String cvCableSize = '0';
  String voltDropVal = '0';
  String powLossVal = '0';

  // 電力計算初期化
  String calcPhaseVal = '単相';
  String calcAppaPowVal = '0';
  String calcActPowVal = '0';
  String calcReactPowVal = '0';
  String calcSinFaiVal = '0';
  double dCalcAppaPowVal = 0;

  // 計算用変数初期化
  double dCurrentVal = 0;
  double dRVal = 0;
  double dXVal = 0;
  double dK1Val = 1; // 電圧降下計算の係数
  double dK2Val = 2; // 電力損失計算の係数

  // Textfieldのコントローラー初期化
  var _elecOutController = TextEditingController(text: '1500');
  var _cosFaiController = TextEditingController(text: '80');
  var _voltController = TextEditingController(text: '200');
  var _lenController = TextEditingController(text: '10');
  var _calcVoltController = TextEditingController(text: '100');
  var _calcCurController = TextEditingController(text: '10');
  var _calcCosFaiController = TextEditingController(text: '80');

  // admobの関数定義
  // BannerAd adMyBanner = BannerAd(
  //   adUnitId: 'ca-app-pub-3940256099942544/6300978111', // テスト用
  //   size: AdSize.banner,
  //   request: const AdRequest(),
  //   listener: const BannerAdListener(),
  // )..load();

  // ケーブル設計の計算実行
  void _designCalcRun() {
    // Textfieldのテキスト取り出し
    String strElecOut = _elecOutController.text;
    String strCosFai = _cosFaiController.text;
    String strVolt = _voltController.text;
    String strLen = _lenController.text;

    double dStrCosFai = double.parse(strCosFai); // 力率判定
    setState(() {
      if (dStrCosFai < 1 || dStrCosFai > 100) {
        // 力率エラー処理
        currentVal = '-';
        cvCableSize = '-';
        voltDropVal = '-';
        powLossVal = '-';

        // ポップアップ表示で警告
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('力率数値異常'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('力率は1-100の間で設定してください。'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // 計算結果渡し
        List designCalcList = DesignElecCalc().designCalcDetail(
            strElecOut, strCosFai, strVolt, strLen, ddPhaseVal);
        currentVal = designCalcList[0];
        cvCableSize = designCalcList[1];
        voltDropVal = designCalcList[2];
        powLossVal = designCalcList[3];
      }
    });
  }

  void _elecPowCalcRun() {
    // Textfieldのテキスト取り出し
    String strCalcVolt = _calcVoltController.text;
    String strCalcCur = _calcCurController.text;
    String strCalcCosFai = _calcCosFaiController.text;

    double dstrCalcCosFai = double.parse(strCalcCosFai);

    setState(() {
      if (dstrCalcCosFai < 1 || dstrCalcCosFai > 100) {
        // 力率エラー処理
        calcAppaPowVal = '-';
        calcActPowVal = '-';
        calcReactPowVal = '-';
        calcSinFaiVal = '-';

        // ポップアップ表示で警告
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('力率数値異常'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('力率は1-100の間で設定してください。'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // 計算結果渡し
        List designElecList = DesignElecCalc().elecPowCalcDetail(
            strCalcVolt, strCalcCur, strCalcCosFai, calcPhaseVal);
        calcAppaPowVal = designElecList[0];
        calcActPowVal = designElecList[1];
        calcReactPowVal = designElecList[2];
        calcSinFaiVal = designElecList[3];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //画面情報取得
    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;
    final blockSizeHorizontal = screenWidth / 100;
    // final screenHeight = _mediaQueryData.size.height;
    // final blockSizeVertical = screenHeight / 100;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.design_services),
                  text: 'ケーブル設計',
                ),
                Tab(
                  icon: Icon(Icons.calculate),
                  text: '電力計算',
                ),
              ],
            )),

        body: TabBarView(
          children: <Widget>[
            ListView(
              // padding: const EdgeInsets.all(10),
              children: <Widget>[
                Container(
                  width: blockSizeHorizontal * 30,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    '計算条件',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Card(
                      // color: Colors.red,
                      child: Container(
                        alignment: const Alignment(0, 0),
                        width: blockSizeHorizontal * 50,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.grey),
                        //     borderRadius: BorderRadius.circular(10),
                        //     color: Colors.red),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                              child: const Tooltip(
                                message: '選択してください',
                                child: Text(
                                  '負荷の相',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (ddPhaseVal == '単相')
                                  ? () {
                                      setState(() {
                                        ddPhaseVal = '三相';
                                      });
                                    }
                                  : () {
                                      setState(() {
                                        ddPhaseVal = '単相';
                                      });
                                    },
                              child: Text(ddPhaseVal),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(20.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: blockSizeHorizontal * 30,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  const Tooltip(
                                    message: '整数のみ',
                                    child: Text(
                                      '電気容量\n[W]',
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TextField(
                                    controller: _elecOutController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              width: blockSizeHorizontal * 30,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  const Tooltip(
                                    message: '整数のみ',
                                    child: Text(
                                      '線間電圧\n[V]',
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TextField(
                                    controller: _voltController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: blockSizeHorizontal * 30,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  const Tooltip(
                                    message: '1-100%の整数のみ',
                                    child: Text(
                                      '力率\n[%]',
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TextField(
                                    controller: _cosFaiController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              width: blockSizeHorizontal * 30,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  const Tooltip(
                                    message: '整数のみ',
                                    child: Text(
                                      'ケーブル長\n[m]',
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TextField(
                                    controller: _lenController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  // width: blockSizeHorizontal * 50,
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(
                      blockSizeHorizontal * 20, 0, blockSizeHorizontal * 20, 0),
                  child: ElevatedButton(
                    onPressed: _designCalcRun,
                    child: const Text(
                      '計算実行',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(30.0)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    '計算結果',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      child: Container(
                        width: blockSizeHorizontal * 30,
                        alignment: const Alignment(0, 0),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: const Text(
                                '電流\n[A]',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                currentVal,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: blockSizeHorizontal * 30,
                        alignment: const Alignment(0, 0),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: const Text(
                                'CVケーブル\n[mm2]',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                cvCableSize,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      child: Container(
                        width: blockSizeHorizontal * 30,
                        alignment: const Alignment(0, 0),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: const Text(
                                '電圧降下\n[V]',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                voltDropVal,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: blockSizeHorizontal * 30,
                        alignment: const Alignment(0, 0),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: const Text(
                                '電力損失\n[W]',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                powLossVal,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            ListView(
              // padding: const EdgeInsets.all(10),
              children: <Widget>[
                Container(
                  width: blockSizeHorizontal * 30,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    '計算条件',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Card(
                      // color: Colors.red,
                      child: Container(
                        alignment: const Alignment(0, 0),
                        width: blockSizeHorizontal * 50,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.grey),
                        //     borderRadius: BorderRadius.circular(10),
                        //     color: Colors.red),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                              child: const Tooltip(
                                message: '選択してください',
                                child: Text(
                                  '負荷の相',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (calcPhaseVal == '単相')
                                  ? () {
                                      setState(() {
                                        calcPhaseVal = '三相';
                                      });
                                    }
                                  : () {
                                      setState(() {
                                        calcPhaseVal = '単相';
                                      });
                                    },
                              child: Text(calcPhaseVal),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: blockSizeHorizontal * 30,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  const Tooltip(
                                    message: '整数のみ',
                                    child: Text(
                                      '線間電圧\n[V]',
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TextField(
                                    controller: _calcVoltController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              width: blockSizeHorizontal * 30,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  const Tooltip(
                                    message: '整数のみ',
                                    child: Text(
                                      '電流\n[A]',
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TextField(
                                    controller: _calcCurController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            child: Container(
                              width: blockSizeHorizontal * 30,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  const Tooltip(
                                    message: '1-100%の整数のみ',
                                    child: Text(
                                      '力率\n[%]',
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  TextField(
                                    controller: _calcCosFaiController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Card(
                          //   elevation: 0,
                          //   child: Container(
                          //     width: blockSizeHorizontal * 30,
                          //     padding: const EdgeInsets.all(10),
                          //     margin: const EdgeInsets.all(10),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  // width: blockSizeHorizontal * 50,
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(
                      blockSizeHorizontal * 20, 0, blockSizeHorizontal * 20, 0),
                  child: ElevatedButton(
                    onPressed: _elecPowCalcRun,
                    child: const Text(
                      '計算実行',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(30.0)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    '計算結果',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      child: Container(
                        width: blockSizeHorizontal * 30,
                        alignment: const Alignment(0, 0),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: const Text(
                                '皮相電力\n[kVA]',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                calcAppaPowVal,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: blockSizeHorizontal * 30,
                        alignment: const Alignment(0, 0),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: const Text(
                                '有効電力\n[kW]',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                calcActPowVal,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      child: Container(
                        width: blockSizeHorizontal * 30,
                        alignment: const Alignment(0, 0),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: const Text(
                                '無効電力\n[kVar]',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                calcReactPowVal,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: blockSizeHorizontal * 30,
                        alignment: const Alignment(0, 0),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: const Text(
                                'sinφ\n[%]',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                calcSinFaiVal,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                // decoration: BoxDecoration(
                //   color: Colors.green,
                // ),
                child: Text('メニュー'),
              ),
              ListTile(
                title: const Text('計算画面'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('計算方法'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MethodPage()));
                },
              ),
              ListTile(
                title: const Text('設定'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                  // const SettingPage(title: '設定')));
                },
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutPage()));
                },
              ),
            ],
          ),
        ),
        // 広告用のbottomnavigator
        // bottomNavigationBar: Container(
        //   alignment: Alignment.center,
        //   child: AdWidget(ad: adMyBanner),
        //   width: adMyBanner.size.width.toDouble(),
        //   height: adMyBanner.size.height.toDouble(),
        // ),
      ),
    );
  }
}
