import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

class MenstrualCyclePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const MenstrualCyclePage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<MenstrualCyclePage> createState() {
    return _MenstrualCyclePage();
  }
}

class _MenstrualCyclePage extends State<MenstrualCyclePage> {
  MenstrualCycleBean? _menstrualCycleBean;
  int _physiologcalPeriod = -1;
  int _menstrualPeriod = -1;
  String _startDate = "";
  bool _menstrualReminder = false;
  bool _ovulationReminder = false;
  bool _ovulationDayReminder = false;
  bool _ovulationEndReminder = false;
  int _reminderHour = -1;
  int _reminderMinute = -1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Menstrual Cycle"),
            ),
            body: Center(
                child: ListView(
                    children: <Widget>[
                      Text("physiologcalPeriod: $_physiologcalPeriod"),
                      Text("menstrualPeriod: $_menstrualPeriod"),
                      Text("startDate: $_startDate"),
                      Text("menstrualReminder: $_menstrualReminder"),
                      Text("ovulationReminder: $_ovulationReminder"),
                      Text("ovulationDayReminder: $_ovulationDayReminder"),
                      Text("ovulationEndReminder: $_ovulationEndReminder"),
                      Text("reminderHour: $_reminderHour"),
                      Text("reminderMinute: $_reminderMinute"),

                      ElevatedButton(
                          onPressed: () =>
                              widget.blePlugin.sendMenstrualCycle(MenstrualCycleBean(
                                  physiologcalPeriod: 1,
                                  menstrualPeriod: 1,
                                  startDate: DateTime.now().microsecondsSinceEpoch.toString(),
                                  menstrualReminder: true,
                                  ovulationReminder: true,
                                  ovulationDayReminder: true,
                                  ovulationEndReminder: true,
                                  reminderHour: 1,
                                  reminderMinute: 1
                              )),
                          child: const Text("sendMenstrualCycle()")),
                      ElevatedButton(
                          onPressed: () async {
                            _menstrualCycleBean = await widget.blePlugin.queryMenstrualCycle;
                            setState(() {
                              _physiologcalPeriod = _menstrualCycleBean!.physiologcalPeriod;
                            _menstrualPeriod = _menstrualCycleBean!.menstrualPeriod;
                            _startDate = _menstrualCycleBean!.startDate;
                            _menstrualReminder = _menstrualCycleBean!.menstrualReminder;
                            _ovulationReminder = _menstrualCycleBean!.ovulationReminder;
                            _ovulationDayReminder = _menstrualCycleBean!.ovulationDayReminder;
                            _ovulationEndReminder = _menstrualCycleBean!.ovulationEndReminder;
                            _reminderHour = _menstrualCycleBean!.reminderHour;
                            _reminderMinute = _menstrualCycleBean!.reminderMinute;
                          });},
                          child: const Text("queryMenstrualCycle()")),
                    ])
            )
        )
    );
  }
}