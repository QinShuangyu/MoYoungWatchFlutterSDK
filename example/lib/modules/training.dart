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

  /// Format pace from seconds per kilometer to mm:ss/km format
  /// 将配速从秒/公里格式化为分:秒/公里格式
  String _formatPace(int paceInSecondsPerKm) {
    if (paceInSecondsPerKm <= 0) return "无效配速";

    // 值已经是 s/km，直接计算分钟和秒数
    int minutes = paceInSecondsPerKm ~/ 60;
    int seconds = paceInSecondsPerKm % 60;
    return "${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}/km";
  }

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
                  // Display elevation data
                  // 显示海拔数据
                  if (_trainingList[i].avgElevation != null) ...[
                    const Text("  Elevation Data (海拔数据):",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.green)),
                    Text(
                        "    Average Elevation (平均海拔): ${_trainingList[i].avgElevation}米"),
                    Text(
                        "    Max Elevation (最高海拔): ${_trainingList[i].maxElevation}米"),
                    Text(
                        "    Min Elevation (最低海拔): ${_trainingList[i].minElevation}米"),
                    if (_trainingList[i].maxElevation != null &&
                        _trainingList[i].minElevation != null)
                      Text(
                          "    Elevation Range (海拔变化): ${(_trainingList[i].maxElevation! - _trainingList[i].minElevation!).abs()}米"),
                  ],
                  // Display pace data
                  // 显示配速数据
                  if (_trainingList[i].avgPace != null) ...[
                    const Text("  Pace Data (配速数据):",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.blue)),
                    Text(
                        "    Average Pace (平均配速): ${_trainingList[i].avgPace!}s/km (${_formatPace(_trainingList[i].avgPace!)})"),
                    Text(
                        "    Fastest Pace (最快配速): ${_trainingList[i].minPace!}s/km (${_formatPace(_trainingList[i].minPace!)})"),
                    Text(
                        "    Slowest Pace (最慢配速): ${_trainingList[i].maxPace!}s/km (${_formatPace(_trainingList[i].maxPace!)})"),
                  ],
                  // Display pace list data
                  // 显示配速列表数据
                  if (_trainingList[i].paceList != null &&
                      _trainingList[i].paceList!.isNotEmpty) ...[
                    const Text("  Pace List (每10秒配速):",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.orange)),
                    Text(
                        "    Total Points: ${_trainingList[i].paceList!.length}"),
                    Text(
                        "    Sample Data: ${_trainingList[i].paceList!.take(5).map((p) {
                      // 计算当前数据点是训练开始后的第几秒
                      final secondsOffset =
                          p.timestamp - (_trainingList[i].startTime ?? 0);
                      return '(${secondsOffset}s: ${p.pace})';
                    }).join(', ')}${_trainingList[i].paceList!.length > 5 ? '...' : ''}"),
                  ],
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
