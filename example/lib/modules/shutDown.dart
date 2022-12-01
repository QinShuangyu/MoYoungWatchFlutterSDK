import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ShutDownPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ShutDownPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ShutDownPage> createState() {
    return _ShutDownPage();
  }
}

class _ShutDownPage extends State<ShutDownPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Shut Down"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  child: const Text('shutDown()'),
                  onPressed: () => widget.blePlugin.shutDown),
            ])
            )
        )
    );
  }
}
