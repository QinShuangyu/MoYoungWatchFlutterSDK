import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

class TakePhotoPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TakePhotoPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TakePhotoPage> createState() {
    return _TakePhotoPage();
  }
}

class _TakePhotoPage extends State<TakePhotoPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String _camera = "";
  int _phone = -1;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.cameraEveStm.listen(
            (String event) {
          setState(() {
            _camera = event;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      widget.blePlugin.phoneEveStm.listen(
            (int event) {
          setState(() {
            _phone = event;
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
              title: const Text("Take Photo"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("camera: $_camera"),
              Text("phone: $_phone"),

              ElevatedButton(
                  child: const Text('enterCameraView'),
                  onPressed: () => widget.blePlugin.enterCameraView),
              ElevatedButton(
                  child: const Text('exitCameraView'),
                  onPressed: () => widget.blePlugin.exitCameraView),
            ])
            )
        )
    );
  }
}
