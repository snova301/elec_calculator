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
      title: 'Electricity Calclator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Electricity Calclator'),
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
  var _elecOutController = TextEditingController();
  var _cosFaiController = TextEditingController();
  var _voltController = TextEditingController();
  var _lenController = TextEditingController();

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
        // 小数点の長さ固定して文字列に変換
        currentVal = dCurrentVal.toStringAsFixed(1);

        // 昭和電線のHPよりケーブル許容電流から600V CV-3Cケーブルの太さを選定
        // 昭和電線のHPはJCS 0168-2から値を取得
        if (dCurrentVal <= 32.0) {
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
        // 小数点の長さ固定して文字列に変換
        currentVal = dCurrentVal.toStringAsFixed(1);

        // 昭和電線のHPよりケーブル許容電流からCV-2Cケーブルの太さを選定
        // 昭和電線のHPはJCS 0168-2から値を取得
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
              decoration: const InputDecoration(
                labelText: '電気容量[W]　(整数)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _voltController,
              decoration: const InputDecoration(
                labelText: '線間電圧[V]　(整数)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _cosFaiController,
              decoration: const InputDecoration(
                labelText: '力率[%]　(整数)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _lenController,
              decoration: const InputDecoration(
                labelText: 'ケーブル長さ[m]　(整数)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text('電流[A]'),
                Text(currentVal),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text('CVケーブル[mm^2]'),
                Text(cvCableSize),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text('電圧降下[V]'),
                Text(voltDropVal),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text('ケーブル電力損失[W]'),
                Text(powLossVal),
              ]),
          ElevatedButton(
            onPressed: _calcRun,
            child: const Text('計算実行'),
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
              title: const Text('About Apps'),
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
        title: const Text("Second Route"),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            const Text('このページは設定ページです。'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ])),
    );
  }
}

class MethodPage extends StatelessWidget {
  const MethodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Method Route"),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            const Text('ここでは計算の方法を紹介します。'),
            const Text('参考までに難易度は第3種電気主任技術者の試験レベルです。'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ])),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Route"),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            const Text('このアプリは作業現場での確認やすぐに電圧降下、電力損失を計算したい時に使用できます。'),
            const Text('なお、多くの個数の計算をする時は不向きです。'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ])),
    );
  }
}
