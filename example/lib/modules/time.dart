import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

class TimePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const TimePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<TimePage> createState() {
    return _TimePage();
  }
}

class _TimePage extends State<TimePage> {
  int _time = -1;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Time"),
        ),
        body: Center(
            child: ListView(
                children: <Widget>[
                  Text("time: $_time"),

                  ElevatedButton(
                      child: const Text('queryTime()'),
                      onPressed: () => widget.blePlugin.queryTime),
                  ElevatedButton(
                      child: const Text('sendTimeSystem(TIME_SYSTEM_12)'),
                      onPressed: () => widget.blePlugin
                          .sendTimeSystem(TimeSystemType.timeSystem12)),
                  ElevatedButton(
                      child: const Text('sendTimeSystem(TIME_SYSTEM_24)'),
                      onPressed: () => widget.blePlugin
                          .sendTimeSystem(TimeSystemType.timeSystem24)),
                  ElevatedButton(
                      child: const Text('queryTimeSystem()'),
                      onPressed: () async {
                        int time = await widget.blePlugin.queryTimeSystem;
                        setState(() {
                          _time = time;
                        });
                      }),
                ]
            )
        ),
      ),
    );
  }
}