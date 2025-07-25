import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:moyoung_ble_plugin_example/utils/toast_util.dart';

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

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.gpsChangeEveStm.listen(
        (GpsChangeEventBean event) {
          if (!mounted) return;
          setState(() {
            type = event.type;
            switch (event.type) {
              case GpsChangeType.historyGpsPathChange:
                list = event.list;
                break;
              case GpsChangeType.gpsPathChange:
                gpsPathInfo = event.gpsPathInfo;
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("GPS"),
        ),
        body: Center(
          child: ListView(
            children: [
              Text('list: ${list?.join(', ') ?? "null"}'),
              Text('gpsPathInfo: ${gpsPathInfo != null ? gpsPathInfoToJson(gpsPathInfo!) : "null"}'),
              Text('location: ${location != null ? locationToJson(location!) : "null"}'),
              ElevatedButton(
                child: const Text('sendGpsLocation'),
                onPressed: () => widget.blePlugin.sendGpsLocation(0, 0),
              ),
              ElevatedButton(
                child: const Text('queryHistoryGps'),
                onPressed: () => widget.blePlugin.queryHistoryGps,
              ),
              ElevatedButton(
                child: const Text('queryGpsDetail(30)'),
                onPressed: () => {
                  if (list!.isNotEmpty) {widget.blePlugin.queryGpsDetail(list![0])}
                  else ToastUtil.show("Please obtain the list first.", Toast.LENGTH_SHORT)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
