import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:moyoung_ble_plugin_example/utils/toast_util.dart';
import 'package:moyoung_ble_plugin_example/utils/print_long_string.dart';

class GPSPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const GPSPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<GPSPage> createState() {
    return _GPSPage();
  }
}

class _GPSPage extends State<GPSPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  int type = 0;
  List<int>? list;
  GpsPathInfo? gpsPathInfo;
  Location? location;
  // Map<String, dynamic> _logStats = {};

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.gpsChangeEveStm.listen(
        (GpsChangeEventBean event) async {
          if (!mounted) return;

          setState(() {
            type = event.type;
            switch (event.type) {
              case GpsChangeType.historyGpsPathChange:
                list = event.list;
                printLongString(
                    'queryHistoryGps result', jsonEncode(event.toJson()));
                break;
              case GpsChangeType.gpsPathChange:
                gpsPathInfo = event.gpsPathInfo;
                printLongString(
                    'queryGpsDetail result', jsonEncode(event.toJson()));
                break;
              case GpsChangeType.locationChanged:
                location = event.location;
                break;
              case GpsChangeType.updateGpsLocationChange:
                // Handle updateGpsLocationChange if needed
                break;
            }
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("GPS"),
        ),
        body: Center(
          child: ListView(
            children: [
              // 操作按钮
              Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GPS operation',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.location_on),
                        label: const Text('sendGpsLocation (0, 0)'),
                        onPressed: () {
                          widget.blePlugin.sendGpsLocation(0, 0);
                          print('sendGpsLocation (0, 0)');
                        },
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.history),
                        label: const Text('queryHistoryGps'),
                        onPressed: () {
                          widget.blePlugin.queryHistoryGps;
                          print('queryHistoryGps');
                        },
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.details),
                        label: const Text('queryGpsDetail'),
                        onPressed: () {
                          if (list != null && list!.isNotEmpty) {
                            widget.blePlugin.queryGpsDetail(list![0]);
                            print('queryGpsDetail，ID: ${list![0]}');
                          } else {
                            ToastUtil.show("请先获取GPS列表", Toast.LENGTH_SHORT);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 当前GPS数据显示
              Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current GPS data',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Type: $type'),
                      Text('List: ${list?.join(', ') ?? "null"}'),
                      if (list != null && list!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Timestamps (本地时区):'),
                            ...list!.map((ts) => Text(
                                  DateTime.fromMillisecondsSinceEpoch(ts * 1000)
                                      .toLocal()
                                      .toString(),
                                  style: const TextStyle(fontSize: 14),
                                )),
                          ],
                        ),
                      Text(
                          'gpsPathInfo: ${gpsPathInfo != null ? gpsPathInfoToJson(gpsPathInfo!) : "null"}'),
                      Text(
                          'location: ${location != null ? locationToJson(location!) : "null"}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
