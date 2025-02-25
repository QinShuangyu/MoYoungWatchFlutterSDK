import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import '../Utils.dart';
import '../foregroundTaskHandler.dart';

class Demo extends StatefulWidget {
  // final MoYoungBle blePlugin;
  // final BleScanBean device;

  // const Demo({Key? key, required this.blePlugin, required this.device}) : super(key: key);
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillStartForegroundTask(
        onWillStart: () async {
          // Return whether to start the foreground service.
          return true;
        },
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'foreground_channel_id',
          channelName: 'Foreground Notification',
          channelDescription: 'This notification appears when the foreground service is running.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          iconData: const NotificationIconData(
            resType: ResourceType.mipmap,
            resPrefix: ResourcePrefix.ic,
            name: 'launcher',
          ),
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: false,
          playSound: false,
        ),
        foregroundTaskOptions: const ForegroundTaskOptions(
          interval: 5000, // 5 seconds
          autoRunOnBoot: false,
          allowWifiLock: false,
        ),
        notificationTitle: '',
        notificationText: '',
        callback: ForegroundTaskCallback,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Demo"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      Utils().checkBLEPermissions().then((value) {
                        if (!value) {
                          Utils().requestBLEPermissions();
                        }
                      });
                    },
                    child: Text('request Permissions')),
                TextButton(
                    onPressed: () {
                      requestForegroundServicePermissionsAndroid();
                    },
                    child: Text('request Permissions 2')),
                // TextButton(
                //     onPressed: () {
                //       widget.blePlugin.connect(ConnectBean(autoConnect: false, address: 'DC:71:DD:50:00:8A'));
                //     },
                //     child: Text('connect to watch')
                // )
              ],
            ),
          ),
        ));
  }
}
