import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
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
  int _size = 0;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    var fileTransEveStm = widget.blePlugin.fileTransEveStm.listen(
      (FileTransBean event) {
        setState(() {
          switch (event.type) {
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
    fileTransEveStm.onError((error) {});
    _streamSubscriptions.add(fileTransEveStm);

    _streamSubscriptions.add(
      widget.blePlugin.wfFileTransEveStm.listen(
        (FileTransBean event) {
          setState(() {
            switch (event.type) {
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
            body: Center(
                child: ListView(children: [
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
              Text("size: $_size"),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(FIRST_WATCH_FACE)'),
                  onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.firstWatchFace)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(SECOND_WATCH_FACE)'),
                  onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.secondWatchFace)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(THIRD_WATCH_FACE)'),
                  onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.thirdWatchFace)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(NEW_CUSTOMIZE_WATCH_FACE)'),
                  onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.newCustomizeWatchFace)),
              ElevatedButton(
                  child: const Text('queryDisplayWatchFace()'),
                  onPressed: () async {
                    int displayWatchFace = await widget.blePlugin.queryDisplayWatchFace;
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
                  child: const Text('sendWatchFaceLayout(CrpWatchFaceLayoutInfo(2)'),
                  onPressed: () => {
                        if (_watchFaceLayoutInfo != null) {widget.blePlugin.sendWatchFaceLayout(_watchFaceLayoutInfo!)}
                      }),
              ElevatedButton(
                  child: const Text('sendWatchFaceBackground()'),
                  onPressed: () => {
                        if (_watchFaceLayoutInfo != null) {sendWatchFaceBackground()}
                      }),
              ElevatedButton(child: const Text("abortWatchFaceBackground()"), onPressed: () => widget.blePlugin.abortWatchFaceBackground),
              ElevatedButton(
                  child: const Text('querySupportWatchFace()'),
                  onPressed: () async {
                    _supportWatchFaceInfo = await widget.blePlugin.querySupportWatchFace;
                    setState(() {
                      _displayWatchFace = _supportWatchFaceInfo!.displayWatchFace;
                      _supportWatchFaceList = _supportWatchFaceInfo!.supportWatchFaceList;
                    });
                  }),
              ElevatedButton(child: const Text("queryFirmwareVersion()"), onPressed: queryFirmwareVersion),
              ElevatedButton(
                  child: const Text('queryWatchFaceStore()'),
                  onPressed: () async {
                    if (_firmwareVersion != "" && _supportWatchFaceInfo != null) {
                      List<WatchFaceBean> watchFacelist = await widget.blePlugin.queryWatchFaceStore(WatchFaceStoreBean(
                          watchFaceSupportList: _supportWatchFaceList, firmwareVersion: _firmwareVersion, pageCount: 9, pageIndex: 1));
                      setState(() {
                        _watchFacelist = watchFacelist;
                      });
                    }
                  }),
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
              ElevatedButton(child: const Text('sendWatchFace(_watchFacelist)'), onPressed: () => sendWatchFace(_watchFacelist[1])),
              ElevatedButton(child: const Text("abortWatchFace()"), onPressed: () => widget.blePlugin.abortWatchFace),
              ElevatedButton(child: const Text("deleteWatchFace()"), onPressed: () => widget.blePlugin.deleteWatchFace(_id)),
              ElevatedButton(
                  child: const Text("queryAvailableStorage()"),
                  onPressed: () async {
                    int size = await widget.blePlugin.queryAvailableStorage;
                    setState(() {
                      _size = size;
                    });
                  }),
              ElevatedButton(
                  child: const Text('localFileUpload'),
                  onPressed: () =>
                  // downloadFile("https://qcdn.moyoung.com/files/dc66671e34e4ca2141865daa51867a4c.bin")
                  widget.blePlugin.uploadLocalFile('/var/mobile/Containers/Data/Application/8B15D347-DFFC-40F6-922E-32829C88ADA2/Documents/dc66671e34e4ca2141865daa51867a4c.bin')
                      // downloadFile("https://qcdn.moyoung.com/files/eba893d5cfe9da43072d9d182851bbd7.bin")
              // widget.blePlugin.uploadLocalFile('/var/mobile/Containers/Data/Application/07C22EAF-AF5F-4F5B-9242-3A66695592B0/Documents/eba893d5cfe9da43072d9d182851bbd7.bin')
                  // downloadFile("https://qcdn.moyoung.com/files/004f77eb6d17d0dc855efe1794420de4.bin")
                  // widget.blePlugin.uploadLocalFile('/var/mobile/Containers/Data/Application/42A0BAE3-809E-483C-AD74-8DED6EF50C4C/Documents/004f77eb6d17d0dc855efe1794420de4.bin')
                      // widget.blePlugin.uploadLocalFile('/data/user/0/com.moyoung.moyoung_ble_plugin_example/app_flutter/6554d4265b0550049a9827a48a235840.bin')
              ),
            ]))));
  }

  sendWatchFaceBackground() async {
    String filePath = "assets/images/text.png";
    ByteData bytes = await rootBundle.load(filePath);
    Uint8List logoUint8List = bytes.buffer.asUint8List();

    WatchFaceBackgroundBean bgBean = WatchFaceBackgroundBean(
      bitmap: logoUint8List,
      thumbBitmap: logoUint8List,
      type: _watchFaceLayoutInfo!.compressionType,
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
    int index = watchFaceBean.file!.lastIndexOf('/');
    String name = watchFaceBean.file!.substring(index, watchFaceBean.file!.length);
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
    CustomizeWatchFaceBean info = CustomizeWatchFaceBean(index: watchFaceBean.id!, file: pathFile);
    await widget.blePlugin.sendWatchFace(SendWatchFaceBean(watchFaceFlutterBean: info, timeout: 30));
  }

  ///获取下载路径
  Future<String> getPathFile(String file) async {
    int index = file.lastIndexOf('/');
    String name = file.substring(index, file.length);
    String pathFile = "";
    await getApplicationDocumentsDirectory().then((value) => pathFile = value.path + name);
    print(pathFile);
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
        .then((value) => {print("File download completed！")})
        .onError((error, stackTrace) => {});
  }
}
