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
    setState(() {
      // Textfieldのテキスト取り出し
      String strElecOut = _elecOutController.text;
      String strCosFai = _cosFaiController.text;
      String strVolt = _voltController.text;
      String strLen = _lenController.text;

      // 計算結果渡し
      List designCalcList = DesignElecCalc()
          .designCalcDetail(strElecOut, strCosFai, strVolt, strLen, ddPhaseVal);
      currentVal = designCalcList[0];
      cvCableSize = designCalcList[1];
      voltDropVal = designCalcList[2];
      powLossVal = designCalcList[3];
    });
  }

  void _elecPowCalcRun() {
    setState(() {
      // Textfieldのテキスト取り出し
      String strCalcVolt = _calcVoltController.text;
      String strCalcCur = _calcCurController.text;
      String strCalcCosFai = _calcCosFaiController.text;

      // 計算結果渡し
      List designElecList = DesignElecCalc().elecPowCalcDetail(
          strCalcVolt, strCalcCur, strCalcCosFai, calcPhaseVal);
      calcAppaPowVal = designElecList[0];
      calcActPowVal = designElecList[1];
      calcReactPowVal = designElecList[2];
      calcSinFaiVal = designElecList[3];
    });
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(10),
              children: <Widget>[
                const Text(
                  '計算条件\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text('負荷の相'),
                    DropdownButton(
                      value: ddPhaseVal,
                      onChanged: (String? newValue) {
                        setState(() {
                          ddPhaseVal = newValue!;
                        });
                      },
                      items: <String>['単相', '三相']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                TextField(
                  controller: _elecOutController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: '電気容量(有効電力)[W]\n(整数)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      controller: _voltController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: '線間電圧[V]\n(整数)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    TextField(
                      controller: _cosFaiController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: '力率[%]\n(整数)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    TextField(
                      controller: _lenController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: 'ケーブル長さ[m]\n(整数)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const Text('\n\n'),
                  ],
                ),
                ElevatedButton(
                  onPressed: _designCalcRun,
                  child: const Text('計算実行'),
                ),
                const Text(
                  '\n\n計算結果\n\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('\n'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          '電流\n[A]',
                          style: TextStyle(fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'CVケーブル\n[mm2]',
                          style: TextStyle(fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '電圧降下\n[V]',
                          style: TextStyle(fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '電力損失\n[W]',
                          style: TextStyle(fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(currentVal)),
                          DataCell(Text(cvCableSize)),
                          DataCell(Text(voltDropVal)),
                          DataCell(Text(powLossVal)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Text('\n\n\n'),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(10),
              children: <Widget>[
                const Text(
                  '計算条件\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text('負荷の相'),
                    DropdownButton(
                      value: calcPhaseVal,
                      onChanged: (String? newValue) {
                        setState(() {
                          calcPhaseVal = newValue!;
                        });
                      },
                      items: <String>['単相', '三相']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      controller: _calcVoltController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: '線間電圧[V]\n(整数)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    TextField(
                      controller: _calcCurController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: '電流[A]\n(整数)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    TextField(
                      controller: _calcCosFaiController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: '力率[%]\n(整数)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const Text('\n\n'),
                  ],
                ),
                ElevatedButton(
                  onPressed: _elecPowCalcRun,
                  child: const Text('計算実行'),
                ),
                const Text(
                  '\n\n計算結果\n\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          '皮相電力\n[kVA]',
                          style: TextStyle(fontStyle: FontStyle.italic),
                          // textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '有効電力\n[kW]',
                          style: TextStyle(fontStyle: FontStyle.italic),
                          // textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '無効電力\n[kVar]',
                          style: TextStyle(fontStyle: FontStyle.italic),
                          // textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'sinφ\n[%]',
                          style: TextStyle(fontStyle: FontStyle.italic),
                          // textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(calcAppaPowVal)),
                          DataCell(Text(calcActPowVal)),
                          DataCell(Text(calcReactPowVal)),
                          DataCell(Text(calcSinFaiVal)),
                        ],
                      ),
                    ],
                  ),
                ),
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
              // ListTile(
              //   title: const Text('設定'),
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>
              //                 const SettingPage(title: '設定')));
              //   },
              // ),
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
