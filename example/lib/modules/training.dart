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
  int _type = -1;
  List<TrainingInfo> _trainingList = [];

  @override
  void initState() {
    super.initState();
    subscriptStream();
    setTrainingStateEveStm();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.trainingEveStm.listen(
        (TrainBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case TrainType.historyTrainingChange:
                _historyTrainList = event.historyTrainList!;
                break;
              case TrainType.trainingChange:
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

  void setTrainingStateEveStm() {
    _streamSubscriptions.add(
      widget.blePlugin.trainingStateEveStm.listen(
        (int event) {
          if (!mounted) return;
          setState(() {
            _type = event;
          });
        },
      ),
    );
  }

  // void deleteTrainingStateEveStm() {
  //   if (_streamSubscriptions.contains(a)) {
  //     _streamSubscriptions.remove(a);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Training"),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              Text("historyTrainList: ${_historyTrainList.map((e) => e.toJson())}"),
              Text("type: $_type"),
              Text("trainingList: ${_trainingList.map((e) => e.toJson())}"),
              ElevatedButton(
                onPressed: () => {widget.blePlugin.startTraining(1)},
                child: const Text("startTraining(1)"),
              ),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.setTrainingState(TrainingHeartRateStateType.trainingComplete),
                  child: const Text("setTrainingState(-1)")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.setTrainingState(TrainingHeartRateStateType.trainingPause),
                  child: const Text("setTrainingState(-2)")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.setTrainingState(TrainingHeartRateStateType.trainingContinue),
                  child: const Text("setTrainingState(-3)")),
              ElevatedButton(
                onPressed: () => {
                  // deleteTrainingStateEveStm(),
                  widget.blePlugin.queryHistoryTraining,
                },
                child: const Text("queryHistoryTraining()"),
              ),
              ElevatedButton(
                onPressed: () => {
                  // deleteTrainingStateEveStm(),
                  if (_historyTrainList.isNotEmpty) {
                    widget.blePlugin.queryTraining(_historyTrainList[0].id!)
                  },
                },
                child: const Text("queryTraining()"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
