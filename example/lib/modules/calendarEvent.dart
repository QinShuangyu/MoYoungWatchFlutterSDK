import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class CalendarEventPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const CalendarEventPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CalendarEventPage();
  }
}

class _CalendarEventPage extends State<CalendarEventPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _maxNumber = -1;
  List<SavedCalendarEventInfoBean> _list = [];
  CalendarEventInfoBean _calendarEventInfo = CalendarEventInfoBean(id: -1, title: "", startHour: -1, startMinute: -1, endHour: -1, endMinute: -1, time: -1);
  bool _state = false;
  int _time = -1;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.calendarEventEveStem.listen(
            (CalendarEventBean event) {
              if (!mounted) return;
          setState(() {
            switch(event.type) {
              case CalendarEventType.support:
                _maxNumber = event.maxNumber;
                _list = event.list;
                break;
              case CalendarEventType.details:
                _calendarEventInfo = event.calendarEventInfo;
                break;
              case CalendarEventType.stateAndTime:
                _state = event.state;
                _time = event.time;
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
          title: const Text("Calendar Event"),
        ),
        body: Center(
          child: ListView(children: <Widget>[

            Text("maxNumber: $_maxNumber"),
            Text("list: $_list"),
            Text("state: $_state"),
            Text("time: $_time"),
            Text("calendarEventInfo: $_calendarEventInfo"),

            ElevatedButton(
                onPressed: () => widget.blePlugin.querySupportCalendarEvent,
                child: const Text("querySupportCalendarEvent")),
            ElevatedButton(
                onPressed: () async {
                  widget.blePlugin.sendCalendarEvent(CalendarEventInfoBean(
                      id: 1,
                      title: "生日",
                      startHour: 2,
                      startMinute: 30,
                      endHour: 4,
                      endMinute: 30,
                      time: 40,
                  ));
                },
                child: const Text("sendCalendarEvent")),
            ElevatedButton(
                onPressed: () async {
                  widget.blePlugin.deleteCalendarEvent(1);
                },
                child: const Text("deleteCalendarEvent")),
            ElevatedButton(
                onPressed: () async {
                  widget.blePlugin.queryCalendarEvent(1);
                },
                child: const Text("queryCalendarEvent")),
            ElevatedButton(
                onPressed: () async {
                  widget.blePlugin.sendCalendarEventReminderTime(CalendarEventReminderTimeBean(
                      enable: true,
                      minutes: 30,
                  ));
                },
                child: const Text("sendCalendarEventReminderTime")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.queryCalendarEventReminderTime,
                child: const Text("queryCalendarEventReminderTime")),
            ElevatedButton(
                onPressed: () => widget.blePlugin.clearCalendarEvent,
                child: const Text("clearCalendarEvent")),
          ]),
        ),
      ),
    );
  }
}
