import 'package:elec_facility_calc/ads_options.dart';
import 'package:elec_facility_calc/src/model/enum_class.dart';
import 'package:elec_facility_calc/src/view/widgets/drawer_contents_widget.dart';
import 'package:elec_facility_calc/src/view/widgets/link_card_widget.dart';
import 'package:elec_facility_calc/src/view/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowLawPage extends ConsumerWidget {
  const ShowLawPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 画面情報
    final screenWidth = MediaQuery.of(context).size.width;

    /// レスポンシブ設定
    bool isDrawerFixed = checkResponsive(screenWidth);

    /// 広告の初期化
    AdsSettingsClass().initRecBanner();

    return Scaffold(
      appBar: AppBar(
        title: Text(PageNameEnum.showLaw.title),
      ),
      body: Row(
        children: [
          /// 画面幅が規定以上でメニューを左側に固定
          isDrawerFixed ? const DrawerContentsFixed() : Container(),

          /// サイズ指定されていないとエラーなのでExpandedで囲む
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  screenWidth / 10, 20, screenWidth / 10, 20),
              //  const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: const Text(
                    'e-Gov法令検索のサイトへのリンクです。',
                  ),
                ),
                const LinkCard(
                  urlTitle: '消防法',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=323AC1000000186_20210901_503AC0000000036',
                  // cardColor: Colors.orange,
                  // fontColor: Colors.white,
                ),
                const LinkCard(
                  urlTitle: '消防法施行令',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=336CO0000000037',
                  // cardColor: Colors.orange,
                  // fontColor: Colors.white,
                ),
                const LinkCard(
                  urlTitle: '消防法施行規則',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=336M50000008006',
                  // cardColor: Colors.orange,
                  // fontColor: Colors.white,
                ),

                /// 広告表示
                existAds ? const RecBannerContainer() : Container(),
              ],
            ),
          ),
        ],
      ),

      /// ドロワー
      drawer: const DrawerContents(),
    );
  }
}
