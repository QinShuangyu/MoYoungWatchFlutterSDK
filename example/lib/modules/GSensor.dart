import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class GSensorPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const GSensorPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GSensorPage();
  }
}

class _GSensorPage extends State<GSensorPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("GSensor"),
        ),
        body: Center(
          child: ListView(children: <Widget>[
            ElevatedButton(
                onPressed: () => widget.blePlugin.sendGsensorCalibration,
                child: const Text("sendGsensorCalibration")
            )
          ]),
        ),
      ),
    );
  }
}
