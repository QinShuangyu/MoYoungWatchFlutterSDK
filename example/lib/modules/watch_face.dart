import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';
import 'package:path_provider/path_provider.dart';

class WatchFacePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const WatchFacePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<WatchFacePage> createState() {
    return _WatchFacePage();
  }
}

class _WatchFacePage extends State<WatchFacePage> {
  WatchFaceLayoutBean? _watchFaceLayoutInfo;
  String _backgroundPictureMd5 = '';
  String _compressionType = '';
  int _height = -1;
  int _textColor = -1;
  int _thumHeight = -1;
  int _thumWidth = -1;
  int _timeBottomContent = -1;
  int _timePosition = -1;
  int _timeTopContent = -1;
  int _width = -1;
  String _firmwareVersion = "";
  SupportWatchFaceBean? _supportWatchFaceInfo;
  int _displayWatchFace = -1;
  List<int> _supportWatchFaceList = [];
  List<WatchFaceBean> _watchFacelist = [];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _progress = -1;
  int _error = -1;
  int type = 0;
  int _code = -1;
  WatchFace? _watchFace;
  int _id = -1;
  String _preview = "";
  String _file = "";

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    var fileTransEveStm = widget.blePlugin.fileTransEveStm.listen(
          (FileTransBean event) {
        setState(() {
          switch(event.type) {
            case TransType.transStart:
              break;
            case TransType.transChanged:
              _progress = event.progress!;
              break;
            case TransType.transCompleted:
              break;
            case TransType.error:
              _error = event.error!;
              break;
            default:
              break;
          }
        });
      },
    );
    fileTransEveStm.onError((error) {
    });
    _streamSubscriptions.add(fileTransEveStm);

    _streamSubscriptions.add(
      widget.blePlugin.wfFileTransEveStm.listen(
            (FileTransBean event) {
          setState(() {
            switch(event.type) {
              case TransType.transStart:
                break;
              case TransType.transChanged:
                _progress = event.progress!;
                break;
              case TransType.transCompleted:
                _progress = event.progress!;
                break;
              case TransType.error:
                _error = event.error!;
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
              title: const Text("WatchFace"),
            ),
            body: Center(child: ListView(children: [
              Text("displayWatchFace: $_displayWatchFace"),
              Text("progress: $_progress"),
              Text("error: $_error"),
              Text("firmwareVersion: $_firmwareVersion"),
              Text("backgroundPictureMd5: $_backgroundPictureMd5"),
              Text("compressionType: $_compressionType"),
              Text("height: $_height"),
              Text("textColor: $_textColor"),
              Text("thumHeight: $_thumHeight"),
              Text("thumWidth: $_thumWidth"),
              Text("timeBottomContent: $_timeBottomContent"),
              Text("timePosition: $_timePosition"),
              Text("timeTopContent: $_timeTopContent"),
              Text("width: $_width"),
              Text("supportWatchFaceList: $_supportWatchFaceList"),
              Text("watchFacelist: $_watchFacelist"),
              Text("code: $_code"),
              Text("id: $_id"),
              Text("preview: $_preview"),
              Text("file: $_file"),

              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(FIRST_WATCH_FACE)'),
                  onPressed: () => widget.blePlugin
                      .sendDisplayWatchFace(WatchFaceType.firstWatchFace)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(SECOND_WATCH_FACE)'),
                  onPressed: () => widget.blePlugin
                      .sendDisplayWatchFace(WatchFaceType.secondWatchFace)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(THIRD_WATCH_FACE)'),
                  onPressed: () => widget.blePlugin
                      .sendDisplayWatchFace(WatchFaceType.thirdWatchFace)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(NEW_CUSTOMIZE_WATCH_FACE)'),
                  onPressed: () => widget.blePlugin
                      .sendDisplayWatchFace(WatchFaceType.newCustomizeWatchFace)),
              ElevatedButton(
                  child: const Text('queryDisplayWatchFace()'),
                  onPressed: () async {
                    int displayWatchFace =  await widget.blePlugin.queryDisplayWatchFace;
                    setState(() {
                      _displayWatchFace = displayWatchFace;
                    });
                  }),
              ElevatedButton(
                  child: const Text('queryWatchFaceLayout()'),
                  onPressed: () async {
                    _watchFaceLayoutInfo = await widget.blePlugin.queryWatchFaceLayout;
                    setState(() {
                      _backgroundPictureMd5 = _watchFaceLayoutInfo!.backgroundPictureMd5;
                      _compressionType = _watchFaceLayoutInfo!.compressionType;
                      _height = _watchFaceLayoutInfo!.height;
                      _textColor = _watchFaceLayoutInfo!.textColor;
                      _thumHeight = _watchFaceLayoutInfo!.thumHeight;
                      _thumWidth = _watchFaceLayoutInfo!.thumWidth;
                      _timeBottomContent = _watchFaceLayoutInfo!.timeBottomContent;
                      _timePosition = _watchFaceLayoutInfo!.timePosition;
                      _timeTopContent = _watchFaceLayoutInfo!.timeTopContent;
                      _width = _watchFaceLayoutInfo!.width;
                    });
                  }),
              ElevatedButton(
                  child: const Text(
                      'sendWatchFaceLayout(CrpWatchFaceLayoutInfo(2)'),
                  onPressed: () => {
                    if (_watchFaceLayoutInfo != null) {
                      widget.blePlugin.sendWatchFaceLayout(_watchFaceLayoutInfo!)}
                  }),
              ElevatedButton(
                  child: const Text('sendWatchFaceBackground()'),
                  onPressed: () => {
                    if (_watchFaceLayoutInfo != null) {
                      sendWatchFaceBackground()
                    }
                  }),
              ElevatedButton(
                  child: const Text('querySupportWatchFace()'),
                  onPressed: () async {
                    _supportWatchFaceInfo = await widget.blePlugin.querySupportWatchFace;
                    setState(() {
                      _displayWatchFace = _supportWatchFaceInfo!.displayWatchFace;
                      _supportWatchFaceList = _supportWatchFaceInfo!.supportWatchFaceList;
                    });
                  }),
              ElevatedButton(
                  child: const Text("queryFirmwareVersion()"),
                  onPressed: queryFirmwareVersion),
              ElevatedButton(
                  child: const Text('queryWatchFaceStore()'),
                  onPressed: () async {
                    if (_firmwareVersion != "" && _supportWatchFaceInfo != null) {
                      List<WatchFaceBean> watchFacelist = await widget.blePlugin.queryWatchFaceStore(
                          WatchFaceStoreBean(
                              watchFaceSupportList: _supportWatchFaceList,
                              firmwareVersion: _firmwareVersion,
                              pageCount: 9,
                              pageIndex: 1));
                      setState(() {
                         _watchFacelist = watchFacelist;
                      });
                    }}),
              ElevatedButton(
                  child: const Text('queryWatchFaceOfID()'),
                  onPressed: () async {
                    if (_displayWatchFace != -1) {
                      WatchFaceIdBean watchFaceIdBean = await widget.blePlugin.queryWatchFaceOfID(_displayWatchFace);
                      setState(() {
                        _code = watchFaceIdBean.code;
                        _watchFace = watchFaceIdBean.watchFace;
                        _id = _watchFace!.id!;
                        _preview = _watchFace!.preview!;
                        _file = _watchFace!.file!;
                      });
                    }
                  }),
              ElevatedButton(
                  child: const Text('sendWatchFace(_watchFacelist)'),
                  onPressed: () => sendWatchFace(_watchFacelist[1])),
            ])
            )
        )
    );
  }

  sendWatchFaceBackground() async {
    String filePath = "assets/images/text.png";
    ByteData bytes = await rootBundle.load(filePath);
    Uint8List logoUint8List = bytes.buffer.asUint8List();

    WatchFaceBackgroundBean bgBean=WatchFaceBackgroundBean(
      bitmap: logoUint8List,
      thumbBitmap: logoUint8List,
      type:_watchFaceLayoutInfo!.compressionType,
      width: _watchFaceLayoutInfo!.width,
      height: _watchFaceLayoutInfo!.height,
      thumbWidth: _watchFaceLayoutInfo!.thumWidth,
      thumbHeight: _watchFaceLayoutInfo!.thumHeight,
    );
    widget.blePlugin.sendWatchFaceBackground(bgBean);
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

  sendWatchFace(WatchFaceBean watchFaceBean) async {
    //Download the file and save
    int index= watchFaceBean.file!.lastIndexOf('/');
    String name=watchFaceBean.file!.substring(index,watchFaceBean.file!.length);
    String pathFile = "";
    await getApplicationDocumentsDirectory().then((value) => pathFile = value.path + name);

    BaseOptions options = BaseOptions(
      baseUrl: watchFaceBean.file!,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);
    await dio.download(watchFaceBean.file!, pathFile);

    //call native interface
    CustomizeWatchFaceBean info =
        CustomizeWatchFaceBean(index: watchFaceBean.id!, file: pathFile);
    await widget.blePlugin.sendWatchFace(
        SendWatchFaceBean(watchFaceFlutterBean: info, timeout: 30));
  }
}
