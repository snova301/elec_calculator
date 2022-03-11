import 'package:flutter/material.dart';
import 'main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SettingPage> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  bool boolThemeColor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        SwitchListTile(
          title: const Text('ダークモード'),
          value: boolThemeColor,
          onChanged: (bool value) {
            setState(() {
              boolThemeColor = value;
            });
          },
          secondary: const Icon(Icons.lightbulb_outline),
        ),
      ]),
    );
  }
}
