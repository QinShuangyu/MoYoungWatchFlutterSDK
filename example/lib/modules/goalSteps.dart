import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class GoalStepsPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const GoalStepsPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<GoalStepsPage> createState() {
    return _GoalStepPage();
  }
}

class _GoalStepPage extends State<GoalStepsPage> {
  int _goalSteps = -1;
  String _dailGoalsInfo = "";
  String _trainingDay = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Goal Steps"),
            ),
            body: Center(
                child: ListView(children: [
              Text("goalSteps: $_goalSteps"),
              Text("dailyGoalsInfo: $_dailGoalsInfo"),
              Text("trainingDay: $_trainingDay"),
              ElevatedButton(
                child: const Text('sendGoalSteps(5000)'),
                onPressed: () => widget.blePlugin.sendGoalSteps(5000),
              ),
              ElevatedButton(
                  child: const Text('queryGoalStep()'),
                  onPressed: () async {
                    int goalSteps = await widget.blePlugin.queryGoalSteps;
                    setState(() {
                      _goalSteps = goalSteps;
                    });
                  }),
              ElevatedButton(
                child: const Text('sendDailyGoals()'),
                onPressed: () => widget.blePlugin.sendDailyGoals(
                  DailyGoalsInfoBean(steps: 100, calories: 500, trainingTime: 30, distance: 1000),
                ),
              ),
              ElevatedButton(
                  child: const Text('queryDailyGoals()'),
                  onPressed: () async {
                    DailyGoalsInfoBean dailGoalsInfo = await widget.blePlugin.queryDailyGoals;
                    setState(() {
                      _dailGoalsInfo = dailyGoalsInfoBeanToJson(dailGoalsInfo);
                    });
                  }),
              ElevatedButton(
                child: const Text('sendTrainingDayGoals()'),
                onPressed: () => widget.blePlugin.sendTrainingDayGoals(
                  DailyGoalsInfoBean(steps: 100, calories: 500, trainingTime: 30, distance: 10),
                ),
              ),
              ElevatedButton(
                  child: const Text('queryTrainingDayGoals()'),
                  onPressed: () async {
                    DailyGoalsInfoBean dailGoalsInfo = await widget.blePlugin.queryTrainingDayGoals;
                    setState(() {
                      _dailGoalsInfo = dailyGoalsInfoBeanToJson(dailGoalsInfo);
                    });
                  }),
              ElevatedButton(
                child: const Text("sendTrainingDays()"),
                onPressed: () => widget.blePlugin.sendTrainingDays(TrainingDayInfoBean(
                  enable: false,
                  trainingDays: [0, 1, 2],
                )),
              ),
              ElevatedButton(
                  child: const Text('queryTrainingDay()'),
                  onPressed: () async {
                    TrainingDayInfoBean trainingDay = await widget.blePlugin.queryTrainingDay;
                    setState(() {
                      _trainingDay = trainingDayInfoBeanToJson(trainingDay);
                    });
                  }),
            ]))));
  }
}
