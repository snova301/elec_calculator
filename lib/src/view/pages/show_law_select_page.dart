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
                  urlTitle: '電気事業法',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=339AC0000000170',
                ),
                const LinkCard(
                  urlTitle: '電気事業法施行令',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=340CO0000000206',
                ),
                const LinkCard(
                  urlTitle: '電気事業法施行規則',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=407M50000400077',
                ),
                const LinkCard(
                  urlTitle: '電気設備に関する技術基準を定める省令',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=409M50000400052',
                ),
                const LinkCard(
                  urlTitle: '電気関係報告規則',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=340M50000400054',
                ),
                const LinkCard(
                  urlTitle: '電気工事士法',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=335AC0000000139',
                ),
                const LinkCard(
                  urlTitle: '電気工事士法施行令',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=335CO0000000260',
                ),
                const LinkCard(
                  urlTitle: '電気工事士法施行規則',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=335M50000400097',
                ),
                const LinkCard(
                  urlTitle: '電気工事業の業務の適正化に関する法律',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=345AC1000000096',
                ),
                const LinkCard(
                  urlTitle: '電気工事業の業務の適正化に関する法律施行令',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=345CO0000000327',
                ),
                const LinkCard(
                  urlTitle: '電気工事業の業務の適正化に関する法律施行規則',
                  urlName:
                      'https://elaws.e-gov.go.jp/document?lawid=345M50000400103',
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
