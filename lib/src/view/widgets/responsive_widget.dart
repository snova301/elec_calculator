import 'package:elec_facility_calc/src/view/widgets/drawer_contents_widget.dart';
import 'package:flutter/material.dart';

/// 画面幅が規定以上でメニューを固定
class DrawerContentsFixed extends StatelessWidget {
  const DrawerContentsFixed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Row(
      children: [
        SizedBox(
          width: 230,
          child: ListView(
            controller: scrollController,
            children: const [
              DrawerContentsListTile(
                fontSize: 13,
              ),
            ],
          ),
        ),
        const VerticalDivider()
      ],
    );
  }
}

/// レスポンシブ対応のための判定
bool checkResponsive(double screenWidth) {
  const widthBreakpoint = 700;

  if (screenWidth > widthBreakpoint) {
    return true;
  }
  return false;
}
