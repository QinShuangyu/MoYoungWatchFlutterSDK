import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:moyoung_ble_plugin_example/utils/print_long_string.dart';

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
                printLongString(
                    'historyTrainingChange result', jsonEncode(event.toJson()));
                break;
              case TrainType.trainingChange:
                _trainingList = event.trainingList!;
                printLongString(
                    'trainingChange result', jsonEncode(event.toJson()));
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
              ElevatedButton(
                onPressed: () => {widget.blePlugin.startTraining(1)},
                child: const Text("startTraining(1)"),
              ),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.setTrainingState(
                      TrainingHeartRateStateType.trainingComplete),
                  child: const Text("setTrainingState(-1)")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.setTrainingState(
                      TrainingHeartRateStateType.trainingPause),
                  child: const Text("setTrainingState(-2)")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.setTrainingState(
                      TrainingHeartRateStateType.trainingContinue),
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
                  if (_historyTrainList.isNotEmpty)
                    {widget.blePlugin.queryTraining(_historyTrainList[0].id!)},
                },
                child: const Text("queryTraining()"),
              ),
              Text(
                  "historyTrainList: ${_historyTrainList.map((e) => e.toJson())}"),
              Text("type: $_type"),
              Text("trainingList: ${_trainingList.map((e) => e.toJson())}"),
              // Display detailed training info including new cadences and strides fields
              // 显示详细的训练信息，包括新增的步频和步幅字段
              if (_trainingList.isNotEmpty) ...[
                const Divider(),
                const Text("Training Details (包含步频和步幅数据):",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                for (int i = 0; i < _trainingList.length; i++) ...[
                  Text("Training ${i + 1}:"),
                  Text("  Steps: ${_trainingList[i].steps}"),
                  Text("  Distance: ${_trainingList[i].distance}"),
                  Text("  Calories: ${_trainingList[i].calories}"),
                  Text(
                      "  Heart Rate List: ${_trainingList[i].hrList?.map((hr) => '{timestamp: ${hr.timestamp}, hr: ${hr.hr}}').toList()}"),
                  Text("  Cadences (步频): ${_trainingList[i].cadences}"),
                  Text("  Strides (步幅): ${_trainingList[i].strides}"),
                  // Display measurement intervals
                  // 显示测量间隔信息
                  Text("  HR Interval (心率间隔): ${_trainingList[i].hrInterval}s"),
                  Text(
                      "  Cadences Interval (步频间隔): ${_trainingList[i].cadencesInterval}s"),
                  Text(
                      "  Strides Interval (步幅间隔): ${_trainingList[i].stridesInterval}s"),
                  // Display timestamped cadences and strides data
                  // 显示带时间戳的步频和步幅数据
                  Text(
                      "  Cadences List (带时间戳步频): ${_trainingList[i].cadencesList?.map((c) => '{timestamp: ${c.timestamp}, cadence: ${c.cadence}}').toList()}"),
                  Text(
                      "  Strides List (带时间戳步幅): ${_trainingList[i].stridesList?.map((s) => '{timestamp: ${s.timestamp}, stride: ${s.stride}}').toList()}"),
                  // Display heart rate zone statistics
                  // 显示心率区间统计
                  if (_trainingList[i].hrZone != null) ...[
                    const Text("  Heart Rate Zones (心率区间统计):",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    for (String zone in ['L0', 'L1', 'L2', 'L3', 'L4']) ...[
                      if (_trainingList[i].hrZone![zone] != null)
                        Text(
                            "    $zone: ${_trainingList[i].hrZone![zone]!['percent']}% (${_trainingList[i].hrZone![zone]!['duration']}s)"),
                    ],
                  ],
                  const SizedBox(height: 10),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
