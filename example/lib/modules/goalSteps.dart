import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Goal Steps"),
            ),
            body: Center(
                child: ListView(
                    children: [
                      Text("goalSteps: $_goalSteps"),

                      ElevatedButton(
                          child: const Text('sendGoalSteps(5000)'),
                          onPressed: () => widget.blePlugin.sendGoalSteps(5000)),
                      ElevatedButton(
                          child: const Text('queryGoalStep()'),
                          onPressed: () async {
                            int goalSteps = await widget.blePlugin.queryGoalSteps;
                            setState(() {
                            _goalSteps = goalSteps;
                          });}),
                    ]
                )
            )
        )
    );
  }
}
