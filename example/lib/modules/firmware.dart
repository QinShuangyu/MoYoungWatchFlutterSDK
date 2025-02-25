import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:path_provider/path_provider.dart';

class FirmwarePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  final BleScanBean device;

  const FirmwarePage({Key? key, required this.blePlugin, required this.device}) : super(key: key);

  @override
  State<FirmwarePage> createState() {
    return _FirmwarePage();
  }
}

class _FirmwarePage extends State<FirmwarePage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String _firmwareVersion = "queryFirmwareVersion()";
  String _newFirmwareInfo = "checkFirmwareVersion()";
  int? _oTAType;
  UpgradeErrorBean? _upgradeError;
  int _error = -1;
  String _errorContent = "";
  int _upgradeProgress = -1;
  String _hsOtaAddress = "";
  int _deviceOtaStatus = -1;
  int _otaType = -1;
  String _customizeVersion = "";
  String _uuid = "";
  String upgradeFilePath = "";
  String pathname = "https://p.moyoung.com/uploads/jieli/V37_QIpBxMKILvdR5SYRGAhsUVx3CTAxdIxV/fZaBQ5zVwUMPiM4mxHBWBEGe6XzeC5P6.ufw";

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      widget.blePlugin.oTAEveStm.listen(
        (OTABean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case OTAProgressType.downloadStart:
                break;
              case OTAProgressType.downloadComplete:
                break;
              case OTAProgressType.progressStart:
                break;
              case OTAProgressType.progressChanged:
                _upgradeProgress = event.upgradeProgress!;
                break;
              case OTAProgressType.upgradeCompleted:
                break;
              case OTAProgressType.upgradeAborted:
                break;
              case OTAProgressType.error:
                _upgradeError = event.upgradeError!;
                _error = _upgradeError!.error!;
                _errorContent = _upgradeError!.errorContent!;
                break;
              default:
                break;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Firmware"),
        ),
        body: Center(
            child: ListView(children: <Widget>[
          Text("upgradeProgress: $_upgradeProgress"),
          Text("error: $_error"),
          Text("errorContent: $_errorContent"),
          Text("deviceOtaStatus: $_deviceOtaStatus"),
          Text("hsOtaAddress: $_hsOtaAddress"),
          Text("OtaType: $_otaType"),
          Text("customizeVersion: $_customizeVersion"),
          Text("uuid: $_uuid"),
          ElevatedButton(child: Text(_firmwareVersion), onPressed: queryFirmwareVersion),
          ElevatedButton(
              child: const Text("queryCustomizeVersion"),
              onPressed: () async {
                String customizeVersion = await widget.blePlugin.queryCustomizeVersion;
                setState(() {
                  _customizeVersion = customizeVersion;
                });
              }),
          ElevatedButton(child: Text(_newFirmwareInfo), onPressed: () => checkFirmwareVersion(_firmwareVersion, OTAType.normalUpgradeType)),
          ElevatedButton(
              child: const Text('queryHsOtaAddress()'),
              onPressed: () async {
                String hsOtaAddress = await widget.blePlugin.queryHsOtaAddress;
                setState(() {
                  _hsOtaAddress = hsOtaAddress;
                });
              }),
          ElevatedButton(
              child: const Text('startOTA(hsOtaAddress)'),
              onPressed: () => startOTA(widget.device.address)),
          ElevatedButton(
              child: const Text('startOTA(address)'),
              onPressed: () => startOTA(widget.device.address)),
          ElevatedButton(child: const Text('abortOTA(oTAType)'), onPressed: () => widget.blePlugin.abortOTA(_oTAType!)),
          ElevatedButton(
              child: const Text('queryDeviceOtaStatus()'),
              onPressed: () async {
                int deviceOtaStatus = await widget.blePlugin.queryDeviceOtaStatus;
                setState(() {
                  _deviceOtaStatus = deviceOtaStatus;
                });
              }),
          ElevatedButton(child: const Text('enableHsOta()'), onPressed: () => widget.blePlugin.enableHsOta),
          ElevatedButton(
              child: const Text('queryOtaType()'),
              onPressed: () async {
                int otaType = await widget.blePlugin.queryOtaType;
                setState(() {
                  _otaType = otaType;
                });
              }),
          ElevatedButton(
              onPressed: () async {
                String uuid = await widget.blePlugin.queryUUID;
                setState(() {
                  _uuid = uuid;
                });
              },
              child: const Text('iOS：queryUUID')),
          ElevatedButton(
              onPressed: () => startOTA(upgradeFilePath),
              child: const Text('sifliStartOTA')),

          ElevatedButton(
              onPressed: () => startOTA(pathname),
              child: const Text('jieliStartOTA')),

          ElevatedButton(
              onPressed: () async {
                widget.blePlugin.abortOTA(OTAMcuType.startJieliOta);
              },
              child: const Text('jieliAbortOTA')),
        ])),
      ),
    );
  }

  Future<void> queryFirmwareVersion() async {
    String firmwareVersion = await widget.blePlugin.queryFirmwareVersion;
    if (!mounted) {
      return;
    }
    setState(() {
      _firmwareVersion = firmwareVersion;
    });
  }

  Future<void> checkFirmwareVersion(String version, int oTAType) async {
    CheckFirmwareVersionBean versionInfo = await widget.blePlugin.checkFirmwareVersion(FirmwareVersion(version: version, otaType: oTAType));
    if (!mounted) {
      return;
    }
    setState(() {
      _newFirmwareInfo = checkFirmwareVersionBeanToJson(versionInfo);
    });
  }

  Future<void> startOTA(String address) async {
    await widget.blePlugin.startOTA(OtaBean(address: address, type: widget.device.platform));
  }

  ///获取下载路径
  Future<String> getPathFile(String file) async {
    int index = file.lastIndexOf('/');
    String name = file.substring(index, file.length);
    String pathFile = "";
    await getApplicationDocumentsDirectory().then((value) => pathFile = value.path + name);
    return pathFile;
  }

  ///下载文件
  Future<void> downloadFile(String file) async {
    String pathFile = await getPathFile(file);
    BaseOptions options = BaseOptions(
      baseUrl: file,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);
    await dio
        .download(file, pathFile, onReceiveProgress: (received, total) {})
        .then((value) => {widget.blePlugin.startOTA(OtaBean(address: pathFile, type: OTAMcuType.startJieliOta))})
        .onError((error, stackTrace) => {});
  }
}
