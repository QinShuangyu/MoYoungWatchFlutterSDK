import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class PhoneNotification extends StatefulWidget {
  final MoYoungBle blePlugin;

  const PhoneNotification({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<PhoneNotification> createState() => _PhoneNotificationState();
}

class _PhoneNotificationState extends State<PhoneNotification> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Alarm"),
        ),
        body: Center(
          child: ListView(
            children: [
              ElevatedButton(
                  child: const Text('enableIncomingNumber(true)'),
                  onPressed: () => widget.blePlugin.enableIncomingNumber(true)),
              ElevatedButton(
                  child: const Text('enableIncomingNumber(false)'),
                  onPressed: () => widget.blePlugin.enableIncomingNumber(false)),
            ],
          ),
        ),
      ),
    );
  }
}
