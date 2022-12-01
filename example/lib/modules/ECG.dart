import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ECGPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ECGPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ECGPage> createState() {
    return _ECGPage();
  }
}

class _ECGPage extends State<ECGPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<int> _ints = [];
  String _date = "";
  bool _isNewECGMeasurementVersion = true;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.ecgEveStm.listen(
            (EcgBean event) {
          setState(() {
            switch(event.type){
              case ECGType.ecgChangeInts:
                _ints = event.ints!;
                break;
              case ECGType.measureComplete:
                break;
              case ECGType.date:
                _date = event.date!;
                break;
              case ECGType.cancel:
                break;
              case ECGType.fail:
                break;
            }
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
              title: const Text("ECG"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("ints: $_ints"),
              Text("date: $_date"),
              Text("isNewECGMeasurementVersion: $_isNewECGMeasurementVersion"),

              ElevatedButton(
                  child: const Text('setECGChangeListener()'),
                  onPressed: () => widget.blePlugin.setECGChangeListener(EcgMeasureType.ti)),
              ElevatedButton(
                  child: const Text('startECGMeasure'),
                  onPressed: () => widget.blePlugin.startECGMeasure),
              ElevatedButton(
                  child: const Text('stopECGMeasure'),
                  onPressed: () => widget.blePlugin.stopECGMeasure),
              ElevatedButton(
                  child: const Text('isNewECGMeasurementVersion'),
                  onPressed: () async {
                    bool isNewECGMeasurementVersion = await widget.blePlugin.isNewECGMeasurementVersion;
                    setState(() {
                      _isNewECGMeasurementVersion = isNewECGMeasurementVersion;
                    });
                  }),
              ElevatedButton(
                  child: const Text('queryLastMeasureECGData'),
                  onPressed: () => widget.blePlugin.queryLastMeasureECGData),
              ElevatedButton(
                  child: const Text('sendECGHeartRate'),
                  onPressed: () => widget.blePlugin.sendECGHeartRate(78)),
            ])
            )
        )
    );
  }
}
