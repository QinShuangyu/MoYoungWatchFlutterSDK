import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BodyTemperaturePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BodyTemperaturePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BodyTemperaturePage> createState() {
    return _BodyTemperaturePage();
  }
}

class _BodyTemperaturePage extends State<BodyTemperaturePage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _enable = false;
  double _temp = -1.0;
  bool _state = false;
  TempInfo? _tempInfo;
  String _tempTimeType = "";
  int _startTime = -1;
  List<double> _tempList = [];
  String _timingMeasureTempState = '';

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.tempChangeEveStm.listen(
        (TempChangeBean event) {
          setState(() {
            switch (event.type) {
              case TempChangeType.continueState:
                _enable = event.enable!;
                break;
              case TempChangeType.measureTemp:
                _temp = event.temp!;
                break;
              case TempChangeType.measureState:
                _state = event.state!;
                break;
              case TempChangeType.continueTemp:
                _tempInfo = event.tempInfo;
                _tempTimeType = _tempInfo!.tempTimeType!;
                _startTime = _tempInfo!.startTime!;
                _tempList = _tempInfo!.tempList!;
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
              title: const Text("Body Temperature"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("enable: $_enable"),
              Text("temp: $_temp"),
              Text("state: $_state"),
              Text("tempTimeType: $_tempTimeType"),
              Text("startTime: $_startTime"),
              Text("tempList: $_tempList"),
              Text("timingMeasureTempState: $_timingMeasureTempState"),

              ElevatedButton(
                  onPressed: () => widget.blePlugin.startMeasureTemp,
                  child: const Text("startMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.stopMeasureTemp,
                  child: const Text("stopMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.enableTimingMeasureTemp,
                  child: const Text("enableTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.disableTimingMeasureTemp,
                  child: const Text("disableTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () async {
                    String timingMeasureTempState = await widget.blePlugin.queryTimingMeasureTempState;
                    setState(() {
                      _timingMeasureTempState = timingMeasureTempState;
                    });
                  },
                  child: const Text("queryTimingMeasureTempState()")),
              ElevatedButton(
                  onPressed: () =>
                      widget.blePlugin.queryTimingMeasureTemp(TempTimeType.yesterday),
                  child: const Text("queryTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () =>
                      widget.blePlugin.queryTimingMeasureTemp(TempTimeType.today),
                  child: const Text("queryTimingMeasureTemp()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.enableContinueTemp,
                  child: const Text("enableContinueTemp")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.disableContinueTemp,
                  child: const Text("disableContinueTemp")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.queryContinueTempState,
                  child: const Text("queryContinueTempState")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.queryLast24HourTemp,
                  child: const Text("queryLast24HourTemp")),
            ])
            )
        )
    );
  }
}
