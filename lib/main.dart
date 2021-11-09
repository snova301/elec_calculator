import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      ),
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
  double dCurrentVal = 0;
  double dResistanceVal = 0;

// Textfieldのコントローラー初期化
  var _elecOutController = TextEditingController(text: '1500');
  var _cosFaiController = TextEditingController(text: '80');
  var _voltController = TextEditingController(text: '200');
  var _lenController = TextEditingController(text: '10');

// 計算実行
  _calcRun() {
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

      // 相ごとの計算
      if (dCosFai > 1) {
        currentVal = 'Error';
        cvCableSize = 'Error';
        voltDropVal = 'Error';
        powLossVal = 'Error';
      } else if ((ddPhaseVal == '三相') && (dCosFai <= 1)) {
        // 三相の電流計算
        dCurrentVal = dElecOut / (sqrt(3) * dVolt * dCosFai);

        // JCMAのHPよりケーブル許容電流から600V CV-3Cケーブルの太さを選定
        // https://www.jcma2.jp/gijutsu/shiryou/index.html
        if (dCurrentVal <= 32) {
          cvCableSize = '2';
          dResistanceVal = 9.42;
        } else if ((dCurrentVal > 32) && (dCurrentVal <= 45)) {
          cvCableSize = '3.5';
          dResistanceVal = 5.3;
        } else if ((dCurrentVal > 45) && (dCurrentVal <= 58)) {
          cvCableSize = '5.5';
          dResistanceVal = 3.4;
        } else if ((dCurrentVal > 58) && (dCurrentVal <= 71)) {
          cvCableSize = '8';
          dResistanceVal = 2.36;
        } else if ((dCurrentVal > 71) && (dCurrentVal <= 97)) {
          cvCableSize = '14';
          dResistanceVal = 1.34;
        } else if ((dCurrentVal > 97) && (dCurrentVal <= 125)) {
          cvCableSize = '22';
          dResistanceVal = 0.849;
        } else if ((dCurrentVal > 125) && (dCurrentVal <= 170)) {
          cvCableSize = '38';
          dResistanceVal = 0.491;
        } else if ((dCurrentVal > 170) && (dCurrentVal <= 215)) {
          cvCableSize = '60';
          dResistanceVal = 0.311;
        } else if ((dCurrentVal > 215) && (dCurrentVal <= 285)) {
          cvCableSize = '100';
          dResistanceVal = 0.187;
        } else if ((dCurrentVal > 285) && (dCurrentVal <= 360)) {
          cvCableSize = '150';
          dResistanceVal = 0.124;
        } else if ((dCurrentVal > 360) && (dCurrentVal <= 420)) {
          cvCableSize = '200';
          dResistanceVal = 0.093;
        } else if ((dCurrentVal > 420) && (dCurrentVal <= 470)) {
          cvCableSize = '250';
          dResistanceVal = 0.075;
        } else if ((dCurrentVal > 470) && (dCurrentVal <= 540)) {
          cvCableSize = '325';
          dResistanceVal = 0.058;
        } else if (dCurrentVal > 540) {
          cvCableSize = '要相談';
          dResistanceVal = 0;
        }
      } else if ((ddPhaseVal == '単相') && (dCosFai <= 1)) {
        // 単相の電流計算
        dCurrentVal = dElecOut / (dVolt * dCosFai);

        // JCMAのHPよりケーブル許容電流から600V CV-2Cケーブルの太さを選定
        // https://www.jcma2.jp/gijutsu/shiryou/index.html
        if (dCurrentVal <= 39) {
          cvCableSize = '2';
          dResistanceVal = 9.42;
        } else if ((dCurrentVal > 39) && (dCurrentVal <= 54)) {
          cvCableSize = '3.5';
          dResistanceVal = 5.3;
        } else if ((dCurrentVal > 54) && (dCurrentVal <= 69)) {
          cvCableSize = '5.5';
          dResistanceVal = 3.4;
        } else if ((dCurrentVal > 69) && (dCurrentVal <= 85)) {
          cvCableSize = '8';
          dResistanceVal = 3.4;
        } else if ((dCurrentVal > 85) && (dCurrentVal <= 115)) {
          cvCableSize = '14';
          dResistanceVal = 1.34;
        } else if ((dCurrentVal > 115) && (dCurrentVal <= 150)) {
          cvCableSize = '22';
          dResistanceVal = 0.849;
        } else if ((dCurrentVal > 150) && (dCurrentVal <= 205)) {
          cvCableSize = '38';
          dResistanceVal = 0.491;
        } else if ((dCurrentVal > 205) && (dCurrentVal <= 260)) {
          cvCableSize = '60';
          dResistanceVal = 0.311;
        } else if ((dCurrentVal > 260) && (dCurrentVal <= 345)) {
          cvCableSize = '100';
          dResistanceVal = 0.187;
        } else if ((dCurrentVal > 345) && (dCurrentVal <= 435)) {
          cvCableSize = '150';
          dResistanceVal = 0.124;
        } else if ((dCurrentVal > 435) && (dCurrentVal <= 505)) {
          cvCableSize = '200';
          dResistanceVal = 0.093;
        } else if ((dCurrentVal > 505) && (dCurrentVal <= 570)) {
          cvCableSize = '250';
          dResistanceVal = 0.075;
        } else if ((dCurrentVal > 570) && (dCurrentVal <= 650)) {
          cvCableSize = '325';
          dResistanceVal = 0.058;
        } else if (dCurrentVal > 650) {
          cvCableSize = '要相談';
          dResistanceVal = 0;
        }
      }

      // 電流値小数点の長さ固定して文字列に変換
      currentVal = dCurrentVal.toStringAsFixed(1);

      // 電圧降下計算
      // 今回はケーブル長が短いものとして、抵抗と電流のみで計算
      double dVoltDrop = dResistanceVal * dCurrentVal * dLen;
      voltDropVal = dVoltDrop.toStringAsFixed(1);

      // 電力損失計算
      // 今回はケーブル長が短いものとして、抵抗と電流のみで計算
      double dPowLoss = dResistanceVal * dResistanceVal * dCurrentVal * dLen;
      powLossVal = dPowLoss.toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          const Text('\n計算条件\n'),
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
              ]),
          Expanded(
            child: TextField(
              controller: _elecOutController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: '電気容量[W]\n(整数)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _voltController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: '線間電圧[V]\n(整数)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _cosFaiController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: '力率[%]\n(整数)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _lenController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'ケーブル長さ[m]\n(整数)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          const Text('\n\n'),
          ElevatedButton(
            onPressed: _calcRun,
            child: const Text('計算実行'),
          ),
          const Text('\n\n計算結果\n\n'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('電流  :  '),
              Text(currentVal),
              const Text('  [A]'),
            ],
          ),
          const Text('\n'),
          Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              const TableRow(
                children: <Widget>[
                  Center(child: Text('CVケーブル[mm2]')),
                  Center(child: Text('電圧降下[V]')),
                  Center(child: Text('ケーブル電力損失[W]')),
                ],
              ),
              TableRow(
                children: <Widget>[
                  Center(child: Text(cvCableSize)),
                  Center(child: Text(voltDropVal)),
                  Center(child: Text(powLossVal)),
                ],
              ),
            ],
          ),
          const Text('\n\n\n'),
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
              title: const Text('設定'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()));
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
              title: const Text('About App'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定ページ"),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('このページは設定ページです。'),
            const Text('ケーブルの許容電流の設定を行えるようにする予定です。'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ]),
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('ここでは計算の方法を紹介します。\n'),
            const Text('単相の場合\n   電流I = 電力P / (電圧V * 力率cosφ)'),
            const Text('三相の場合\n   電流I = 電力P / (√3 * 電圧V * 力率cosφ)'),
            const Text('\nケーブルサイズは流れる電流が許容電流より小さくなるサイズの最小値を選定'),
            const Text('\n電圧降下と電力損失は選定されたケーブルの単位長あたりの抵抗とケーブル長さから抵抗値Rを求め'),
            const Text('   ケーブルの電圧降下ΔV = 電流I * ケーブルの抵抗値R'),
            const Text('   ケーブルの電力損失Pl = 電流I * 電流I * ケーブルの抵抗値R'),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: const Text('Go back!'),
            // ),
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
        title: const Text("About App"),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('このアプリは作業現場での確認やすぐに電圧降下、電力損失を計算したい時に使用できます。'),
            const Text('なお、多くの個数の計算をする時は不向きです。'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ]),
    );
  }
}
