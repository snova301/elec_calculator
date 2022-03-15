import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: const Text('ダークモード'),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () => ref.read(counterProvider.state).state == false
                    ? ref.read(counterProvider.state).state = true
                    : ref.read(counterProvider.state).state = true,
                child: const Text('Dark'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black87),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () => ref.read(counterProvider.state).state == true
                    ? ref.read(counterProvider.state).state = false
                    : ref.read(counterProvider.state).state = false,
                child: const Text('Light'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
