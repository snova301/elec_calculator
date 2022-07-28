import 'package:elec_facility_calc/src/view/calc_cable_design_page.dart';
import 'package:elec_facility_calc/src/view/calc_conduit_page.dart';
import 'package:elec_facility_calc/src/view/calc_elec_power_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/model/data_class.dart';
import 'package:elec_facility_calc/src/view/about_page.dart';
import 'package:elec_facility_calc/src/view/setting_page.dart';
import 'package:elec_facility_calc/src/view/common_page.dart';
import 'package:elec_facility_calc/src/view/wiring_list_page.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 画面情報
    final screenWidth = MediaQuery.of(context).size.width;

    /// 個数設定
    int crossAxisCountNum = 2;
    if (screenWidth > 600 && screenWidth < 1100) {
      crossAxisCountNum = 3;
    } else if (screenWidth > 1100) {
      crossAxisCountNum = 4;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('電気設備計算アシスタント'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: crossAxisCountNum,
              padding:
                  EdgeInsets.fromLTRB(screenWidth / 6, 80, screenWidth / 6, 80),
              children: <Widget>[
                _PagePush(
                  title: PageNameEnum.cableDesign.title,
                  pagepush: const CalcCableDesignPage(),
                  backGroundColor: Colors.green,
                  textColor: Colors.white,
                  icon: PageNameEnum.cableDesign.icon,
                ),
                _PagePush(
                  title: PageNameEnum.elecPower.title,
                  pagepush: const CalcElecPowerPage(),
                  backGroundColor: Colors.green,
                  textColor: Colors.white,
                  icon: PageNameEnum.elecPower.icon,
                ),
                _PagePush(
                  title: PageNameEnum.conduit.title,
                  pagepush: const CalcConduitPage(),
                  backGroundColor: Colors.green,
                  textColor: Colors.white,
                  icon: PageNameEnum.conduit.icon,
                ),
                _PagePush(
                  title: PageNameEnum.wiring.title,
                  pagepush: const WiringListPage(),
                  backGroundColor: Colors.green,
                  textColor: Colors.white,
                  icon: PageNameEnum.wiring.icon,
                ),
                _PagePush(
                  title: PageNameEnum.setting.title,
                  pagepush: const SettingPage(),
                  icon: PageNameEnum.setting.icon,
                ),
                _PagePush(
                  title: PageNameEnum.about.title,
                  pagepush: const AboutPage(),
                ),
              ],
            ),
          ),

          /// 同意文
          const _AgreementContainer()
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
  final Color? backGroundColor;
  final Color? textColor;
  final IconData? icon;

  const _PagePush({
    Key? key,
    required this.title,
    required this.pagepush,
    this.backGroundColor,
    this.textColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: backGroundColor,
      elevation: 2,
      child: InkWell(
        onTap: () {
          /// ページ遷移
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pagepush),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: icon == null
              ? [
                  Text(
                    title,
                    style: TextStyle(color: textColor),
                  )
                ]
              : [
                  Icon(
                    icon,
                    size: 40,
                    color: textColor,
                  ),
                  Text(
                    title,
                    style: TextStyle(color: textColor),
                  ),
                ],
        ),
      ),
    );
  }
}

/// 同意文のwidget
class _AgreementContainer extends ConsumerWidget {
  const _AgreementContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10),

      //  Container(
      //   padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'ご利用は',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          TextButton(
            onPressed: () {
              openUrl(
                  'https://snova301.github.io/AppService/common/terms.html');
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all(Size.zero),
            ),
            child: const Text(
              '利用規約',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.blue),
            ),
          ),
          const Text(
            'と',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          TextButton(
            onPressed: () {
              openUrl(
                  'https://snova301.github.io/AppService/common/privacypolicy.html');
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all(Size.zero),
            ),
            child: const Text(
              'プライバシーポリシー',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.blue),
            ),
          ),
          const Text(
            'に同意したものとします。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
