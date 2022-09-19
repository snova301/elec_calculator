import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:elec_facility_calc/src/view/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

/// 使い方やライセンスページをリンクするためのページ
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PageNameEnum.about.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          /// 各URLをオープン
          /// 使い方ページ
          const _LinkCard(
            urlTitle: '使い方',
            urlName: 'elec_calculator/howtouse.html',
          ),

          /// 利用規約ページ
          const _LinkCard(
            urlTitle: '利用規約',
            urlName: 'common/terms.html',
          ),

          /// プライバシーポリシーページ
          const _LinkCard(
            urlTitle: 'プライバシーポリシー',
            urlName: 'common/privacypolicy.html',
          ),

          /// お問い合わせフォーム
          Card(
            child: ListTile(
              title: const Text('お問い合わせ'),
              contentPadding: const EdgeInsets.all(10),
              onTap: () => openUrl('https://forms.gle/yBGDikXqZzWjco7z8'),
              trailing: const Icon(Icons.open_in_browser),
            ),
          ),

          /// 支援サイト
          // Card(
          //   child: ListTile(
          //     leading: const Icon(
          //       Icons.favorite_border,
          //       color: Colors.pink,
          //     ),
          //     title: const Text('開発を支援'),
          //     contentPadding: const EdgeInsets.all(10),
          //     onTap: () => openUrl('https://www.buymeacoffee.com/snova301'),
          //     trailing: const Icon(Icons.open_in_browser),
          //   ),
          // ),

          /// オープンソースライセンスの表示
          Card(
            child: ListTile(
              title: const Text('オープンソースライセンス'),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// アプリ情報を載せたページへのリンク
class _LinkCard extends StatelessWidget {
  final String urlTitle;
  final String urlName;

  const _LinkCard({Key? key, required this.urlTitle, required this.urlName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(urlTitle),
        subtitle: Text('$urlTitleのwebページへ移動します。'),
        contentPadding: const EdgeInsets.all(10),
        onTap: () => openUrl('https://snova301.github.io/AppService/$urlName'),
        trailing: const Icon(Icons.open_in_browser),
      ),
    );
  }
}
