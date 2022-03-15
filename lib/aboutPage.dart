import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: const <Widget>[
        Text(
            '【本アプリについて】\n本アプリは電気設備設計時に必要な計算ツールを提供します。\n作業現場での確認やすぐに電圧降下、電力損失を計算するための強力なツールです。'),
        Text(
            '\n【免責事項】\n本アプリで計算された結果は実測値を保証するものではありません。\n本アプリの利用によって生じた損害は、製作者または配信者はその責任を負いません。'),
        Text(
            '\n【使用上の注意】\n本アプリを利用し、法律に違反することを禁止します。\n本アプリの製作者、利用者、その他第3者の権利を侵害、制限、妨害することを禁止します。\nこの他、製作者が不適切と判断した行為も禁止します。'),
        Text(
            '\n【プライバシーポリシー】\n本アプリのプライバシーポリシーは以下のサイトに記載しております。\n  https://snova301.github.io/AppService/elec_calculator/privacypolicy.html'),
      ]),
    );
  }
}
