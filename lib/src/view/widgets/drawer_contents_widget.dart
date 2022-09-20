import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:elec_facility_calc/src/view/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void toPagePush(BuildContext context, String pagename, dynamic toPage) {
    /// ページ遷移のanalytics
    AnalyticsService().logPage(pagename);

    /// もとのページを削除し、トップページにプッシュしてから予定のページへプッシュ
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PageNameEnum.toppage.page,
      ),
      (_) => false,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => toPage),
    );
  }

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
            // Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => PageNameEnum.toppage.page,
              ),
              (route) => false,
            );
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
            // /// ページ遷移のanalytics
            // AnalyticsService().logPage(PageNameEnum.cableDesign.title);

            // Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const CalcCableDesignPage(),
            //   ),
            // );
            toPagePush(
              context,
              PageNameEnum.cableDesign.title,
              PageNameEnum.cableDesign.page,
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
            // /// ページ遷移のanalytics
            // AnalyticsService().logPage(PageNameEnum.elecPower.title);

            // Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const CalcElecPowerPage(),
            //   ),
            // );
            toPagePush(
              context,
              PageNameEnum.elecPower.title,
              PageNameEnum.elecPower.page,
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
            // /// ページ遷移のanalytics
            // AnalyticsService().logPage(PageNameEnum.conduit.title);

            // Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const CalcConduitPage(),
            //   ),
            // );
            toPagePush(
              context,
              PageNameEnum.conduit.title,
              PageNameEnum.conduit.page,
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
            // /// ページ遷移のanalytics
            // AnalyticsService().logPage(PageNameEnum.wiring.title);

            // Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const WiringListPage(),
            //   ),
            // );
            toPagePush(
              context,
              PageNameEnum.wiring.title,
              PageNameEnum.wiring.page,
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
            // /// ページ遷移のanalytics
            // AnalyticsService().logPage(PageNameEnum.setting.title);

            // // Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const SettingPage(),
            //   ),
            // );
            toPagePush(
              context,
              PageNameEnum.setting.title,
              PageNameEnum.setting.page,
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
            /// ページ遷移のanalytics
            AnalyticsService().logPage('計算方法');

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
            // /// ページ遷移のanalytics
            // AnalyticsService().logPage(PageNameEnum.about.title);

            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const AboutPage()));
            toPagePush(
              context,
              PageNameEnum.about.title,
              PageNameEnum.about.page,
            );
          },
        ),
      ],
    );
  }
}
