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
  DrinkWaterPeriodBean? _drinkWaterPeriodBean;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.drinkWaterEveStm.listen(
        (DrinkWaterBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case DrinkWaterType.dwPeriod:
                _drinkWaterPeriodBean = event.crpDrinkWaterPeriodInfo;
                break;
            }
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
              Text(
                  "_drinkWaterPeriodBean: ${drinkWaterPeriodBeanToJson(_drinkWaterPeriodBean!)}"),
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
                  onPressed: () => widget.blePlugin.queryDrinkWaterReminderPeriod,
                  child: const Text("queryDrinkWaterReminderPeriod()")),
            ]))));
  }
}
