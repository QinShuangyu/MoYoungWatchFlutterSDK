import 'dart:async';
import 'dart:math';

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
  Color _textColor = Colors.white;
  int _thumHeight = -1;
  int _thumWidth = -1;
  int _timeBottomContent = -1;
  int _timePosition = -1;
  int _timeTopContent = -1;
  int _width = -1;
  String _firmwareVersion = "";
  SupportWatchFaceBean? _supportWatchFaceBean;
  String _watchFaceType = "";
  int _displayWatchFace = -1;
  String _jieliWatchFace = "";
  int _apiVersion = 0;
  int _feature = 0;
  List<int> _supportWatchFaceList = [];
  List<WatchFaceBean> _watchFacelist = [];
  String _watchFaceDetailResult = "";
  int _tagId = -1;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _progress = -1;
  int _error = -1;
  int type = 0;
  int _code = -1;
  WatchFace? _watchFace;
  int _id = -1;
  String _preview = "";
  String _file = "";
  int _watchFaceSize = 500 * 1024;

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    var fileTransEveStm = widget.blePlugin.fileTransEveStm.listen(
          (FileTransBean event) {
        if (!mounted) return;
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
          if (!mounted) return;
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
                  Text("watchFacelist: ${_watchFacelist.map((item) => watchFaceBeanToJson(item))}"),
                  Text("code: $_code"),
                  Text("id: $_id"),
                  Text("jieliWatchFace: $_jieliWatchFace"),
                  Text("preview: $_preview"),
                  Text("file: $_file"),
                  Text("size: $_watchFaceSize"),
                  Text("watchFaceDetailResult: $_watchFaceDetailResult" ),
                  ElevatedButton(
                    child: const Text('sendDisplayWatchFace(1)'),
                    onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.firstWatchFace),
                  ),
                  ElevatedButton(
                      child: const Text('sendDisplayWatchFace(2)'),
                      onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.secondWatchFace)),
                  ElevatedButton(
                    child: const Text('sendDisplayWatchFace(3)'),
                    onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.thirdWatchFace),
                  ),
                  ElevatedButton(
                      child: const Text('sendDisplayWatchFace(4)'),
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
                      child: const Text('sendWatchFaceLayout(watchFaceLayoutInfo)'),
                      onPressed: () =>
                      {
                        if (_watchFaceLayoutInfo != null)
                          {
                            _watchFaceLayoutInfo!.textColor = const Color(0xFFFF0000),
                            widget.blePlugin.sendWatchFaceLayout(_watchFaceLayoutInfo!),
                          }
                      }),
                  ElevatedButton(
                      child: const Text('sendWatchFaceBackground()'),
                      onPressed: () =>
                      {
                        if (_watchFaceLayoutInfo != null) {sendWatchFaceBackground()}
                      }),
                  ElevatedButton(
                    child: const Text("abortWatchFaceBackground()"),
                    onPressed: () => widget.blePlugin.abortWatchFaceBackground,
                  ),
                  ElevatedButton(
                      child: const Text("queryAvailableStorage()"),
                      onPressed: queryAvailableStorage),
                  Column(
                    children: [
                      const Text("Steps to get the id of the watch face"),
                      ElevatedButton(child: const Text('1. querySupportWatchFace()'), onPressed: querySupportWatchFace),
                      ElevatedButton(
                          child: const Text('2. queryWatchFaceOfID()'),
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
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Get the watch face market the old way"),
                      ElevatedButton(child: const Text('1. querySupportWatchFace()'), onPressed: querySupportWatchFace),
                      ElevatedButton(
                        child: const Text("2. queryFirmwareVersion()"),
                        onPressed: queryFirmwareVersion,
                      ),
                      ElevatedButton(child: const Text('3. queryWatchFaceStore()'), onPressed: queryOrdinaryWatchFaceStore),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Query the ordinary watchFace store"),
                      ElevatedButton(child: const Text('1. querySupportWatchFace()'), onPressed: querySupportWatchFace),
                      ElevatedButton(
                        child: const Text("2. queryFirmwareVersion()"),
                        onPressed: queryFirmwareVersion,
                      ),
                      ElevatedButton(child: const Text('3. queryAvailableStorage()'), onPressed: queryAvailableStorage),
                      ElevatedButton(
                          child: const Text('4. queryWatchFaceStoreTagList()'),
                          onPressed: () => queryWatchFaceStoreTagList(SupportWatchFaceType.ordinary)),
                      ElevatedButton(
                          child: const Text('5. queryWatchFaceStoreList()'), onPressed: () => queryWatchFaceStoreList(SupportWatchFaceType.ordinary)),
                      ElevatedButton(
                          child: const Text('6. queryWatchFaceDetail()'), onPressed: () => queryWatchFaceDetail(SupportWatchFaceType.ordinary)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Query the sifli watchFace store"),
                      ElevatedButton(child: const Text('1. querySupportWatchFace()'), onPressed: querySupportWatchFace),
                      ElevatedButton(
                        child: const Text("2. queryFirmwareVersion()"),
                        onPressed: queryFirmwareVersion,
                      ),
                      ElevatedButton(child: const Text('3. queryAvailableStorage()'), onPressed: queryAvailableStorage),
                      ElevatedButton(
                          child: const Text('4. queryWatchFaceStoreTagList()'),
                          onPressed: () => queryWatchFaceStoreTagList(SupportWatchFaceType.sifli)),
                      ElevatedButton(
                          child: const Text('5. queryWatchFaceStoreList()'), onPressed: () => queryWatchFaceStoreList(SupportWatchFaceType.sifli)),
                      ElevatedButton(
                          child: const Text('6. queryWatchFaceDetail()'), onPressed: () => queryWatchFaceDetail(SupportWatchFaceType.sifli)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Query the jieli watchFace store"),
                      ElevatedButton(child: const Text('1. querySupportWatchFace()'), onPressed: querySupportWatchFace),
                      ElevatedButton(
                        child: const Text("2. queryFirmwareVersion()"),
                        onPressed: queryFirmwareVersion,
                      ),
                      ElevatedButton(child: const Text('3. queryJieliWatchFaceInfo()'), onPressed: queryJieliWatchFaceInfo),
                      ElevatedButton(
                          child: const Text('4. queryWatchFaceStoreTagList()'),
                          onPressed: () => queryWatchFaceStoreTagList(SupportWatchFaceType.jieli)),
                      ElevatedButton(
                          child: const Text('5. queryWatchFaceStoreList()'), onPressed: () => queryWatchFaceStoreList(SupportWatchFaceType.jieli)),
                      ElevatedButton(
                          child: const Text('6. queryWatchFaceDetail()'), onPressed: () => queryWatchFaceDetail(SupportWatchFaceType.jieli)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Steps to upload the watch face"),
                      const Text("1. Query watchFace store"),
                      ElevatedButton(
                        child: const Text('2. sendWatchFace(_watchFacelist)'),
                        onPressed: () => sendWatchFace(_watchFacelist[1]),
                      ),
                      ElevatedButton(
                        child: const Text("abortWatchFace()"),
                        onPressed: () => widget.blePlugin.abortWatchFace,
                      ),
                      ElevatedButton(
                        child: const Text("deleteWatchFace()"),
                        onPressed: () => widget.blePlugin.deleteWatchFace(_id),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Steps for uploading a local watch face"),
                      const Text("1. Query watchFace store"),
                      ElevatedButton(
                          child: const Text('2. localFileUpload'),
                          onPressed: () {
                            if (_watchFacelist.isNotEmpty) {
                              downloadFile(_watchFacelist[_watchFacelist.length - 1].file!);
                            } else {
                              downloadFile("http://qcdn.moyoung.com/files/adc090779afd57d382e2847e41ab0e83.bin");
                            }
                          }),
                    ],
                  ),
                ]))));
  }

  sendWatchFaceBackground() async {
    String bitmapPath = "assets/images/img_2.png";
    ByteData bitmapBytes = await rootBundle.load(bitmapPath);
    Uint8List bitmapUint8List = bitmapBytes.buffer.asUint8List();

    String thumbBitmapPath = "assets/images/img_2.png";
    ByteData thumbBitmapBytes = await rootBundle.load(thumbBitmapPath);
    Uint8List thumbBitmapUint8List = thumbBitmapBytes.buffer.asUint8List();

    WatchFaceBackgroundBean bgBean = WatchFaceBackgroundBean(
      bitmap: bitmapUint8List,
      thumbBitmap: thumbBitmapUint8List,
      type: _watchFaceLayoutInfo!.compressionType,
      width: _watchFaceLayoutInfo!.width,
      height: _watchFaceLayoutInfo!.height,
      thumbWidth: _watchFaceLayoutInfo!.thumWidth,
      thumbHeight: _watchFaceLayoutInfo!.thumHeight,
    );
    widget.blePlugin.sendWatchFaceBackground(bgBean);
  }

  Future<void> querySupportWatchFace() async {
    _supportWatchFaceBean = await widget.blePlugin.querySupportWatchFace;
    _watchFaceType = _supportWatchFaceBean!.type;
    setState(() {
      if (_watchFaceType == SupportWatchFaceType.ordinary) {
        _displayWatchFace = _supportWatchFaceBean!.supportWatchFaceInfo!.displayWatchFace!;
        _supportWatchFaceList = _supportWatchFaceBean!.supportWatchFaceInfo!.supportWatchFaceList!;
      } else if (_watchFaceType == SupportWatchFaceType.sifli) {
        _supportWatchFaceList = _supportWatchFaceBean!.sifliSupportWatchFaceInfo!.typeList!;
      } else if (_watchFaceType == SupportWatchFaceType.jieli) {
        _displayWatchFace = _supportWatchFaceBean!.jieliSupportWatchFaceInfo!.displayWatchFace!;
        _supportWatchFaceList = _supportWatchFaceBean!.jieliSupportWatchFaceInfo!.supportTypeList!;
        _watchFaceSize = _supportWatchFaceBean!.jieliSupportWatchFaceInfo!.watchFaceMaxSize!;
      }
    });
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

  Future<void> queryJieliWatchFaceInfo() async {
    JieliWatchFaceBean jieliWatchFace = await widget.blePlugin.queryJieliWatchFaceInfo;
    _apiVersion = jieliWatchFace.apiVersion!;
    _feature = jieliWatchFace.feature!;
    setState(() {
      _jieliWatchFace = jieliWatchFaceBeanToJson(jieliWatchFace);
    });
  }

  Future<void> queryOrdinaryWatchFaceStore() async {
    if (_firmwareVersion != "" && _supportWatchFaceList.isNotEmpty) {
      List<WatchFaceBean> watchFacelist = await widget.blePlugin.queryWatchFaceStore(
        WatchFaceStoreBean(
          watchFaceSupportList: _supportWatchFaceList,
          firmwareVersion: _firmwareVersion,
          pageCount: 9,
          pageIndex: 1,
        ),
      );
      setState(() {
        _watchFacelist = watchFacelist;
      });
    }
  }

  Future<void> queryAvailableStorage() async {
    int watchFaceSize = await widget.blePlugin.queryAvailableStorage;
    setState(() {
      _watchFaceSize = watchFaceSize * 1024;
    });
  }

  Future<void> queryWatchFaceStoreTagList(String storeType) async {
    if (_firmwareVersion != "" && _supportWatchFaceList.isNotEmpty) {
      WatchFaceStoreTagListResult result = await widget.blePlugin.queryWatchFaceStoreTagList(
        WatchFaceStoreTagListBean(
            storeType: storeType,
            typeList: _supportWatchFaceList,
            firmwareVersion: _firmwareVersion,
            perPageCount: 9,
            pageIndex: 1,
            maxSize: _watchFaceSize,
            apiVersion: _apiVersion,
            feature: _feature),
      );
      _tagId = result.list![0].tagId!;
    }
  }

  Future<void> queryWatchFaceStoreList(String storeType) async {
    if (_tagId != -1 && _firmwareVersion != "" && _supportWatchFaceList.isNotEmpty) {
      List<WatchFaceBean> watchFacelist = await widget.blePlugin.queryWatchFaceStoreList(
        WatchFaceStoreListBean(
            watchFaceStoreTagList: WatchFaceStoreTagListBean(
                storeType: storeType,
                typeList: _supportWatchFaceList,
                firmwareVersion: _firmwareVersion,
                perPageCount: 9,
                pageIndex: 1,
                maxSize: _watchFaceSize,
                apiVersion: _apiVersion,
                feature: _feature),
            tagId: _tagId),
      );
      setState(() {
        _watchFacelist = watchFacelist;
      });
    }
  }

  Future<void> queryWatchFaceDetail(String storeType) async {
    if (_watchFacelist.isNotEmpty && _firmwareVersion.isNotEmpty) {
      WatchFaceDetailResultBean watchFaceDetailResult = await widget.blePlugin.queryWatchFaceDetail(
        WatchFaceStoreTypeBean(
            storeType: storeType,
            id: _watchFacelist[0].id!,
            typeList: _supportWatchFaceList,
            firmwareVersion: _firmwareVersion,
            apiVersion: _apiVersion,
            feature: _feature,
            maxSize: _watchFaceSize),
      );
      setState(() {
        _watchFaceDetailResult = watchFaceDetailResultBeanToJson(watchFaceDetailResult);
      });
    }
  }

  Future<void> querySifliWatchFaceStore() async {}

  sendWatchFace(WatchFaceBean watchFaceBean) async {
    // Download the file and save
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
        .then((value) => {widget.blePlugin.uploadLocalFile(pathFile)})
        .onError((error, stackTrace) => {});
  }
}
