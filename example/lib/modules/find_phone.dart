import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

class FindPhonePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const FindPhonePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<FindPhonePage> createState() {
    return _FindPhonePage();
  }
}

class _FindPhonePage extends State<FindPhonePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Find Phone"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () => widget.blePlugin.startFindPhone,
                  child: const Text('startFindPhone()')),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.stopFindPhone,
                  child: const Text("stopFindPhone()")),
            ])
            )
        )
    );
  }
}
