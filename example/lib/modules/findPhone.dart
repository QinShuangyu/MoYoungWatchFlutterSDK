import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

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

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.findPhoneEveStm.listen(
            (FindPhoneBean event) {
          switch (event.type) {
            case FindPhoneType.find:
              break;
            case FindPhoneType.complete:
              break;
          }
        },
      ),
    );
  }

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
