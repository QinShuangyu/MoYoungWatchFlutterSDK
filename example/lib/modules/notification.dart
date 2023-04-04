import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class NotificationPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const NotificationPage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<NotificationPage> createState() {
    return _NotificationPage();
  }
}

class _NotificationPage extends State<NotificationPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List _list = [];
  bool _state = false;
  String _number = "";
  int _firmwareVersion = -1;
  List<int> _messageType = [];
  final List<int> _newMessageType = [];
  bool started = true;
  bool _loading = false;

  ReceivePort port = ReceivePort();
  bool hasPort = false;

  @override
  void initState() {
    super.initState();
    subscriptStream();
    // initPlatformState();
  }

  // static void _notificationCallback(NotificationEvent evt) {
  //   SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
  //   if (send == null) print("can't find the sender");
  //   send?.send(evt);
  // }
  //
  // Future<void> initPlatformState() async {
  //   if (Platform.isAndroid) {
  //     if (hasPort) {
  //       IsolateNameServer.removePortNameMapping("_listener_");
  //     }
  //     hasPort = IsolateNameServer.registerPortWithName(port.sendPort, "_listener_");
  //     NotificationsListener.initialize(callbackHandle: _notificationCallback);
  //     port.listen((message) => onData(message));
  //     var isR = await NotificationsListener.isRunning;
  //     setState(() {
  //       started = isR!;
  //     });
  //   }
  // }

  // void onData(NotificationEvent event) {
  //   if (_firmwareVersion != -1) {
  //     widget.blePlugin.sendMessage(
  //       MessageBean(
  //         message: event.text.toString(),
  //         type: BleMessageType.qq,
  //         versionCode: _firmwareVersion,
  //         isHs: true,
  //         isSmallScreen: true,
  //       ),
  //     );
  //   }
  // }

  // void startListening() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   var hasPermission = await NotificationsListener.hasPermission;
  //   if (!hasPermission!) {
  //     NotificationsListener.openPermissionSettings();
  //     return;
  //   }
  //
  //   var isR = await NotificationsListener.isRunning;
  //   if (!isR!) {
  //     await NotificationsListener.startService(
  //       foreground: true,
  //       title: "Listener Running",
  //       description: "Welcome to having me"
  //     );
  //   }
  //   setState(() {
  //     started = true;
  //     _loading = false;
  //   });
  // }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.callNumberEveStm.listen((String event) {
        if (!mounted) return;
        setState(() {
          _number = event;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Notification"),
            ),
            body: Center(
                child: ListView(children: [
                  Text("list: $_list"),
                  Text("state: $_state"),
                  Text("number: $_number"),
                  Text("firmwareVersion: $_firmwareVersion"),
                  Text("messageType: $_messageType"),
                  Text("newMessageType: $_newMessageType"),
                  // Text("started: $started"),
                  // Text("loading: $_loading"),

                  // ElevatedButton(onPressed: startListening, child: const Text("start"),),
                  ElevatedButton(
                    child: const Text('android:sendOtherMessageState'),
                    onPressed: () => widget.blePlugin.sendOtherMessageState(!_state),
                  ),
                  ElevatedButton(
                      child: const Text("android:queryOtherMessageState"),
                      onPressed: () async {
                        bool state = await widget.blePlugin.queryOtherMessageState;
                        setState(() {
                          _state = state;
                        });
                      }),
                  ElevatedButton(
                      child: const Text('queryMessageList'),
                      onPressed: () async {
                        List<int> messageType = await widget.blePlugin.queryMessageList;
                        setState(() {
                          _messageType = messageType;
                        });
                      }),
                  ElevatedButton(
                      child: const Text("queryFirmwareVersion"),
                      onPressed: () async {
                        String firmwareVersion = await widget.blePlugin.queryFirmwareVersion;
                        int index = firmwareVersion.lastIndexOf('-');
                        String subString = firmwareVersion.substring(index);
                        String version = '';
                        subString.replaceAllMapped(RegExp(r'\d'), (Match m) {
                          version += m[0]!;
                          return m[0]!;
                        });
                        setState(() {
                          _firmwareVersion = int.parse(version);
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(MessageInfo())'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.qq,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                    child: const Text('android:endCall()'),
                    onPressed: () => widget.blePlugin.endCall,
                  ),
                  ElevatedButton(
                    child: const Text('android:sendCallContactName()'),
                    onPressed: () => widget.blePlugin.sendCallContactName("嘿嘿"),
                  ),
                  ElevatedButton(
                    child: const Text('ios:setNotification()'),
                    onPressed: () => widget.blePlugin.setNotification([NotificationType.facebook, NotificationType.gmail, NotificationType.kakao]),
                  ),
                  ElevatedButton(
                      child: const Text('ios:getNotification'),
                      onPressed: () async {
                        List list = await widget.blePlugin.getNotification;
                        setState(() {
                          _list = list;
                        });
                      }),
                  Column(
                    children: [
                      const Text("Steps for new notification push status in iOS"),
                      ElevatedButton(
                          child: const Text('1. queryMessageList'),
                          onPressed: () async {
                            List<int> messageType = await widget.blePlugin.queryMessageList;
                            setState(() {
                              _messageType = messageType;
                            });
                          }),
                      ElevatedButton(
                        child: const Text('2. sendNotificationState'),
                        onPressed: () {
                          List<int> list = List.filled(_messageType.length, 0, growable: false);
                          list[2] = 1;
                          list[3] = 1;
                          widget.blePlugin.sendNotificationState(list);
                        },
                      ),
                      ElevatedButton(
                          child: const Text("3. queryNotificationState"),
                          onPressed: () async {
                            List<int> list = await widget.blePlugin.queryNotificationState;
                            setState(() {
                              _newMessageType.clear();
                              for (int i = 0; i < list.length; i++) {
                                if (list[i] == 1) {
                                  _newMessageType.add(_messageType[i]);
                                }
                              }
                            });
                          }),
                    ],
                  ),
                ]))));
  }
}