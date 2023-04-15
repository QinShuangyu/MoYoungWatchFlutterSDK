import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
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
  List<int> _newMessageType = [];
  bool started = true;

  ReceivePort port = ReceivePort();
  bool hasPort = false;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

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
                      child: const Text('sendMessage(facebook)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.facebook,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(twitter)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.twitter,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(whatsApp)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.whatsApp,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(messenger)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.messenger,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(telegram)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.telegram,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(gmail)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.gmail,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(uber)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.uber,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(snapchat)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.snapchat,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(linkEdin)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.linkEdin,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(amazon)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.amazon,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(tiktok)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.tiktok,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(lyft)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.lyft,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(mail)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.mail,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(googleMaps)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.googleMaps,
                                versionCode: _firmwareVersion,
                                isHs: true,
                                isSmallScreen: true,
                              ),
                            );
                          }
                        });
                      }),
                  ElevatedButton(
                      child: const Text('sendMessage(slack)'),
                      onPressed: () {
                        Timer(const Duration(seconds: 10), () {
                          if (_firmwareVersion != -1) {
                            widget.blePlugin.sendMessage(
                              MessageBean(
                                message: 'message',
                                type: BleMessageType.slack,
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
                  Column(
                    children: [
                      const Text("iOS old version of the news push."),
                      ElevatedButton(
                        child: const Text('1. ios:setNotification()'),
                        onPressed: () => widget.blePlugin.setNotification([NotificationType.facebook, NotificationType.gmail, NotificationType.kakao]),
                      ),
                      ElevatedButton(
                          child: const Text('2. ios:getNotification'),
                          onPressed: () async {
                            List list = await widget.blePlugin.getNotification;
                            setState(() {
                              _list = list;
                            });
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("New version of the iOS news push."),
                      ElevatedButton(
                          child: const Text('1. queryMessageList'),
                          onPressed: () async {
                            List<int> messageType = await widget.blePlugin.queryMessageList;
                            setState(() {
                              _messageType = messageType;
                            });
                          }),
                      ElevatedButton(
                        child: const Text('2. ios:setNotification()'),
                        onPressed: () {
                          List<int> list = List.filled(_messageType.length, 0, growable: false);
                          list[2] = 1;
                          list[3] = 1;
                          widget.blePlugin.setNotification(list);
                        },
                      ),
                      ElevatedButton(
                          child: const Text('3. ios:getNotification'),
                          onPressed: () async {
                            List list = await widget.blePlugin.getNotification;
                            _newMessageType.clear();
                            setState(() {
                              for (int i = 0; i < list.length; i++) {
                                _newMessageType.add(_messageType[i]);
                              }
                            });
                          }),
                    ],
                  ),
                ]))));
  }
}