import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class AlarmPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const AlarmPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<AlarmPage> createState() {
    return _AlarmPage();
  }
}

class _AlarmPage extends State<AlarmPage> {
  List<AlarmClockBean> _list = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Alarm"),
            ),
            body: Center(
                child: ListView(children: [
                  Text("list: $_list"),

              ElevatedButton(
                  child: const Text('sendAlarmClock()'),
                  onPressed: () => widget.blePlugin.sendAlarm(AlarmClockBean(
                      enable: true,
                      hour: 1,
                      id: AlarmClockBean.firstClock,
                      minute: 0,
                      repeatMode: AlarmClockBean.everyday))),
              ElevatedButton(
                  child: const Text('queryAllAlarmClock()'),
                  onPressed: () async {
                    List<AlarmClockBean> list = await widget.blePlugin.queryAllAlarm;
                    setState(() {
                        _list = list;
                      });}),
            ])
            )
        )
    );
  }
}
