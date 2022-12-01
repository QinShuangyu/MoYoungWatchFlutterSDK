import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class RSSIPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const RSSIPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<RSSIPage> createState() {
    return _RSSIPage();
  }
}

class _RSSIPage extends State<RSSIPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _deviceRssi = -1;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.deviceRssiEveStm.listen(
            (int event) {
          setState(() {
            _deviceRssi = event;
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
              title: const Text("RSSI"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("deviceRssi: $_deviceRssi"),

              ElevatedButton(
                  child: const Text('readDeviceRssi'),
                  onPressed: () => widget.blePlugin.readDeviceRssi),
            ])
            )
        )
    );
  }
}
