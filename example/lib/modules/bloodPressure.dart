import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BloodPressurePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BloodPressurePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<BloodPressurePage> createState() {
    return _BloodPressurePage();
  }
}

class _BloodPressurePage extends State<BloodPressurePage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _continueState = false;
  BloodPressureChangeBean? _bean;
  int _systolicBloodPressure = -1;
  int _diastolicBloodPressure = -1;
  List<HistoryBloodPressureBean> _historyBpList = [];
  BloodPressureInfo? info;
  int _startTime = -1;
  int _timeInterval = -1;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.bloodPressureEveStm.listen(
        (BloodPressureBean event) {
          setState(() {
            switch (event.type) {
              case BloodPressureType.continueState:
                _continueState = event.continueState!;
                break;
              case BloodPressureType.pressureChange:
                _bean = event.pressureChange!;
                _systolicBloodPressure = _bean!.sbp!;
                _diastolicBloodPressure = _bean!.dbp!;
                break;
              case BloodPressureType.historyList:
                _historyBpList = event.historyBpList!;
                break;
              case BloodPressureType.continueBP:
                info = event.continueBp!;
                _startTime = info!.startTime!;
                _timeInterval = info!.timeInterval!;
                break;
              default:
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
              title: const Text("Blood Pressure"),
            ),
            body: Center(child: ListView(children: [
              Text("continueState: $_continueState"),
              Text("systolicBloodPressure: $_systolicBloodPressure"),
              Text("diastolicBloodPressure: $_diastolicBloodPressure"),
              Text("historyBpList[0]: $_historyBpList"),
              Text("startTime: $_startTime"),
              Text("timeInterval: $_timeInterval"),

              ElevatedButton(
                  child: const Text('startMeasureBloodPressure'),
                  onPressed: () => widget.blePlugin.startMeasureBloodPressure),
              ElevatedButton(
                  child: const Text('stopMeasureBloodPressure'),
                  onPressed: () => widget.blePlugin.stopMeasureBloodPressure),
              ElevatedButton(
                  child: const Text('enableContinueBloodPressure'),
                  onPressed: () => widget.blePlugin.enableContinueBloodPressure),
              ElevatedButton(
                  child: const Text('disableContinueBloodPressure'),
                  onPressed: () => widget.blePlugin.disableContinueBloodPressure),
              ElevatedButton(
                  child: const Text('queryContinueBloodPressureState'),
                  onPressed: () => widget.blePlugin.queryContinueBloodPressureState),
              ElevatedButton(
                  child: const Text('queryLast24HourBloodPressure'),
                  onPressed: () => widget.blePlugin.queryLast24HourBloodPressure),
              ElevatedButton(
                  child: const Text('queryHistoryBloodPressure'),
                  onPressed: () => widget.blePlugin.queryHistoryBloodPressure),
            ])
            )
        )
    );
  }
}
