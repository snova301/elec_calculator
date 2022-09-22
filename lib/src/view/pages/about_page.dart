import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:elec_facility_calc/src/view/widgets/link_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 使い方やライセンスページをリンクするためのページ
class AboutPage extends ConsumerWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// リワード広告ユニットの初期化
    existAds ? ref.read(rewardedAdProvider.notifier).initRewarded() : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(PageNameEnum.about.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          /// 各URLをオープン
          /// 使い方ページ
          const LinkCard(
            urlTitle: '使い方',
            urlName:
                'https://snova301.github.io/AppService/elec_calculator/howtouse.html',
          ),

          /// 利用規約ページ
          const LinkCard(
            urlTitle: '利用規約',
            urlName: 'https://snova301.github.io/AppService/common/terms.html',
          ),

          /// プライバシーポリシーページ
          const LinkCard(
            urlTitle: 'プライバシーポリシー',
            urlName:
                'https://snova301.github.io/AppService/common/privacypolicy.html',
          ),

          /// お問い合わせフォーム
          const LinkCard(
            urlTitle: 'お問い合わせ',
            urlName: 'https://forms.gle/yBGDikXqZzWjco7z8',
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

          /// admobリワード広告
          existAds
              ? Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite_border,
                      // color: Colors.pink,
                    ),
                    title: const Text('広告を見て開発を支援'),
                    contentPadding: const EdgeInsets.all(10),
                    onTap: () {
                      /// 広告の表示
                      ref
                          .read(rewardedAdProvider.notifier)
                          .showRewardedAd(context);
                    },
                  ),
                )
              : Container(),

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
