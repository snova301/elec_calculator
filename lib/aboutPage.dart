import 'package:elec_facility_calc/homePage.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          _LinkCard(context, '使い方',
              'https://snova301.github.io/AppService/elec_calculator/howtouse.html'),
          _LinkCard(context, '利用規約',
              'https://snova301.github.io/AppService/common/terms.html'),
          _LinkCard(context, 'プライバシーポリシー',
              'https://snova301.github.io/AppService/common/privacypolicy.html'),
        ],
      ),
    );
  }
}

class _LinkCard extends Card {
  _LinkCard(BuildContext context, String urlTitle, String urlName)
      : super(
          child: ListTile(
            title: Text(urlTitle),
            subtitle: Text(urlTitle + 'のwebページへ移動します。'),
            contentPadding: const EdgeInsets.all(10),
            onTap: () => launch_Url(urlName),
            trailing: const Icon(Icons.open_in_browser),
          ),
        );
}




///
