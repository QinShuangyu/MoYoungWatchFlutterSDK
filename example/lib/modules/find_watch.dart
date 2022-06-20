import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

class FindWatchPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const FindWatchPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<FindWatchPage> createState() {
    return _FindWatchPage();
  }
}

class _FindWatchPage extends State<FindWatchPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Find Watch"),
            ),
            body: Center(child: ListView(children: [
              ElevatedButton(
                  child: const Text('findDevice()'),
                  onPressed: () => widget.blePlugin.findDevice),
            ])
            )
        )
    );
  }
}
