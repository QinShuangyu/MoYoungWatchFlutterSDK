import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class HandWashingReminderPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const HandWashingReminderPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<HandWashingReminderPage> createState() {
    return _HandWashingReminderPage();
  }
}

class _HandWashingReminderPage extends State<HandWashingReminderPage> {
  HandWashingPeriodBean? _handWashingPeriodBean;
  bool _enable = false;
  int _startHour = -1;
  int _startMinute = -1;
  int _count = -1;
  int _period = -1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Hand Washing Reminder"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("enable: $_enable"),
              Text("startHour: $_startHour"),
              Text("startMinute: $_startMinute"),
              Text("count: $_count"),
              Text("period: $_period"),

              ElevatedButton(
                  onPressed: () =>
                      widget.blePlugin.enableHandWashingReminder(
                          HandWashingPeriodBean(
                            enable: true,
                            startHour: 1,
                            startMinute: 1,
                            count: 1,
                            period: 1,
                          )),
                  child: const Text("enableHandWashingReminder()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.disableHandWashingReminder,
                  child: const Text("disableHandWashingReminder()")),
              ElevatedButton(
                  onPressed: () async {
                    _handWashingPeriodBean = await widget.blePlugin.queryHandWashingReminderPeriod;
                    setState(() {
                    _enable = _handWashingPeriodBean!.enable;
                    _startHour = _handWashingPeriodBean!.startHour;
                    _startMinute = _handWashingPeriodBean!.startMinute;
                    _count = _handWashingPeriodBean!.count;
                    _period = _handWashingPeriodBean!.period;
                  });},
                  child: const Text("queryHandWashingReminderPeriod()")),
            ])
            )
        )
    );
  }
}
