import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class DrinkWaterReminderPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const DrinkWaterReminderPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<DrinkWaterReminderPage> createState() {
    return _DrinkWaterReminderPage();
  }
}

class _DrinkWaterReminderPage extends State<DrinkWaterReminderPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool _enable = false;
  int _startHour = -1;
  int _startMinute = -1;
  int _count = -1;
  int _period = -1;
  int _currentCups = -1;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.drinkWaterEveStm.listen((DrinkWaterPeriodBean event) {
        if (!mounted) return;
        setState(() {
          _enable = event.enable;
          _startHour = event.startHour;
          _startMinute = event.startMinute;
          _count = event.count;
          _period = event.period;
          _currentCups = event.currentCups;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Drink Water Reminder"),
            ),
            body: Center(
                child: ListView(children: <Widget>[
              Text("enable: $_enable"),
              Text("startHour: $_startHour"),
              Text("startMinute: $_startMinute"),
              Text("count: $_count"),
              Text("period: $_period"),
              Text("currentCups: $_currentCups"),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.enableDrinkWaterReminder(
                      DrinkWaterPeriodBean(enable: true, startHour: 1, startMinute: 1, count: 1, period: 1, currentCups: 1)),
                  child: const Text("enableDrinkWaterReminder()")),
              ElevatedButton(onPressed: () => widget.blePlugin.disableDrinkWaterReminder, child: const Text("disableDrinkWaterReminder()")),
              ElevatedButton(
                  onPressed: () {
                    widget.blePlugin.queryDrinkWaterReminderPeriod;
                  },
                  child: const Text("queryDrinkWaterReminderPeriod()")),
            ]))));
  }
}
