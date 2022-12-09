import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class SOSPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const SOSPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SOSPage();
  }
}

class _SOSPage extends State<SOSPage> {

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.sosChangeEveStm.listen(
            (dynamic event) {

            },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SOS"),
        ),
        body: Center(
          child: ListView(children: <Widget>[
          ]),
        ),
      ),
    );
  }
}
