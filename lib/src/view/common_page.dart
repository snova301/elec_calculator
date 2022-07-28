import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elec_facility_calc/src/view/about_page.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';
import 'package:elec_facility_calc/src/view/calc_cable_design_page.dart';
import 'package:elec_facility_calc/src/view/calc_conduit_page.dart';
import 'package:elec_facility_calc/src/view/calc_elec_power_page.dart';
import 'package:elec_facility_calc/src/view/wiring_list_page.dart';
import 'package:elec_facility_calc/src/view/setting_page.dart';

/// ドロワーの中身
class DrawerContents extends ConsumerWidget {
  const DrawerContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          const DrawerContentsListTile()
        ],
      ),
    );
  }
}

class DrawerContentsListTile extends ConsumerWidget {
  /// Drawer固定ならfontsizeを小さくする
  final double fontSize;

  const DrawerContentsListTile({
    Key? key,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        /// トップページへ
        ListTile(
          title: Text(
            PageNameEnum.toppage.title,
            style: TextStyle(fontSize: fontSize),
          ),
          leading: Icon(PageNameEnum.toppage.icon),
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),

        /// ケーブル設計画面へ
        ListTile(
          title: Text(
            PageNameEnum.cableDesign.title,
            style: TextStyle(fontSize: fontSize),
          ),
          leading: Icon(PageNameEnum.cableDesign.icon),
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalcCableDesignPage(),
              ),
            );
          },
        ),

        /// 電力計算画面へ
        ListTile(
          title: Text(
            PageNameEnum.elecPower.title,
            style: TextStyle(fontSize: fontSize),
          ),
          leading: Icon(PageNameEnum.elecPower.icon),
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalcElecPowerPage(),
              ),
            );
          },
        ),

        /// 電線管設計画面へ
        ListTile(
          title: Text(
            PageNameEnum.conduit.title,
            style: TextStyle(fontSize: fontSize),
          ),
          leading: Icon(PageNameEnum.conduit.icon),
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalcConduitPage(),
              ),
            );
          },
        ),

        /// 配線リスト画面へ
        ListTile(
          title: Text(
            PageNameEnum.wiring.title,
            style: TextStyle(fontSize: fontSize),
          ),
          leading: Icon(PageNameEnum.wiring.icon),
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WiringListPage(),
              ),
            );
          },
        ),

        /// 設定画面へ
        ListTile(
          title: Text(
            PageNameEnum.setting.title,
            style: TextStyle(fontSize: fontSize),
          ),
          leading: Icon(PageNameEnum.setting.icon),
          onTap: () {
            // Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingPage(),
              ),
            );
          },
        ),

        /// 計算方法リンク
        ListTile(
          title: Text(
            '計算方法',
            style: TextStyle(fontSize: fontSize),
          ),
          // leading: const Icon(Icons.architecture),
          trailing: const Icon(Icons.open_in_browser),
          onTap: () {
            openUrl(
                'https://snova301.github.io/AppService/elec_calculator/method.html');
          },
        ),

        /// About
        ListTile(
          title: Text(
            PageNameEnum.about.title,
            style: TextStyle(fontSize: fontSize),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutPage()));
          },
        ),
      ],
    );
  }
}

/// 画面幅が規定以上でメニューを固定
class DrawerContentsFixed extends StatelessWidget {
  const DrawerContentsFixed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(
          width: 230,
          child: DrawerContentsListTile(
            fontSize: 13,
          ),
        ),
        VerticalDivider()
      ],
    );
  }
}

/// snackbarで注意喚起を行うWidget
class SnackBarAlert {
  final BuildContext context;
  SnackBarAlert({Key? key, required this.context}) : super();

  void snackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // key: key,
        content: Text(
          message,
          // textAlign: TextAlign.center,
          // style: TextStyle(
          //   color: Colors.white,
          // ),
        ),
        // backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
}

/// URLを開く関数
void openUrl(urlname) async {
  final Uri url = Uri.parse(urlname);
  try {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    throw 'Could not launch $url';
  }
  // if (!await launchUrl(url, mode: LaunchMode.externalApplication))
  //   throw 'Could not launch $url';
}

/// レスポンシブ対応のための判定
bool checkResponsive(double screenWidth) {
  const widthBreakpoint = 700;

  if (screenWidth > widthBreakpoint) {
    return true;
  }
  return false;
}
