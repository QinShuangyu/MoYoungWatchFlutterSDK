import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class StressPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const StressPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StressPage();
  }
}

class _StressPage extends State<StressPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _isSupport = false;
  int _value = -1;
  List<HistoryStressInfoBean> _list = [];
  bool _state = false;
  TimingStressInfoBean _timingStressInfo = TimingStressInfoBean(date: StressDateBean(value: -1), list: []);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.stressEveStm.listen(
            (StressHandlerBean event) {
              if (!mounted) return;
          setState(() {
            switch (event.type) {
              case StressHandlerType.support:
                _isSupport = event.isSupport;
                break;
              case StressHandlerType.change:
                _value = event.value;
                break;
              case StressHandlerType.historyChange:
                _list = event.list;
                break;
              case StressHandlerType.timingStateChange:
                _state = event.state;
                break;
              case StressHandlerType.timingChange:
                _timingStressInfo = event.timingStressInfo;
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
          title: const Text("Stress"),
        ),
        body: Center(
          child: ListView(children: <Widget>[

            Text("isSupport: $_isSupport"),
            Text("value: $_value"),
            Text("list: $_list"),
            Text("state: $_state"),
            Text("timingStressInfo: ${timingStressInfoBeanToJson(_timingStressInfo)}"),

            ElevatedButton(
                onPressed: () => widget.blePlugin.querySupportStress,
                child: const Text("querySupportStress")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.startMeasureStress,
                child: const Text("startMeasureStress")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.stopMeasureStress,
                child: const Text("stopMeasureStress")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.queryHistoryStress,
                child: const Text("queryHistoryStress")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.enableTimingStress,
                child: const Text("enableTimingStress")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.disableTimingStress,
                child: const Text("disableTimingStress")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.queryTimingStressState,
                child: const Text("queryTimingStressState")),
            ElevatedButton(
                onPressed: () async {
                  await widget.blePlugin.queryTimingStress(StressDate.today);
                },
                child: const Text("queryTimingStress")),
          ]),
        ),
      ),
    );
  }
}
