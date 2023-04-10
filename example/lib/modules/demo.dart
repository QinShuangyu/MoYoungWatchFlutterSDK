// import 'dart:async';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:flutter_notification_listener/flutter_notification_listener.dart';
// import 'package:moyoung_ble_plugin/moyoung_ble.dart';
//
// class Demo extends StatefulWidget {
//   final MoYoungBle blePlugin;
//   final BleScanBean device;
//
//   const Demo({Key? key, required this.blePlugin, required this.device}) : super(key: key);
//
//   @override
//   State<Demo> createState() => _DemoState();
// }
//
// // The callback function should always be a top-level function.
// @pragma('vm:entry-point')
// void startCallback() {
//   // The setTaskHandler function must be called to handle the task in the background.
//   FlutterForegroundTask.setTaskHandler(MyTaskHandler());
// }
//
// class _DemoState extends State<Demo> with WidgetsBindingObserver {
//   bool started = true;
//   bool _loading = false;
//
//   ReceivePort port = ReceivePort();
//   bool hasPort = false;
//
//   ReceivePort? _receivePort;
//
//   T? _ambiguate<T>(T? value) => value;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     initPlatformState();
//     _initForegroundTask();
//     _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
//       // You can get the previous ReceivePort without restarting the service.
//       if (await FlutterForegroundTask.isRunningService) {
//         final newReceivePort = FlutterForegroundTask.receivePort;
//         _registerReceivePort(newReceivePort);
//       }
//     });
//   }
//
//   void backgroundTaskCallback() async {
//     /// 连接蓝牙设备
//   }
//
//   void _initForegroundTask() {
//     FlutterForegroundTask.init(
//       androidNotificationOptions: AndroidNotificationOptions(
//         channelId: 'notification_channel_id',
//         channelName: 'Foreground Notification',
//         channelDescription:
//         'This notification appears when the foreground service is running.',
//         channelImportance: NotificationChannelImportance.LOW,
//         priority: NotificationPriority.LOW,
//         iconData: const NotificationIconData(
//           resType: ResourceType.mipmap,
//           resPrefix: ResourcePrefix.ic,
//           name: 'launcher',
//           backgroundColor: Colors.orange,
//         ),
//         buttons: [
//           const NotificationButton(id: 'sendButton', text: 'Send'),
//           const NotificationButton(id: 'testButton', text: 'Test'),
//         ],
//         isSticky: true,
//       ),
//       iosNotificationOptions: const IOSNotificationOptions(
//         showNotification: true,
//         playSound: false,
//       ),
//       foregroundTaskOptions: const ForegroundTaskOptions(
//         interval: 5000,
//         isOnceEvent: false,
//         autoRunOnBoot: true,
//         allowWakeLock: true,
//         allowWifiLock: true,
//       ),
//     );
//   }
//
//   Future<bool> _startForegroundTask() async {
//     if (!await FlutterForegroundTask.canDrawOverlays) {
//       final isGranted =
//       await FlutterForegroundTask.openSystemAlertWindowSettings();
//       if (!isGranted) {
//         print('SYSTEM_ALERT_WINDOW permission denied!');
//         return false;
//       }
//     }
//
//     // You can save data using the saveData function.
//     await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
//
//     // Register the receivePort before starting the service.
//     final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
//     final bool isRegistered = _registerReceivePort(receivePort);
//     if (!isRegistered) {
//       print('Failed to register receivePort!');
//       return false;
//     }
//
//     if (await FlutterForegroundTask.isRunningService) {
//       return FlutterForegroundTask.restartService();
//     } else {
//       return FlutterForegroundTask.startService(
//         notificationTitle: 'Foreground Service is running',
//         notificationText: 'Tap to return to the app',
//         callback: startCallback,
//       );
//     }
//   }
//
//   Future<bool> _stopForegroundTask() {
//     return FlutterForegroundTask.stopService();
//   }
//
//   /// 返回应用程序是否已从电池优化中排除
//   Future<bool> _isIgnoringBatteryOptimizations() async {
//     return await FlutterForegroundTask.isIgnoringBatteryOptimizations;
//   }
//
//   /// 打开设置页面，在其中设置忽略电池优化
//   Future<bool> _openIgnoreBatteryOptimizationSettings() async {
//     bool isIgnoringBatteryOptimizations = await _isIgnoringBatteryOptimizations();
//     if (isIgnoringBatteryOptimizations) {
//       return false;
//     }
//     return await FlutterForegroundTask.openIgnoreBatteryOptimizationSettings();
//   }
//
//   /// 请求忽略电池优化需要获取权限
//   Future<bool> _requestIgnoreBatteryOptimization() async {
//     return await FlutterForegroundTask.requestIgnoreBatteryOptimization();
//   }
//
//   // 如果应用程序未运行则启动该应用程序
//   void launchApp() {
//     FlutterForegroundTask.launchApp();
//   }
//
//   Future<bool> _isAppOnForeground() async {
//     return await FlutterForegroundTask.isAppOnForeground;
//   }
//
//   bool _registerReceivePort(ReceivePort? newReceivePort) {
//     if (newReceivePort == null) {
//       return false;
//     }
//
//     _closeReceivePort();
//
//     _receivePort = newReceivePort;
//     _receivePort?.listen((message) {
//       if (message is int) {
//       } else if (message is String) {
//         if (message == 'onNotificationPressed') {
//           print("router");
//         }
//       } else if (message is DateTime) {
//         print('timestamp: ${message.toString()}');
//       }
//     });
//
//     return _receivePort != null;
//   }
//
//   void _closeReceivePort() {
//     _receivePort?.close();
//     _receivePort = null;
//   }
//
//   static void _notificationCallback(NotificationEvent evt) {
//     SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
//     if (send == null) print("can't find the sender");
//     send?.send(evt);
//   }
//
//   Future<void> initPlatformState() async {
//     if (Platform.isAndroid) {
//       if (hasPort) {
//         IsolateNameServer.removePortNameMapping("_listener_");
//       }
//       hasPort = IsolateNameServer.registerPortWithName(port.sendPort, "_listener_");
//       NotificationsListener.initialize(callbackHandle: _notificationCallback);
//       port.listen((message) => onData(message));
//       var isR = await NotificationsListener.isRunning;
//       setState(() {
//         started = isR!;
//       });
//     }
//   }
//
//   void onData(NotificationEvent event) {
//     widget.blePlugin.sendMessage(
//       MessageBean(
//         message: event.text.toString(),
//         type: BleMessageType.qq,
//         versionCode: 207,
//         isHs: true,
//         isSmallScreen: true,
//       ),
//     );
//   }
//
//   void startListening() async {
//     setState(() {
//       _loading = true;
//     });
//     var hasPermission = await NotificationsListener.hasPermission;
//     if (!hasPermission!) {
//       NotificationsListener.openPermissionSettings();
//       return;
//     }
//
//     var isR = await NotificationsListener.isRunning;
//     if (!isR!) {
//       await NotificationsListener.startService(foreground: true, title: "Listener Running", description: "Welcome to having me");
//     }
//     setState(() {
//       started = true;
//       _loading = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.paused:
//         launchApp();
//         print("state: paused，处于后台");
//         break;
//       case AppLifecycleState.detached:
//         launchApp();
//         widget.blePlugin.connect(widget.device.address);
//         print("state: detached，应用程序已关闭");
//         break;
//       default:
//         break;
//     }
//     super.didChangeAppLifecycleState(state);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Notification"),
//         ),
//         body: Center(
//           child: ListView(children: [
//             Text("started: $started"),
//             Text("loading: $_loading"),
//
//             ElevatedButton(onPressed: startListening, child: const Text("startListening"),),
//             ElevatedButton(onPressed: _startForegroundTask, child: const Text("startForegroundTask"),),
//             ElevatedButton(onPressed: _openIgnoreBatteryOptimizationSettings, child: const Text("openIgnoreBatteryOptimizationSettings"),),
//             ElevatedButton(onPressed: launchApp, child: const Text("launchApp"),),
//             ElevatedButton(onPressed: _stopForegroundTask, child: const Text("stopForegroundTask"),),
//           ]
//         ),
//       ),
//     ));
//   }
// }
//
// class MyTaskHandler extends TaskHandler {
//   SendPort? _sendPort;
//   int _eventCount = 0;
//
//   @override
//   Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
//     _sendPort = sendPort;
//
//     // You can use the getData function to get the stored data.
//     final customData =
//     await FlutterForegroundTask.getData<String>(key: 'customData');
//     print('customData: $customData');
//   }
//
//   @override
//   Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
//     FlutterForegroundTask.updateService(
//       notificationTitle: 'MyTaskHandler',
//       notificationText: 'eventCount: $_eventCount',
//     );
//
//     // Send data to the main isolate.
//     sendPort?.send(_eventCount);
//
//     _eventCount++;
//   }
//
//   @override
//   Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
//     // You can use the clearAllData function to clear all the stored data.
//     print("onDestroy：关闭应用");
//     await FlutterForegroundTask.clearAllData();
//   }
//
//   @override
//   void onButtonPressed(String id) {
//     // Called when the notification button on the Android platform is pressed.
//     print('onButtonPressed >> $id');
//   }
//
//   @override
//   void onNotificationPressed() {
//     // Called when the notification itself on the Android platform is pressed.
//     //
//     // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
//     // this function to be called.
//
//     // Note that the app will only route to "/resume-route" when it is exited so
//     // it will usually be necessary to send a message through the send port to
//     // signal it to restore state when the app is already started.
//     FlutterForegroundTask.launchApp("/resume-route");
//     _sendPort?.send('onNotificationPressed');
//   }
// }