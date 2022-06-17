import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';
import 'dart:async';

class HeartRatePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HeartRatePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<HeartRatePage> createState() {
    return _HearRatePage();
  }
}

class _HearRatePage extends State<HeartRatePage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _measuring = -1;
  int _onceMeasureComplete = -1;
  List<HistoryHeartRateBean> _historyHrList = [];
  MeasureCompleteBean? _measureComplete;
  String _historyDynamicRateType = "";
  HeartRateInfo? _hour24MeasureResult;
  int _startTime = -1;
  List<int> _heartRateList = [];
  int _timeInterval = -1;
  String _heartRateType = "";
  List<TrainingHeartRateBean> _trainingList = [];
  int _timingMeasure = -1;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.heartRateEveStm.listen(
        (HeartRateBean event) {
          setState(() {
            switch(event.type){
              case HeartRateType.measuring:
                _measuring = event.measuring!;
                break;
              case HeartRateType.onceMeasureComplete:
                _onceMeasureComplete = event.onceMeasureComplete!;
                break;
              case HeartRateType.heartRate:
                _historyHrList = event.historyHrList!;
                break;
              case HeartRateType.measureComplete:
                _measureComplete = event.measureComplete!;
                _historyDynamicRateType = _measureComplete!.historyDynamicRateType!;
                _startTime = _measureComplete!.heartRate!.startTime;
                _heartRateList = _measureComplete!.heartRate!.heartRateList;
                _timeInterval = _measureComplete!.heartRate!.timeInterval;
                _heartRateType = _measureComplete!.heartRate!.heartRateType;
                break;
              case HeartRateType.hourMeasureResult:
                _hour24MeasureResult = event.hour24MeasureResult!;
                _startTime = _hour24MeasureResult!.startTime;
                _heartRateList = _hour24MeasureResult!.heartRateList;
                _timeInterval = _hour24MeasureResult!.timeInterval;
                _heartRateType = _hour24MeasureResult!.heartRateType;
                break;
              case HeartRateType.measureResult:
                _trainingList = event.trainingList!;
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
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Hear Rate"),
            ),
            body: Center(child: ListView(children: [
              Text("measuring: $_measuring"),
              Text("onceMeasureComplete: $_onceMeasureComplete"),
              Text("historyHrList[0]: $_historyHrList"),
              Text("historyDynamicRateType: $_historyDynamicRateType"),
              Text("startTime: $_startTime"),
              Text("heartRateList: $_heartRateList"),
              Text("timeInterval: $_timeInterval"),
              Text("heartRateType: $_heartRateType"),
              Text("trainingList: $_trainingList"),
              Text("timingMeasure: $_timingMeasure"),

              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => widget.blePlugin.queryLastDynamicRate(HistoryDynamicRateType.firstHeartRate)),
              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => widget.blePlugin.queryLastDynamicRate(HistoryDynamicRateType.secondHeartRate)),
              ElevatedButton(
                  child: const Text('queryLastDynamicRate()'),
                  onPressed: () => widget.blePlugin.queryLastDynamicRate(HistoryDynamicRateType.thirdHeartRate)),
              ElevatedButton(
                  child: const Text('enableTimingMeasureHeartRate(10)'),
                  onPressed: () => widget.blePlugin.enableTimingMeasureHeartRate(10)),
              ElevatedButton(
                  child: const Text('disableTimingMeasureHeartRate()'),
                  onPressed: () => widget.blePlugin.disableTimingMeasureHeartRate),
              ElevatedButton(
                  child: const Text('queryTimingMeasureHeartRate()'),
                  onPressed: () async {
                    int timingMeasure = await widget.blePlugin.queryTimingMeasureHeartRate;
                    setState(() {
                      _timingMeasure = timingMeasure;
                    });
                  }),
              ElevatedButton(
                  child: const Text(
                      'queryTodayHeartRate(TIMING_MEASURE_HEART_RATE)'),
                  onPressed: () => widget.blePlugin.queryTodayHeartRate(
                      TodayHeartRateType.timingMeasureHeartRate)),
              ElevatedButton(
                  child: const Text('queryTodayHeartRate(ALL_DAY_HEART_RATE)'),
                  onPressed: () => widget.blePlugin.queryTodayHeartRate(
                      TodayHeartRateType.allDayHeartRate)),
              ElevatedButton(
                  child: const Text('queryPastHeartRate'),
                  onPressed: () => widget.blePlugin.queryPastHeartRate),
              ElevatedButton(
                  child: const Text('queryTrainingHeartRate'),
                  onPressed: () => widget.blePlugin.queryTrainingHeartRate),
              ElevatedButton(
                  child: const Text('startMeasureOnceHeartRate'),
                  onPressed: () => widget.blePlugin.startMeasureOnceHeartRate),
              ElevatedButton(
                  child: const Text('stopMeasureOnceHeartRate'),
                  onPressed: () => widget.blePlugin.stopMeasureOnceHeartRate),
              ElevatedButton(
                  child: const Text('queryHistoryHeartRate'),
                  onPressed: () => widget.blePlugin.queryHistoryHeartRate),
            ])
            )
        )
    );
  }
}
