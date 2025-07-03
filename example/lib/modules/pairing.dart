import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class PaddingPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const PaddingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaddingPage();
  }
}

class _PaddingPage extends State<PaddingPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _bondState = -1;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.createBondEveStm.listen(
        (int event) {
          if (!mounted) return;
          setState(() {
            _bondState = event;
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
          title: const Text("Pairing"),
        ),
        body: Center(
          child: ListView(children: <Widget>[
            Text("key: $_bondState"),
            ElevatedButton(
                onPressed: () async {
                  await widget.blePlugin.createBond([1, 1, 1, 1, 1, 1]);
                },
                child: const Text("createBond")),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "When the watch firmware has a pairing code, only the Android end requires the following writing method.",
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
            ElevatedButton(
                onPressed: () async {
                  await widget.blePlugin.createBond(
                    [1, 1, 1, 1, 1, 1],
                    isBond: false,
                    pairingCode: 123456,
                  );
                },
                child: const Text("createBond(MultiP)")),
          ]),
        ),
      ),
    );
  }
}
