import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

class NotificationPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const NotificationPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<NotificationPage> createState() {
    return _NotificationPage();
  }
}

class _NotificationPage extends State<NotificationPage> {
  List _list = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Notification"),
            ),
            body: Center(child: ListView(children: [
              Text("list: $_list"),

              ElevatedButton(
                  child: const Text(
                      'sendMessage(MessageInfo()'),
                  onPressed: () => widget.blePlugin.sendMessage(
                      MessageBean(
                          message: 'message',
                          type: BleMessageType.messagePhone,
                          versionCode: 229,
                          isHs: true,
                          isSmallScreen: true
                      ))),
              ElevatedButton(
                  child: const Text('android:endCall()'),
                  onPressed: () => widget.blePlugin.endCall),
              ElevatedButton(
                  child: const Text('ios:setNotification()'),
                  onPressed: () => widget.blePlugin.setNotification([
                        NotificationType.facebook,
                        NotificationType.gmail,
                        NotificationType.kakaoTalk
                      ])),
              ElevatedButton(
                  child: const Text('ios:getNotification'),
                  onPressed: () async {
                    List list = await widget.blePlugin.getNotification;
                    setState(() {
                      _list = list;
                    });
                  }),
            ]))
        )
    );
  }
}
