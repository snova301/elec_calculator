import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elec_facility_calc/src/view/about_page.dart';
import 'package:elec_facility_calc/src/view/calc_page.dart';
import 'package:elec_facility_calc/src/view/home_page.dart';
import 'package:elec_facility_calc/src/view/setting_page.dart';

/// ドロワーの中身
class DrawerContents extends StatelessWidget {
  const DrawerContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()));
            },
          ),
          ListTile(
            title: const Text('計算画面'),
            leading: const Icon(Icons.calculate),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CalcPage()));
            },
          ),
          ListTile(
            title: const Text('配線リスト画面'),
            leading: const Icon(Icons.calculate),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CalcPage()));
            },
          ),
          ListTile(
            title: const Text('設定'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
          ),
          ListTile(
            title: const Text('計算方法'),
            leading: const Icon(Icons.architecture),
            trailing: const Icon(Icons.open_in_browser),
            onTap: () {
              openUrl(
                  'https://snova301.github.io/AppService/elec_calculator/method.html');
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
        ],
      ),
    );
  }
}

/// snackbarで注意喚起を行うWidget
class SnackBarAlert extends SnackBar {
  final String title;
  SnackBarAlert({Key? key, required this.title})
      : super(
          key: key,
          content: Text(title),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: const Duration(milliseconds: 2000),
        );
}

/// URLを開く関数
void openUrl(urlname) async {
  final Uri url = Uri.parse(urlname);
  if (!await launchUrl(url)) throw 'Could not launch $url';
}
