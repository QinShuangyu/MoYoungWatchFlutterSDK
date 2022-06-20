import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

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
          title: const Text('Watch Flutter Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                  onPressed: requestPermissions,
                  child: Text(_permissionTxt)),
              ElevatedButton(
                  onPressed: startScan,
                  child: Text(_scanBtnTxt)),
              ElevatedButton(
                  onPressed: cancelScan,
                  child: Text(_cancelScanResult)),

              ElevatedButton(
                  onPressed: selectContact,
                  child: Text(_contactInfo)),

              Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text('${_deviceList[index].name},${_deviceList[index].address}'),
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

  void requestPermissions() {
    [Permission.location, Permission.storage, Permission.manageExternalStorage]
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




//创建时的代码
// import 'package:flutter/material.dart';
// import 'dart:async';
//
// import 'package:flutter/services.dart';
// import 'package:moyoung_bluetooth_plugin/moyoung_bluetooth_plugin.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String _platformVersion = 'Unknown';
//   final _moyoungBluetoothPlugin = MoyoungBluetoothPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // We also handle the message potentially returning null.
//     try {
//       platformVersion =
//           await _moyoungBluetoothPlugin.getPlatformVersion() ?? 'Unknown platform version';
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Text('Running on: $_platformVersion\n'),
//         ),
//       ),
//     );
//   }
// }
