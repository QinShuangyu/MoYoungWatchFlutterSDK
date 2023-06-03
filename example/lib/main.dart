import 'dart:async';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import 'modules/contact_list_page.dart';
import 'device.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final MoYoungBle _blePlugin = MoYoungBle();

  String _permissionTxt = "requestPermissions()";
  String _scanBtnTxt = "startScan(10*1000)";
  String _cancelScanResult = "cancelScan()";
  String _contactInfo = 'skip 2 contacts';
  bool enableBluetooth = false;
  final List<BleScanBean> _deviceList = [];


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
              _deviceList.add(event);
            }
          });
        },
      ),
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
                  child: Text(_permissionTxt),
                  onPressed: requestPermissions),
              ElevatedButton(onPressed: checkBluetoothEnable, child: Text("checkBluetoothPermission: $enableBluetooth")),
              ElevatedButton(
                  child: Text(_scanBtnTxt),
                  onPressed: startScan),
              ElevatedButton(
                  child: Text(_cancelScanResult),
                  onPressed: cancelScan),

              ElevatedButton(
                  child: Text(_contactInfo),
                  onPressed: selectContact),

              Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(_deviceList[index].name + ',' + _deviceList[index].address),
                          onTap: () {
                            cancelScan();

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return DevicePage(
                                    device : _deviceList[index],
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
      BluetoothEnable.enableBluetooth.then((value) {
        if (value == "true") {
          setState(() {
            enableBluetooth = true;
          });
        }
      });
    }
    setState(() {
      enableBluetooth = _enableBluetooth;
    });
  }

  void requestPermissions() {
    [Permission.location, Permission.storage, Permission.manageExternalStorage,
      Permission.bluetoothConnect, Permission.bluetoothScan, Permission.bluetoothAdvertise]
        .request().then((value) => {
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

  void startScan() {
    if (!mounted) return;
    _blePlugin.startScan(10*1000).then((value) => {
      setState(() {
        _scanBtnTxt = value ? "Scanning" : "Scan filed";
      })
    }).onError((error, stackTrace) => {
      print(error)
    });
  }

  Future<void> cancelScan() async {
     await _blePlugin.cancelScan;
    if (!mounted) return;
    setState(() {
      _cancelScanResult = 'cancelScan()';
    });
  }

  Future<void> selectContact() async {
    final Contact contact = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => FlutterContactsExample(pageContext: context),
      )
    );

    if (!mounted) return;

    setState(() {
      String name = contact.name.toString();
      String phone = contact.phones.first.toString();
      _contactInfo = '$name, $phone';
    });
  }
}
