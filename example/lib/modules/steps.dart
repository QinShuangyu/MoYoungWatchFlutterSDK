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
  int _stepsChange = -1;
  String list = "";
  StepsCategoryBean stepsCategoryInfo = StepsCategoryBean(historyDay: "", timeInterval: -1, stepsList: []);
  ActionDetailsBean actionDetailsInfo = ActionDetailsBean(historyDay: "", stepsList: [], distanceList: [], caloriesList: []);


  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.stepsChangeEveStm.listen(
            (StepsChangeBean event) {
          setState(() {
            _stepsChange = event.stepsInfo.steps;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      widget.blePlugin.stepsDetailEveStm.listen(
            (StepsDetailBean event) {
          setState(() {
            switch (event.type) {
              case StepsDetailType.stepsCategoryChange:
                stepsCategoryInfo = event.stepsCategoryInfo!;
                break;
              case StepsDetailType.actionDetailsChange:
                actionDetailsInfo = event.actionDetailsInfo!;
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
                  Text("StepsChange=" + _stepsChange.toString()),
                  Text("list: $list"),
                  Text("stepsCategoryInfo: ${stepsCategoryBeanToJson(stepsCategoryInfo)}"),
                  Text("actionDetailsInfo: ${actionDetailsBeanToJson(actionDetailsInfo)}"),

                  ElevatedButton(
                      child: const Text('querySteps'),
                      onPressed: () => widget.blePlugin.querySteps),
                  ElevatedButton(
                      child: const Text('queryHistorySteps(todayStepsDetail)'),
                      onPressed: () => widget.blePlugin.queryHistorySteps(StepsDetailDateType.todayStepsDetail)),
                  ElevatedButton(
                      child: const Text('queryStepsDetail(todayStepsDetail)'),
                      onPressed: () => widget.blePlugin.queryStepsDetail(StepsDetailDateType.todayStepsDetail)),

                  ElevatedButton(
                      child: const Text('get24HourCals()'),
                      onPressed: () async {
                        The24HourListBean hourList = await widget.blePlugin.get24HourCals;
                        setState(() {
                          list = the24HourListBeanToJson(hourList);
                        });
                      }),
                  ElevatedButton(
                      child: const Text('queryActionDetails()'),
                      onPressed: () => widget.blePlugin.queryActionDetails(ActionDetailsType.today)),
                ],
              ),
            )
        )
    );
  }
}
