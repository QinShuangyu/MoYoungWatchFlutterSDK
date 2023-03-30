import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class HRVPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HRVPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HRVPage();
  }
}

class _HRVPage extends State<HRVPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _isSupport = false;
  int _value = -1;
  List<HistoryHrvInfoBean> _list = [];

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.newHrvEveStm.listen(
            (HrvHandlerBean event) {
              if (!mounted) return;
          setState(() {
            switch (event.type) {
              case HRVType.support:
                _isSupport = event.isSupport;
                break;
              case HRVType.hrv:
                _value = event.value;
                break;
              case HRVType.history:
                _list = event.list;
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
          title: const Text("HRV"),
        ),
        body: Center(
          child: ListView(children: <Widget>[

            Text("isSupport: $_isSupport"),
            Text("value: $_value"),
            Text("list: $_list"),

            ElevatedButton(
                onPressed: () => widget.blePlugin.querySupportNewHrv,
                child: const Text("querySupportNewHrv")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.startMeasureNewHrv,
                child: const Text("startMeasureNewHrv")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.stopMeasureNewHrv,
                child: const Text("stopMeasureNewHrv")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.queryHistoryNewHrv,
                child: const Text("queryHistoryNewHrv")),
          ]),
        ),
      ),
    );
  }
}
