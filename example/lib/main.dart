import 'dart:async';

// import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:moyoung_ble_plugin_example/utils/toast_util.dart';

import 'Global.dart';
import 'modules/contact_list_page.dart';
import 'device.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'modules/demo.dart';

void main() {
  runApp(const MaterialApp(
    title: "moyoung ble demo",
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  // final MoYoungBle _blePlugin = MoYoungBle();
  final MoYoungBle _blePlugin = Global.blePlugin;
  String _permissionTxt = "requestPermissions()";
  String _scanBtnTxt = "startScan(10*1000)";
  String _cancelScanResult = "cancelScan()";
  String _contactInfo = 'skip 2 contacts';
  bool enableBluetooth = false;
  final List<BleScanBean> _deviceList = [];

  // --- 在此处设置您要过滤的设备名称关键字 ---
  // 如果设置为空字符串 ""，则会显示所有扫描到的设备。
  static const String _deviceNameFilter = ""; // 例如: "MoYoung", "Watch", "Band"

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.bleScanEveStm.listen(
        (BleScanBean event) async {
          setState(() {
            if (event.isCompleted) {
              //Scan completed, do something
            } else {
              // --- 修改: 添加过滤逻辑 ---
              // 如果过滤器为空，或设备名称包含过滤关键字，则添加设备
              debugPrint(
                  'Scanned Device: name=${event.name}, address=${event.address}');
              if (_deviceNameFilter.isEmpty ||
                  event.name
                      .toLowerCase()
                      .contains(_deviceNameFilter.toLowerCase())) {
                // 避免重复添加
                if (!_deviceList.any((d) => d.address == event.address)) {
                  _deviceList.add(event);
                }
              }
            }
          });
        },
      ),
    );

    // 订阅 GPS 事件流,确保原生层监听器被激活
    _streamSubscriptions.add(
      _blePlugin.gpsChangeEveStm.listen((GpsChangeEventBean event) {
        debugPrint('GPS事件: type=${event.type}');

        // EPO 相关事件处理
        if (event.type == 6 || event.type == 7) {
          debugPrint('收到手表GPS请求! type=${event.type}');

          // 显示手表上报的坐标信息 (如果有)
          if (event.location.isValid) {
            String gpsInfo =
                'Watch GPS: ${event.location.latitude}, ${event.location.longitude}';
            debugPrint(gpsInfo);
            // ToastUtil.show(gpsInfo, Toast.LENGTH_LONG);
          } else {
            debugPrint('Watch GPS Request: No valid location in event');
          }

          // type=6 是手表请求GPS位置 (UPDATEGPSLOCATIONCHANGE)
          // 手表在更新EPO前通常需要获取当前GPS位置以确定卫星数据
          // 必须回复位置信息，否则手表可能卡在等待位置状态，不会继续请求EPO数据
          // 这里获取手表坐标，实际项目中应使用 geolocator 获取真实坐标
        }
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Demo();
                      // return Demo(
                      //   blePlugin: _blePlugin,
                      //   device: device,
                      // );
                    }));
                  },
                  child: const Text("Demo")),
              ElevatedButton(
                  child: Text(_permissionTxt), onPressed: requestPermissions),
              ElevatedButton(
                  onPressed: checkBluetoothEnable,
                  child: Text("checkBluetoothPermission: $enableBluetooth")),
              ElevatedButton(child: Text(_scanBtnTxt), onPressed: startScan),
              ElevatedButton(
                  child: Text(_cancelScanResult), onPressed: cancelScan),
              ElevatedButton(
                  child: Text(_contactInfo), onPressed: selectContact),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(_deviceList[index].name +
                              ',' +
                              _deviceList[index].address),
                          onTap: () {
                            cancelScan();

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DevicePage(
                                device: _deviceList[index],
                              );
                            }));
                          });
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: Colors.blue,
                      );
                    },
                    itemCount: _deviceList.length),
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkBluetoothEnable() async {
    if (!mounted) return;
    bool _enableBluetooth = await _blePlugin.checkBluetoothEnable;
    if (!_enableBluetooth) {
      ToastUtil.show('Bluetooth not enabled', Toast.LENGTH_SHORT);
      // BluetoothEnable.enableBluetooth.then((value) {
      //   if (value == "true") {
      //     setState(() {
      //       enableBluetooth = true;
      //     });
      //   }
      // });
    }
    setState(() {
      enableBluetooth = _enableBluetooth;
    });
  }

  void requestPermissions() {
    [
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise
    ].request().then((value) => {
          setState(() {
            Map<Permission, PermissionStatus> statuses = value;
            if (statuses[Permission.location] == PermissionStatus.denied) {
              String permissionName = Permission.location.toString();
              _permissionTxt = "$permissionName is denied";
              return;
            }
            if (statuses[Permission.storage] == PermissionStatus.denied) {
              String permissionName = Permission.storage.toString();
              _permissionTxt = "$permissionName is denied";
              return;
            }

            _permissionTxt = "Permission is granted.";
          })
        });
  }

  void startScan() async {
    if (!mounted) return;
    // 检查定位和蓝牙权限
    var status = await Permission.location.status;
    var scanStatus = await Permission.bluetoothScan.status;
    var connectStatus = await Permission.bluetoothConnect.status;
    if (!status.isGranted ||
        !scanStatus.isGranted ||
        !connectStatus.isGranted) {
      await [
        Permission.location,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();
    }
    _blePlugin
        .startScan(10 * 1000)
        .then((value) => {
              setState(() {
                _scanBtnTxt = value ? "Scanning" : "Scan filed";
              })
            })
        .onError((error, stackTrace) => {print(error)});
  }

  Future<void> cancelScan() async {
    await _blePlugin.cancelScan;
    if (!mounted) return;
    setState(() {
      _cancelScanResult = 'cancelScan()';
    });
  }

  Future<void> selectContact() async {
    final Contact contact = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlutterContactsExample(pageContext: context),
        ));

    if (!mounted) return;

    setState(() {
      String name = contact.name.toString();
      String phone = contact.phones.first.toString();
      _contactInfo = '$name, $phone';
    });
  }
}
