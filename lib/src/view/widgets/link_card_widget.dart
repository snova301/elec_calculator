import 'package:elec_facility_calc/src/view/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

/// アプリ情報を載せたページへのリンク
class LinkCard extends StatelessWidget {
  final String urlTitle;
  final String urlName;

  const LinkCard({Key? key, required this.urlTitle, required this.urlName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(urlTitle),
        subtitle: Text('$urlTitleのwebページへ移動します。'),
        contentPadding: const EdgeInsets.all(10),
        onTap: () => openUrl(urlName),
        trailing: const Icon(Icons.open_in_browser),
      ),
    );
  }
}
