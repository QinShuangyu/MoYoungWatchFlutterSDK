import 'dart:io';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:moyoung_ble_plugin_example/Global.dart';

Future<void> requestForegroundServicePermissionsAndroid() async {
  if (!Platform.isAndroid) {
    return;
  }
  
  // To restart the service on device reboot or unexpected problem, you need to allow below permission.
  if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
    // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
    await FlutterForegroundTask.requestIgnoreBatteryOptimization();
  }

  // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
  final NotificationPermission notificationPermissionStatus =
  await FlutterForegroundTask.checkNotificationPermission();
  if (notificationPermissionStatus != NotificationPermission.granted) {
    // This function requires `android.permission.POST_NOTIFICATIONS` permission.
    await FlutterForegroundTask.requestNotificationPermission();
  }
}

@pragma('vm:entry-point')
void ForegroundTaskCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}

class ForegroundTaskHandler extends TaskHandler {

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // TODO: implement onDestroy
    print('ForegroundTaskHandler: onDestroy');
  }

  //the below onEvent will be triggered based on the interval set in "WillStartForegroundTask"(main.dart)
  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    print('ForegroundTaskHandler: onEvent');
    MoYoungBle _blePlugin = Global.blePlugin;
    print(await _blePlugin.isConnected('DC:71:DD:50:00:8A'));
    _blePlugin.queryDeviceBattery;
    bool enableIncomingNumber = await _blePlugin.enableIncomingNumber(true);
    print(enableIncomingNumber);
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    print('ForegroundTaskHandler: onStart');
    print('pid: $pid');



    MoYoungBle _blePlugin = Global.blePlugin;
    bool isConnected = await _blePlugin.isConnected('DC:71:DD:50:00:8A');
    // bool isConnected = await _blePlugin.isConnected('F7:3F:2D:0B:F4:F0');
    // int time = await _blePlugin.queryTimeSystem;
    // print("onStart: $time");
    if (!isConnected) {
      // _blePlugin.connect(ConnectBean(autoConnect: true, address: 'F7:3F:2D:0B:F4:F0'));
      _blePlugin.connect(ConnectBean(autoConnect: false, address: 'DC:71:DD:50:00:8A'));
    }
    _blePlugin.deviceBatteryEveStm.listen(
          (DeviceBatteryBean event) {
          switch (event.type) {
            case DeviceBatteryType.deviceBattery:
              print("deviceBattery: ${event.deviceBattery!}");
              break;
            case DeviceBatteryType.subscribe:
              print(event.subscribe!);
              break;
            default:
              break;
          }
      },
    );
    // print('ForegroundTaskHandler: $isConnected');
  }

}