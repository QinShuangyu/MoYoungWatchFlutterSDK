import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'dart:async';

class StepsPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const StepsPage({
    Key? key,
    required this.blePlugin
  }) : super(key: key);

  @override
  State<StepsPage> createState() {
    return _StepsPage();
  }
}

class _StepsPage extends State<StepsPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String stepsInfo = "";
  String historyStepsInfo = "";
  String list = "";

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.stepsChangeEveStm.listen(
            (StepsChangeBean event) {
              if (!mounted) return;
          setState(() {
            switch (event.type) {
              case StepsChangeType.stepChange:
                stepsInfo = stepInfoBeanToJson(event.stepsInfo!);
                break;
              case StepsChangeType.historyStepChange:
                historyStepsInfo = historyStepInfoBeanToJson(event.historyStepsInfo!);
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
              title: const Text("Steps"),
            ),
            body: Center(
              child: ListView(
                children: [
                  Text("stepsInfo: $stepsInfo"),
                  Text("historyStepsInfo: $historyStepsInfo"),
                  Text("list: $list"),

                  ElevatedButton(
                      child: const Text('querySteps'),
                      onPressed: () => widget.blePlugin.querySteps),
                  ElevatedButton(
                      child: const Text('queryHistorySteps(yesterday)'),
                      onPressed: () => widget.blePlugin.queryHistorySteps(StepsDetailDateType.yesterday)),
                  /// 获取步数历史记录
                  ElevatedButton(
                      child: const Text('queryHistorySteps(theDayBeforeYesterday)'),
                      onPressed: () => widget.blePlugin.queryHistorySteps(StepsDetailDateType.theDayBeforeYesterday)),
                  /// 获取最近两天步数半小时分类统计
                  ElevatedButton(
                      child: const Text('queryStepsDetail(today)'),
                      onPressed: () => widget.blePlugin.queryStepsDetail(StepsDetailDateType.today)),
                ],
              ),
            )
        )
    );
  }
}
