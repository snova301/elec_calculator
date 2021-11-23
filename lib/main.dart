// import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';　// 広告用

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electric Facility Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // fontFamily: "Noto Sans JP",
      ),

      // ダークモード対応
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.system,

      // 中華系フォント対策
      locale: const Locale("ja", "JP"),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ja", "JP"),
      ],

      // ページタイトル
      home: const MyHomePage(title: '計算画面'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 初期化
  String ddPhaseVal = '単相';
  String currentVal = '0';
  String cvCableSize = '0';
  String voltDropVal = '0';
  String powLossVal = '0';
  String calcPhaseVal = '単相';
  String calcAppaPowVal = '0';
  String calcActPowVal = '0';
  String calcReactPowVal = '0';
  String calcSinFaiVal = '0';
  double dCurrentVal = 0;
  double dRVal = 0;
  double dXVal = 0;
  double dK1Val = 1; // 電圧降下計算の係数
  double dK2Val = 2; // 電力損失計算の係数
  double dCalcAppaPowVal = 0;

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

      // string2double
      double dElecOut = double.parse(strElecOut);
      double dCosFai = double.parse(strCosFai) / 100;
      double dVolt = double.parse(strVolt);
      double dLen = double.parse(strLen) / 1000;

      // cosφからsinφを算出
      double dSinFai = sqrt(1 - pow(dCosFai, 2));

      // 相ごとの計算
      if ((dCosFai > 1) || (dCosFai < 0)) {
        currentVal = 'Error';
        cvCableSize = 'Error';
        voltDropVal = 'Error';
        powLossVal = 'Error';
      } else if ((ddPhaseVal == '単相') && (dCosFai <= 1)) {
        // 単相の電流計算と計算係数設定
        dCurrentVal = dElecOut / (dVolt * dCosFai);
        dK1Val = 1;
        dK2Val = 2;

        // ケーブル許容電流から600V CV-2Cケーブルの太さを選定
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
      } else if ((ddPhaseVal == '三相') && (dCosFai <= 1)) {
        // 三相の電流計算と計算係数設定
        dCurrentVal = dElecOut / (sqrt(3) * dVolt * dCosFai);
        dK1Val = sqrt(3);
        dK2Val = 3;

        // ケーブル許容電流から600V CV-3Cケーブルの太さを選定
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
      }

      // CV-2Cと3Cはインピーダンスが同じだと仮定し
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

      // 電流値小数点の長さ固定して文字列に変換
      currentVal = dCurrentVal.toStringAsFixed(1);

      // ケーブル電圧降下計算
      double dVoltDrop =
          dK1Val * dCurrentVal * dLen * (dRVal * dCosFai + dXVal * dSinFai);
      voltDropVal = dVoltDrop.toStringAsFixed(1);

      // ケーブル電力損失計算
      double dPowLoss = dK2Val * dRVal * dCurrentVal * dCurrentVal * dLen;
      powLossVal = dPowLoss.toStringAsFixed(1);
    });
  }

  void _elecPowCalc() {
    setState(() {
      // Textfieldのテキスト取り出し
      String strCalcVolt = _calcVoltController.text;
      String strCalcCur = _calcCurController.text;
      String strCalcCosFai = _calcCosFaiController.text;

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
          ),
        ),
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
                  onPressed: _elecPowCalc,
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
                          '皮相電力\n[kW]',
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
                          '無効電力\n[kW]',
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
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
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

class MethodPage extends StatelessWidget {
  const MethodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("計算方法"),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        const Text('ここでは計算の方法を紹介します。'),
        const Text(
          '\n\n【ケーブル設計計算】\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text('有効電力をP, 線電流をI, 線間電圧をV, 力率をconsφとすると、'),
        const Text('  単相の場合'),
        const Text('     I = P / (V * cosφ)'),
        const Text('  三相の場合'),
        const Text('     I = P / (√3 * V * cosφ)'),
        const Text('\nケーブルサイズは流れる電流が許容電流より小さくなるサイズの最小値を選定。'),
        const Text('電圧降下と電力損失は選定されたケーブルの単位長あたりのインピーダンスとケーブル長さから抵抗値Rを求める。'),
        const Text('\nこのとき、ケーブルの電圧降下をΔV, ケーブルの単位長インピーダンスをr+jx, ケーブルの長さをlとすると、'),
        const Text('  単相の場合'),
        const Text('     ΔV = I * l * ( r * cosφ + x * sinφ )'),
        const Text('  三相の場合'),
        const Text('     ΔV = √3 * I * l * ( r * cosφ + x * sinφ )'),
        const Text('\nまた、ケーブルの電力損失Plをとすると'),
        const Text('  単相の場合'),
        const Text('     Pl = 2 * I^2 * r'),
        const Text('  三相の場合'),
        const Text('     Pl = 3 * I^2 * r'),
        const Text(
          '\n\n【電力計算】\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text('線間電圧、電流、力率から各電力を求める。'),
        const Text('線電流をI, 線間電圧をV, 力率をconsφ, 皮相電力をS, 有効電力をP, 無効電力をQとすると、'),
        const Text('  単相の場合'),
        const Text('     S = V * I'),
        const Text('     P = V * I * cosφ'),
        const Text('     Q = V * I * sinφ'),
        const Text('  三相の場合'),
        const Text('     S = √3 * V * I'),
        const Text('     P = √3 * V * I * cosφ'),
        const Text('     Q = √3 * V * I * sinφ'),
        const Text(
          '\n\n【参考】',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text('- JCMA, 低圧ケーブルの許容電流表 (1989)\n'),
        // URL : https://www.jcma2.jp/gijutsu/shiryou/index.html
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('戻る'),
        ),
      ]),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        const Text('【本アプリについて】'),
        const Text('本アプリは電気設備設計時に必要な計算ツールを提供します。'),
        const Text('作業現場での確認やすぐに電圧降下、電力損失を計算するための強力なツールです。'),
        const Text('広告がありますが、全ての機能を無料で使用できます。'),
        const Text('\n【免責事項】'),
        const Text('本アプリで計算された結果は実測値を保証するものではありません。'),
        const Text('本アプリの利用によって生じた損害は、製作者または配信者はその責任を負いません。'),
        // const Text('\n【プライバシーポリシー】'),
        // const Text('本アプリのプライバシーポリシーは以下のサイトに記載しております。'),
        // const Text('http\n'),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('戻る'),
        ),
      ]),
    );
  }
}
