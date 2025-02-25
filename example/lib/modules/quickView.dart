import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class QuickViewPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const QuickViewPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<QuickViewPage> createState() {
    return _QuickViewPage();
  }
}

class _QuickViewPage extends State<QuickViewPage> {
  bool _quickViewState = false;
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
              title: const Text("Quick View"),
            ),
            body: Center(
              child: ListView(
                children: [
                  Text("quickViewState: $_quickViewState"),
                  Text("periodTimeType: $_periodTimeType"),
                  Text("startHour: $_startHour"),
                  Text("startMinute: $_startMinute"),
                  Text("endHour: $_endHour"),
                  Text("endMinute: $_endMinute"),

                  ElevatedButton(
                      child: const Text('sendQuickView(true)'),
                      onPressed: () => widget.blePlugin.sendQuickView(true)),
                  ElevatedButton(
                      child: const Text('sendQuickView(false)'),
                      onPressed: () => widget.blePlugin.sendQuickView(false)),
                  ElevatedButton(
                      child: const Text('queryQuickView()'),
                      onPressed: () async {
                        bool quickViewState = await widget.blePlugin.queryQuickView;
                        setState(() {
                          _quickViewState = quickViewState;
                        });
                      }),
                  ElevatedButton(
                      child: const Text(
                          'sendQuickViewTime(CrpPeriodTimeInfo(0,0,0,0)'),
                      onPressed: () => widget.blePlugin.sendQuickViewTime(
                          PeriodTimeBean(
                              endHour: 0,
                              endMinute: 0,
                              startHour: 0,
                              startMinute: 0))),
                  ElevatedButton(
                      child: const Text('queryQuickViewTime()'),
                      onPressed: () async {
                        _periodTimeResultBean = await widget.blePlugin.queryQuickViewTime;
                        setState(() {
                        _periodTimeType = _periodTimeResultBean!.periodTimeType;
                        _periodTimeInfo = _periodTimeResultBean!.periodTimeInfo;
                        _endHour = _periodTimeInfo!.endHour;
                        _endMinute = _periodTimeInfo!.endMinute;
                        _startHour = _periodTimeInfo!.startHour;
                        _startMinute = _periodTimeInfo!.startMinute;
                      });}),
                ],
              ),
            )
        )
    );
  }
}
