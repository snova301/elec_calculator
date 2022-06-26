import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          /// メニューを閉じる
          ListTile(
            title: const Text('メニューを閉じる'),
            leading: const Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            },
            contentPadding: const EdgeInsets.fromLTRB(16, 35, 16, 15),
          ),

          /// 分割線
          const Divider(),

          /// トップページへ
          ListTile(
            title: const Text('トップページ'),
            leading: const Icon(Icons.home_rounded),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()));
            },
          ),

          /// 計算画面へ
          ListTile(
            title: const Text('計算画面'),
            leading: const Icon(Icons.calculate),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CalcPage()));
            },
          ),

          /// 配線リスト画面へ
          ListTile(
            title: const Text('配線リスト画面'),
            leading: const Icon(Icons.calculate),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CalcPage()));
            },
          ),

          /// 設定画面へ
          ListTile(
            title: const Text('設定'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
          ),

          /// 計算方法リンク
          ListTile(
            title: const Text('計算方法'),
            leading: const Icon(Icons.architecture),
            trailing: const Icon(Icons.open_in_browser),
            onTap: () {
              openUrl(
                  'https://snova301.github.io/AppService/elec_calculator/method.html');
            },
          ),

          /// About
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
/// [使い方]
/// ScaffoldMessenger.of(context).showSnackBar(
///   SnackBarAlert(title: 'これ以上追加できません'),
/// );

// class SnackBarAlert extends ConsumerStatefulWidget {
//   /// メッセージの内容
//   final String message;

//   const SnackBarAlert({Key? key, required this.message}) : super(key: key);

//   @override
//   SnackBarAlertState createState() => SnackBarAlertState();
// }

// class SnackBarAlertState extends ConsumerState<SnackBarAlert> {
//   @override
//   Widget build(BuildContext context) {
//     return SnackBar(
//       key: widget.key,
//       content: Text(widget.message),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       duration: const Duration(milliseconds: 2000),
//     );
//   }
// }

class SnackBarAlert extends SnackBar {
  final String message;
  SnackBarAlert({Key? key, required this.message})
      : super(
          key: key,
          content: Text(message),
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
