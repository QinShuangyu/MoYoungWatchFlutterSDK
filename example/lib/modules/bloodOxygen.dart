import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class BloodOxygenPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const BloodOxygenPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<BloodOxygenPage> createState() {
    return _BloodOxygenPage();
  }
}

class _BloodOxygenPage extends State<BloodOxygenPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _continueState = false;
  int _timingMeasure = -1;
  int _bloodOxygen = -1;
  List<HistoryBloodOxygenBean> _historyList = [];
  BloodOxygenInfo? _continueBo;
  int _startTime = -1;
  int _timeInterval = -1;


  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.bloodOxygenEveStm.listen(
            (BloodOxygenBean event) {
          setState(() {
            switch (event.type) {
              case BloodOxygenType.continueState:
                _continueState = event.continueState!;
                break;
              case BloodOxygenType.timingMeasure:
                _timingMeasure = event.timingMeasure!;
                break;
              case BloodOxygenType.bloodOxygen:
                _bloodOxygen = event.bloodOxygen!;
                break;
              case BloodOxygenType.historyList:
                _historyList = event.historyList!;
                break;
              case BloodOxygenType.continueBO:
                _continueBo = event.continueBo!;
                _startTime = _continueBo!.startTime!;
                _timeInterval = _continueBo!.timeInterval!;
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
              title: const Text("Blood Oxygen"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("continueState: $_continueState"),
              Text("timingMeasure: $_timingMeasure"),
              Text("bloodOxygen: $_bloodOxygen"),
              Text("historyList: ${_historyList.map((e) => historyBloodOxygenBeanToJson(e))}"),
              Text("startTime: $_startTime"),
              Text("timeInterval: $_timeInterval"),

              ElevatedButton(
                  child: const Text('startMeasureBloodOxygen'),
                  onPressed: () => widget.blePlugin.startMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('stopMeasureBloodOxygen'),
                  onPressed: () => widget.blePlugin.stopMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('enableTimingMeasureBloodOxygen(1)'),
                  onPressed: () =>
                      widget.blePlugin.enableTimingMeasureBloodOxygen(1)),
              ElevatedButton(
                  child: const Text('disableTimingMeasureBloodOxygen'),
                  onPressed: () => widget.blePlugin.disableTimingMeasureBloodOxygen),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygenMeasureState'),
                  onPressed: () =>
                  widget.blePlugin.queryTimingBloodOxygenMeasureState),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                  onPressed: () => widget.blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.today)),
              ElevatedButton(
                  child: const Text('queryTimingBloodOxygen(CRPBloodOxygenTimeType)'),
                  onPressed: () => widget.blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType.yesterday)),
              ElevatedButton(
                  child: const Text('enableContinueBloodOxygen'),
                  onPressed: () => widget.blePlugin.enableContinueBloodOxygen),
              ElevatedButton(
                  child: const Text('disableContinueBloodOxygen'),
                  onPressed: () => widget.blePlugin.disableContinueBloodOxygen),
              ElevatedButton(
                  child: const Text('queryContinueBloodOxygenState'),
                  onPressed: () => widget.blePlugin.queryContinueBloodOxygenState),
              ElevatedButton(
                  child: const Text('queryLast24HourBloodOxygen'),
                  onPressed: () => widget.blePlugin.queryLast24HourBloodOxygen),
              ElevatedButton(
                  child: const Text('queryHistoryBloodOxygen'),
                  onPressed: () => widget.blePlugin.queryHistoryBloodOxygen),
            ])
            )
        )
    );
  }
}
