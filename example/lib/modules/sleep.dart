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

  SleepInfo _sleepInfo = SleepInfo(
    totalTime: -1,
    restfulTime: -1,
    lightTime: -1,
    soberTime: -1,
    remTime: -1,
    details: [],
  );
  HistorySleepBean _historySleep = HistorySleepBean(
    timeType: SleepHistoryTimeType.yesterday,
    sleepInfo: SleepInfo(
      totalTime: -1,
      restfulTime: -1,
      lightTime: -1,
      soberTime: -1,
      remTime: -1,
      details: [],
    ),
  );
  HistoryNapSleepBean _historyNapSleep = HistoryNapSleepBean(
    timeType: SleepHistoryTimeType.yesterday,
    list: [],
  );

  int _goalSleepTime = -1;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.sleepChangeEveStm.listen(
        (SleepBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case SleepType.sleepChange:
                _sleepInfo = event.sleepInfo!;
                break;
              case SleepType.historySleepChange:
                _historySleep = event.historySleep!;
                break;
              case SleepType.goalSleepTimeChange:
                _goalSleepTime = event.goalSleepTime!;
                break;
              case SleepType.historyNapSleepChange:
                _historyNapSleep = event.historyNapSleep!;
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
                  Text("sleepInfo: ${sleepInfoToJson(_sleepInfo!)}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("historySleep: ${historySleepBeanToJson(_historySleep!)}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("_historyNapSleep: ${historyNapSleepBeanToJson(_historyNapSleep!)}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("goalSleepTime: $_goalSleepTime"),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(child: const Text('querySleep'), onPressed: () => widget.blePlugin.querySleep),
                  ElevatedButton(
                      child: const Text('sendGoalSleepTime'),

                      /// Must be a multiple of 10, with a maximum value of 750
                      onPressed: () => widget.blePlugin.sendGoalSleepTime(10)),
                  ElevatedButton(
                      child: const Text('queryGoalSleepTime'), onPressed: () => widget.blePlugin.queryGoalSleepTime),
                  ElevatedButton(
                      child: const Text('queryHistorySleep(YESTERDAY)'),
                      onPressed: () => widget.blePlugin.queryHistorySleep(SleepHistoryTimeType.yesterday)),
                  ElevatedButton(
                      child: const Text('queryHistorySleep(THE_DAY_BEFORE_YESTERDAY)'),
                      onPressed: () => widget.blePlugin.queryHistorySleep(SleepHistoryTimeType.theDayBeforeYesterday)),
                  ElevatedButton(
                      child: const Text('queryHistoryNapSleep(today)'),
                      onPressed: () => widget.blePlugin.queryHistoryNapSleep(SleepHistoryTimeType.today)),
                  ElevatedButton(
                      child: const Text('queryHistoryNapSleep(yesterday)'),
                      onPressed: () => widget.blePlugin.queryHistoryNapSleep(SleepHistoryTimeType.yesterday)),
                ],
              ),
            )));
  }
}
