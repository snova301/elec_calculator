import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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
              children: [
                _HomePagePush(context, '計算画面へ', const CalcPage(), true),
                _HomePagePush(context, '設定', const SettingPage(), false),
                _HomePagePush(context, 'About', const AboutPage(), false),
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
      drawer: DrawerContents(context),
    );
  }
}

class _HomePagePush extends Align {
  _HomePagePush(BuildContext context, String title, pagepush, bool isCulcPage)
      : super(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            // padding: const EdgeInsets.all(10),
            margin:
                isCulcPage ? const EdgeInsets.all(15) : const EdgeInsets.all(5),
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
                backgroundColor: MaterialStateProperty.all(
                    isCulcPage ? null : Colors.grey[800]),
              ),
              child: Text(title),
            ),
          ),
        );
}

class DrawerContents extends Drawer {
  DrawerContents(BuildContext context)
      : super(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('メニューを閉じる'),
                leading: const Icon(Icons.close),
                onTap: () {
                  Navigator.pop(context);
                },
                contentPadding: const EdgeInsets.fromLTRB(16, 35, 16, 15),
              ),
              const Divider(),
              ListTile(
                title: const Text('トップページ'),
                leading: const Icon(Icons.home_rounded),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                },
              ),
              ListTile(
                title: const Text('計算画面'),
                leading: const Icon(Icons.calculate),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CalcPage()));
                },
              ),
              ListTile(
                title: const Text('設定'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingPage()));
                },
              ),
              ListTile(
                title: const Text('計算方法'),
                leading: const Icon(Icons.architecture),
                trailing: const Icon(Icons.open_in_browser),
                onTap: () {
                  launch_url(
                      'https://snova301.github.io/AppService/elec_calculator/method.html');
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
        );
}

void launch_url(urlname) async {
  final Uri url = Uri.parse(urlname);
  if (!await launchUrl(url)) throw 'Could not launch $url';
}
