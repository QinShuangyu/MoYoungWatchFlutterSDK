import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

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

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    // _streamSubscriptions.add(
    //   widget.blePlugin.gpsChangeEveStm.listen(
    //     (int event) {
    //       setState(() {});
    //     },
    //   ),
    // );
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
              ElevatedButton(
                child: const Text('queryHistoryGps'),
                onPressed: () => widget.blePlugin.queryHistoryGps,
              ),
              ElevatedButton(
                child: const Text('queryGpsDetail(30)'),
                onPressed: () => widget.blePlugin.queryGpsDetail(30),
              ),
              // ElevatedButton(
              //     child: const Text('sendEpoFile()'),
              //     onPressed: sendEpoFile),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendEpoFile() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
  }
}
