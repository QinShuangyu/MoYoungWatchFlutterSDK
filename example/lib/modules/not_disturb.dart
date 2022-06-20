import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

class NotDisturbPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const NotDisturbPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<NotDisturbPage> createState() {
    return _NotDisturbPage();
  }
}

class _NotDisturbPage extends State<NotDisturbPage> {
  PeriodTimeResultBean? _periodTimeResultBean;
  int _periodTimeType = -1;
  PeriodTimeBean? _periodTimeInfo;
  int _endHour = -1;
  int _endMinute = -1;
  int _startHour = -1;
  int _startMinute = -1;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Not Disturb"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("periodTimeType: $_periodTimeType"),
              Text("startHour: $_startHour"),
              Text("startMinute: $_startMinute"),
              Text("endHour: $_endHour"),
              Text("endMinute: $_endMinute"),

              ElevatedButton(
                  child: const Text('queryDoNotDisturbTime()'),
                  onPressed: () async {
                    _periodTimeResultBean = await widget.blePlugin.queryDoNotDisturbTime;
                    setState(() {
                    _periodTimeType = _periodTimeResultBean!.periodTimeType;
                    _periodTimeInfo = _periodTimeResultBean!.periodTimeInfo;
                    _endHour = _periodTimeInfo!.endHour;
                    _endMinute = _periodTimeInfo!.endMinute;
                    _startHour = _periodTimeInfo!.startHour;
                    _startMinute = _periodTimeInfo!.startMinute;
                  });}),
              ElevatedButton(
                  child: const Text('sendDoNotDisturbTime()'),
                  onPressed: () => widget.blePlugin.sendDoNotDisturbTime(
                      PeriodTimeBean(
                          startHour: 1,
                          endHour: 1,
                          startMinute: 1,
                          endMinute: 1
                      ))),
            ])
            )
        )
    );
  }
}
