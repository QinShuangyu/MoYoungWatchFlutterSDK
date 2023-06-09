import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:io' as io;

import 'package:permission_handler/permission_handler.dart';


class Utils{

  static bool connectionStatus = false;

  Future<bool> checkBLEPermissions() async {
    if(Platform.isAndroid){
      if(await Permission.bluetoothConnect.isGranted && await Permission.bluetoothScan.isGranted
          && await Permission.location.isGranted && await Permission.bluetoothAdvertise.isGranted
      ){
        return true;
      }else{
        return false;
      }
    }else{
      if(await Permission.bluetooth.isGranted){
        return true;
      }else{
        return false;
      }
    }
  }

  requestBLEPermissions() async {
    if(Platform.isAndroid){
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.location,
      ].request();
      print(statuses);
    }else{
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth, Permission.locationWhenInUse
      ].request();
      print(statuses);
    }
  }

  void setConnectionStatus(bool status){
    connectionStatus = status;
  }

  bool getConnectionStatus(){
    return connectionStatus;
  }
}