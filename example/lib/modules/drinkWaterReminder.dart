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
  DrinkWaterPeriodBean? _drinkWaterPeriodBean;
  bool _enable = false;
  int _startHour = -1;
  int _startMinute = -1;
  int _count = -1;
  int _period = -1;
  int _currentCups = -1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Drink Water Reminder"),
            ),
            body: Center(child: ListView(children: <Widget>[
              Text("enable: $_enable"),
              Text("startHour: $_startHour"),
              Text("startMinute: $_startMinute"),
              Text("count: $_count"),
              Text("period: $_period"),
              Text("currentCups: $_currentCups"),

              ElevatedButton(
                  onPressed: () =>
                      widget.blePlugin.enableDrinkWaterReminder(DrinkWaterPeriodBean(
                          enable: true,
                          startHour: 1,
                          startMinute: 1,
                          count: 1,
                          period: 1,
                          currentCups: 1)),
                  child: const Text("enableDrinkWaterReminder()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.disableDrinkWaterReminder,
                  child: const Text("disableDrinkWaterReminder()")),
              ElevatedButton(
                  onPressed: () async {
                    _drinkWaterPeriodBean = await widget.blePlugin.queryDrinkWaterReminderPeriod;
                    setState(() {
                    _enable = _drinkWaterPeriodBean!.enable;
                    _startHour = _drinkWaterPeriodBean!.startHour;
                    _startMinute = _drinkWaterPeriodBean!.startMinute;
                    _count = _drinkWaterPeriodBean!.count;
                    _period = _drinkWaterPeriodBean!.period;
                    _currentCups = _drinkWaterPeriodBean!.currentCups;
                  });},
                  child: const Text("queryDrinkWaterReminderPeriod()")),
            ])
            )
        )
    );
  }
}
