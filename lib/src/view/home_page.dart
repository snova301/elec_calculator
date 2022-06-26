import 'package:elec_facility_calc/src/view/common_page.dart';
import 'package:elec_facility_calc/src/view/wiring_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/view/calc_page.dart';
import 'package:elec_facility_calc/src/view/about_page.dart';
import 'package:elec_facility_calc/src/view/setting_page.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('電気設備計算アシスタント'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _PagePush(
                  title: '計算画面へ',
                  pagepush: CalcPage(),
                  isCulcPage: true,
                ),
                _PagePush(
                  title: 'ケーブルリスト',
                  pagepush: WiringListPage(),
                  isCulcPage: true,
                ),
                _PagePush(
                  title: '設定',
                  pagepush: SettingPage(),
                  isCulcPage: false,
                ),
                _PagePush(
                  title: 'About',
                  pagepush: AboutPage(),
                  isCulcPage: false,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'ご利用は利用規約とプライバシーポリシーに同意したものとします。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
      drawer: const DrawerContents(),
    );
  }
}

/// 各ページへの遷移
class _PagePush extends ConsumerWidget {
  final String title;
  final dynamic pagepush;
  final bool isCulcPage;

  const _PagePush({
    Key? key,
    required this.title,
    required this.pagepush,
    required this.isCulcPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        // padding: const EdgeInsets.all(10),
        margin: isCulcPage ? const EdgeInsets.all(15) : const EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => pagepush),
            );
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              isCulcPage
                  ? const EdgeInsets.fromLTRB(20, 40, 20, 40)
                  : const EdgeInsets.fromLTRB(20, 20, 20, 20),
            ),
            backgroundColor:
                MaterialStateProperty.all(isCulcPage ? null : Colors.grey[800]),
          ),
          child: Text(title),
        ),
      ),
    );
  }
}
