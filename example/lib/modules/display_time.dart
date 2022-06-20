import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

class DisplayTimePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const DisplayTimePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<DisplayTimePage> createState() {
    return _DisplayTimePage();
  }
}

class _DisplayTimePage extends State<DisplayTimePage> {
  int _time = -1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Display Time"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("time: $_time"),

              ElevatedButton(
                  onPressed: () => widget.blePlugin.sendDisplayTime(DisplayTimeType.displayFive),
                  child: const Text("sendDisplayTime()")),
              ElevatedButton(
                  onPressed: () async {
                    int time = await widget.blePlugin.queryDisplayTime;
                    setState(() {
                    _time = time;
                    });
                  },
                  child: const Text("queryDisplayTime()")),
            ])
            )
        )
    );
  }
}
