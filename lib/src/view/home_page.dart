import 'package:elec_facility_calc/src/model/data_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elec_facility_calc/src/view/calc_page.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('電気設備計算アシスタント'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(screenWidth / 5),
              children: <Widget>[
                _PagePush(
                  title: PageNameEnum.calc.title,
                  pagepush: const CalcPage(),
                  backGroundColor: Colors.green,
                  textColor: Colors.white,
                  icon: Icons.calculate,
                ),
                _PagePush(
                  title: PageNameEnum.wiring.title,
                  pagepush: const WiringListPage(),
                  backGroundColor: Colors.green,
                  textColor: Colors.white,
                  icon: Icons.list_alt,
                ),
                _PagePush(
                  title: PageNameEnum.setting.title,
                  pagepush: const SettingPage(),
                  // color: Colors.grey,
                  icon: Icons.settings,
                ),
                _PagePush(
                  title: PageNameEnum.about.title,
                  pagepush: const AboutPage(),
                  // color: Colors.grey,
                  // icon: Icons.calculate,
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
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'ご利用は',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey),
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
              style: TextStyle(fontSize: 11, color: Colors.blue),
            ),
          ),
          const Text(
            'と',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey),
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
              style: TextStyle(fontSize: 11, color: Colors.blue),
            ),
          ),
          const Text(
            'に同意したものとします。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
