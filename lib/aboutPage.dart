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
        Text('【本アプリについて】'),
        Text('本アプリは電気設備設計時に必要な計算ツールを提供します。'),
        Text('作業現場での確認やすぐに電圧降下、電力損失を計算するための強力なツールです。'),
        Text('広告はありますが、全ての機能を無料で使用できます。'),
        Text('\n【免責事項】'),
        Text('本アプリで計算された結果は実測値を保証するものではありません。'),
        Text('本アプリの利用によって生じた損害は、製作者または配信者はその責任を負いません。'),
        // const Text('\n【プライバシーポリシー】'),
        // const Text('本アプリのプライバシーポリシーは以下のサイトに記載しております。'),
        // const Text('http\n'),
      ]),
    );
  }
}
