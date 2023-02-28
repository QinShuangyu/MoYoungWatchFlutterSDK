import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class VibrationStrengthPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const VibrationStrengthPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<VibrationStrengthPage> createState() {
    return _VibrationStrengthPage();
  }
}

class _VibrationStrengthPage extends State<VibrationStrengthPage> {

  VibrationStrength value = VibrationStrength(value: 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("VibrationStrength"),
            ),
            body: Center(
              child: ListView(
                children: [
                  Text("vibration strength: ${vibrationStrengthToJson(value)}"),

                  ElevatedButton(
                      child: const Text('sendVibrationStrength()'),
                      onPressed: () => widget.blePlugin.sendVibrationStrength(2)),
                  ElevatedButton(
                      child: const Text('queryVibrationStrength()'),
                      onPressed: () async => {
                        value = await widget.blePlugin.queryVibrationStrength
                      }),

                ],
              ),
            )
        )
    );
  }
}
