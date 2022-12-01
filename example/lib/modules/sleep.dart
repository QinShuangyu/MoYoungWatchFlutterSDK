import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class SleepPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const SleepPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<SleepPage> createState() {
    return _SleepPage();
  }
}

class _SleepPage extends State<SleepPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _totalTime = -1;
  int _restfulTime = -1;
  int _lightTime = -1;
  int _soberTime = -1;
  int _remTime = -1;
  int _timeType = -1;


  SleepInfo? sleepInfo;
  HistorySleepBean? historySleep;


  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.sleepChangeEveStm.listen(
        (SleepBean event) {
          setState(() {
            switch (event.type) {
              case SleepType.sleepChange:
                _totalTime = event.sleepInfo!.totalTime!;
                _restfulTime = event.sleepInfo!.restfulTime!;
                _lightTime = event.sleepInfo!.lightTime!;
                _soberTime = event.sleepInfo!.soberTime!;
                _remTime = event.sleepInfo!.remTime!;
                break;
              case SleepType.historySleepChange:
                _timeType = event.historySleep!.timeType!;
                _totalTime = event.historySleep!.sleepInfo!.totalTime!;
                _restfulTime = event.historySleep!.sleepInfo!.restfulTime!;
                _lightTime = event.historySleep!.sleepInfo!.lightTime!;
                _soberTime = event.historySleep!.sleepInfo!.soberTime!;
                _remTime = event.historySleep!.sleepInfo!.remTime!;
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
              title: const Text("Sleep"),
            ),
            body: Center(
              child: ListView(
                children: [
                  Text("timeType: $_timeType"),
                  Text("totalTime: $_totalTime"),
                  Text("restfulTime: $_restfulTime"),
                  Text("lightTime: $_lightTime"),
                  Text("soberTime: $_soberTime"),
                  Text("remTime: $_remTime"),

                  ElevatedButton(
                      child: const Text('querySleep'),
                      onPressed: () => widget.blePlugin.querySleep),
                  ElevatedButton(
                      child: const Text('queryRemSleep'),
                      onPressed: () => widget.blePlugin.queryRemSleep),
                  ElevatedButton(
                      child: const Text('queryHistorySleep(YESTERDAY_SLEEP)'),
                      onPressed: () => widget.blePlugin.queryHistorySleep(HistoryTimeType.yesterdaySleep)),
                  ElevatedButton(
                      child: const Text('queryHistorySleep(DAY_BEFORE_YESTERDAY_SLEEP)'),
                      onPressed: () => widget.blePlugin.queryHistorySleep(HistoryTimeType.dayBeforeYesterdaySleep)),
                ],
              ),
            )
        )
    );
  }
}
