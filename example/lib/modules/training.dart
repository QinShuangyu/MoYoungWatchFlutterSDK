import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class TrainingPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TrainingPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TrainingPage> createState() {
    return _TrainingPage();
  }
}

class _TrainingPage extends State<TrainingPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<HistoryTrainList> _historyTrainList = [];
  TrainingInfo? _trainingInfo;
  int _typeInfo = -1;
  int _startTimeInfo = -1;
  int _endTime = -1;
  int _validTime = -1;
  int _steps = -1;
  int _distance = -1;
  int _calories = -1;
  List<int> _hrList = [];
  int _type = -1;
  late StreamSubscription<dynamic> a;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.trainingEveStm.listen(
        (TrainBean event) {
          setState(() {
            switch (event.type) {
              case TrainType.historyTrainingChange:
                _historyTrainList = event.historyTrainList!;
                break;
              case TrainType.trainingChange:
                _trainingInfo = event.trainingInfo;
                _typeInfo = _trainingInfo!.type!;
                _startTimeInfo = _trainingInfo!.startTime!;
                _endTime = _trainingInfo!.endTime!;
                _validTime = _trainingInfo!.validTime!;
                _steps = _trainingInfo!.steps!;
                _distance = _trainingInfo!.distance!;
                _calories = _trainingInfo!.calories!;
                _hrList = _trainingInfo!.hrList!;
                break;
              default:
                break;
            }
          });
        },
      ),
    );
  }

  void setTrainingStateEveStm() {
    a = widget.blePlugin.trainingStateEveStm.listen(
          (int event) {
        setState(() {
          _type = event;
        });
      },
    );
    _streamSubscriptions.add(a);
  }

  void deleteTrainingStateEveStm() {
    if (_streamSubscriptions.contains(a)) {
      _streamSubscriptions.remove(a);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Training"),
            ),
            body: Center(child: ListView(children: <Widget>[
              const Text("historyTrainList: as follows"),
              Text("_historyTrainList: ${_historyTrainList.toString()}"),
              const Text("trainingInfo: as follows"),
              Text("typeInfo: $_typeInfo"),
              Text("startTimeInfo: $_startTimeInfo"),
              Text("endTime: $_endTime"),
              Text("validTime: $_validTime"),
              Text("steps: $_steps"),
              Text("distance: $_distance"),
              Text("calories: $_calories"),
              Text("hrList: $_hrList"),
              Text("type: $_type"),

              ElevatedButton(
                  onPressed: () => {
                    setTrainingStateEveStm(),
                    widget.blePlugin.startTraining(1)
                  },
                  child: const Text("startTraining()")),
              ElevatedButton(
                  onPressed: () =>
                      widget.blePlugin.setTrainingState(
                          TrainingHeartRateStateType.trainingComplete),
                  child: const Text("setTrainingState(-1)")),
              ElevatedButton(
                  onPressed: () =>
                      widget.blePlugin.setTrainingState(
                          TrainingHeartRateStateType.trainingPause),
                  child: const Text("setTrainingState(-2)")),
              ElevatedButton(
                  onPressed: () =>
                      widget.blePlugin.setTrainingState(
                          TrainingHeartRateStateType.trainingContinue),
                  child: const Text("setTrainingState(-3)")),

              ElevatedButton(
                  onPressed: () => {
                    deleteTrainingStateEveStm(),
                    widget.blePlugin.queryHistoryTraining
                  },
                  child: const Text("queryHistoryTraining()")),
              ElevatedButton(
                  onPressed: () => {
                    deleteTrainingStateEveStm(),
                    widget.blePlugin.queryTraining(1)
                  },
                  child: const Text("queryTraining()")),
            ])
            )
        )
    );
  }
}
