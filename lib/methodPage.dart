import 'package:flutter/material.dart';

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
        const Text('- JCMA, 低圧ケーブルの許容電流表 (1989)\n\n'),
        // URL : https://www.jcma2.jp/gijutsu/shiryou/index.html
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('戻る'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
          ),
        ),
      ]),
    );
  }
}
