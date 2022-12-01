import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BatterySavingPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BatterySavingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BatterySavingPage> createState() {
    return _BatterySavingPage();
  }
}

class _BatterySavingPage extends State<BatterySavingPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _batterSaving = false;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.batterySavingEveStm.listen(
            (bool event) {
          setState(() {
            _batterSaving = event;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Battery Saving"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("batterSaving: $_batterSaving"),

              ElevatedButton(
                  onPressed: () => widget.blePlugin.sendBatterySaving(true),
                  child: const Text("sendBatterySaving(true)")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.sendBatterySaving(false),
                  child: const Text("sendBatterySaving(false)")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.queryBatterySaving,
                  child: const Text("queryBatterySaving()")),
            ])
            )
        )
    );
  }
}
