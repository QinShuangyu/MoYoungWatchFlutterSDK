import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:path_provider/path_provider.dart';
import '../components/base/CustomGestureDetector.dart';
import '../components/pages/WatchFaceList.dart';

GlobalKey<WatchFaceListState> watchFaceListKey = GlobalKey();

class WatchFacePage extends StatefulWidget {
  final MoYoungBle blePlugin;
  final BleScanBean device;

  const WatchFacePage({Key? key, required this.blePlugin, required this.device}) : super(key: key);

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
  WatchFaceDetailsBean? _watchFaceDetailsInfo = WatchFaceDetailsBean(
    id: -1,
    name: "",
    download: -1,
    size: -1,
    file: "",
    preview: "",
    remarkCn: "",
    remarkEn: "",
    recommendWatchFaceList: [],
  );
  List<WatchFaceStoreTagInfo> tagList = [];
  int _tagId = -1;
  String _storeType = SupportWatchFaceType.ordinary;

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
  bool isNewWatch = false;

  /// tab 控制器
  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;
  CrossFadeState displayState3 = CrossFadeState.showSecond;
  CrossFadeState displayState4 = CrossFadeState.showSecond;
  CrossFadeState displayState5 = CrossFadeState.showSecond;
  CrossFadeState displayState6 = CrossFadeState.showSecond;
  CrossFadeState displayState7 = CrossFadeState.showSecond;
  CrossFadeState displayState8 = CrossFadeState.showSecond;
  CrossFadeState displayState9 = CrossFadeState.showSecond;
  CrossFadeState displayState10 = CrossFadeState.showSecond;
  CrossFadeState displayState11 = CrossFadeState.showSecond;
  CrossFadeState displayState12 = CrossFadeState.showSecond;

  @override
  void initState() {
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(widget.blePlugin.fileTransEveStm.listen(
      (FileTransBean event) {
        print("MOYOUNG-Demo:blePlugin.fileTransEveStm - ${wfFileTransBeanToJson(event)}");
        if (!mounted) return;
        setState(() {
          switch (event.type) {
            case TransType.transStart:
              break;
            case TransType.transChanged:
              _progress = event.progress!;
              break;
            case TransType.transCompleted:
              _progress = 100;
              break;
            case TransType.error:
              _error = event.error!;
              break;
            default:
              break;
          }
        });
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> _key = GlobalKey();
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                  title: const Text("WatchFace"),
                  automaticallyImplyLeading: false, // 禁用默认的返回按钮
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // 手动处理返回逻辑
                    },
                  ),
                ),
                body: Center(
                    child: ListView(children: [
                  CustomGestureDetector(
                      title: 'sendDisplayWatchFace',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState1 = newDisplayState;
                        });
                      },
                      displayState: displayState1,
                      children: <Widget>[
                        Text("displayWatchFace: $_displayWatchFace", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ElevatedButton(
                          child: const Text('sendDisplayWatchFace(1)', style: TextStyle(fontSize: 14)),
                          onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.firstWatchFace),
                        ),
                        ElevatedButton(
                            child: const Text('sendDisplayWatchFace(2)', style: TextStyle(fontSize: 14)),
                            onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.secondWatchFace)),
                        ElevatedButton(
                          child: const Text('sendDisplayWatchFace(3)', style: TextStyle(fontSize: 14)),
                          onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.thirdWatchFace),
                        ),
                        ElevatedButton(
                            child: const Text('sendDisplayWatchFace(4)', style: TextStyle(fontSize: 14)),
                            onPressed: () => widget.blePlugin.sendDisplayWatchFace(WatchFaceType.newCustomizeWatchFace)),
                        ElevatedButton(
                            child: const Text('queryDisplayWatchFace()', style: TextStyle(fontSize: 14)),
                            onPressed: () async {
                              int displayWatchFace = await widget.blePlugin.queryDisplayWatchFace;
                              setState(() {
                                _displayWatchFace = displayWatchFace;
                              });
                            }),
                      ]),
                  CustomGestureDetector(
                      title: 'Steps to get the id of the watch face',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState5 = newDisplayState;
                        });
                      },
                      displayState: displayState5,
                      children: <Widget>[
                        Text("supportWatchFaceList: $_supportWatchFaceList", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("code: $_code", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("id: $_id", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("preview: $_preview", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("file: $_file", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ElevatedButton(
                            child: const Text('1. querySupportWatchFace()', style: TextStyle(fontSize: 14)), onPressed: querySupportWatchFace),
                        const Text("Note: First please click queryDisplayWatchFace", style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                        ElevatedButton(
                            child: const Text('2. queryWatchFaceOfID()', style: TextStyle(fontSize: 14)),
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
                      ]),
                  CustomGestureDetector(
                      title: 'queryWatchFaceLayout',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState2 = newDisplayState;
                        });
                      },
                      displayState: displayState2,
                      children: <Widget>[
                        Text("backgroundPictureMd5: $_backgroundPictureMd5", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("compressionType: $_compressionType", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("height: $_height", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("textColor: $_textColor", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("thumHeight: $_thumHeight", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("thumWidth: $_thumWidth", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("timeBottomContent: $_timeBottomContent", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("timePosition: $_timePosition", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("timeTopContent: $_timeTopContent", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("width: $_width", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ElevatedButton(
                            child: const Text('queryWatchFaceLayout()', style: TextStyle(fontSize: 14)),
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
                            child: const Text('sendWatchFaceLayout(watchFaceLayoutInfo)', style: TextStyle(fontSize: 14)),
                            onPressed: () => {
                                  if (_watchFaceLayoutInfo != null)
                                    {
                                      _watchFaceLayoutInfo!.textColor = const Color(0xFFFF0000),
                                      widget.blePlugin.sendWatchFaceLayout(_watchFaceLayoutInfo!),
                                    }
                                }),
                      ]),
                  CustomGestureDetector(
                      title: 'sendWatchFaceBackground',
                      childrenBCallBack: (CrossFadeState newDisplayState) {
                        setState(() {
                          displayState3 = newDisplayState;
                        });
                      },
                      displayState: displayState3,
                      children: <Widget>[
                        const Text("Note: First please click queryWatchFaceLayout", style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                        Text("progress: $_progress", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("error: $_error", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ElevatedButton(
                            child: const Text('sendWatchFaceBackground()', style: TextStyle(fontSize: 14)),
                            onPressed: () => {
                                  if (_watchFaceLayoutInfo != null) {sendWatchFaceBackground()}
                                }),
                        ElevatedButton(
                          child: const Text("abortWatchFaceBackground()", style: TextStyle(fontSize: 14)),
                          onPressed: () => widget.blePlugin.abortWatchFaceBackground,
                        ),
                      ]),
                  CustomGestureDetector(
                    title: 'Old watchFace store',
                    childrenBCallBack: (CrossFadeState newDisplayState) {
                      setState(() {
                        displayState7 = newDisplayState;
                      });
                    },
                    displayState: displayState7,
                    children: <Widget>[
                      ElevatedButton(child: const Text('1. querySupportWatchFace()'), onPressed: querySupportWatchFace),
                      ElevatedButton(
                        child: const Text("2. queryFirmwareVersion()"),
                        onPressed: queryFirmwareVersion,
                      ),
                      ElevatedButton(child: const Text('3. queryWatchFaceStore()'), onPressed: queryOrdinaryWatchFaceStore),
                    ],
                  ),
                  CustomGestureDetector(
                    title: 'WatchFace Data',
                    childrenBCallBack: (CrossFadeState newDisplayState) {
                      setState(() {
                        displayState6 = newDisplayState;
                      });
                    },
                    displayState: displayState6,
                    children: <Widget>[
                      Text("supportWatchFaceList: $_supportWatchFaceList", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text("size: $_watchFaceSize", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text("firmwareVersion: $_firmwareVersion", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text("jieliWatchFace: $_jieliWatchFace", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text("_tagId: $_tagId", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text("tagList: ${tagList.map((item) => watchFaceStoreTagInfoToJson(item))}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const Text("", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      // Text("watchFacelist: ${_watchFacelist.map((item) => watchFaceBeanToJson(item))}",
                      //     style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      WatchFaceList(
                        key: watchFaceListKey,
                        testedList: _watchFacelist,
                        blePlugin: widget.blePlugin,
                        watchFaceStoreTypeBean: WatchFaceStoreTypeBean(
                            storeType: _storeType,
                            id: 1,
                            typeList: _supportWatchFaceList,
                            firmwareVersion: _firmwareVersion,
                            apiVersion: _apiVersion,
                            feature: _feature,
                            maxSize: _watchFaceSize),
                        isNewWatch: isNewWatch,
                      ),
                      // Text("watchFaceDetailsInfo: ${watchFaceDetailsBeanToJson(_watchFaceDetailsInfo!)}",
                      //     style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  CustomGestureDetector(
                    title: 'New watchFace store - ordinary platform',
                    childrenBCallBack: (CrossFadeState newDisplayState) {
                      setState(() {
                        displayState8 = newDisplayState;
                      });
                    },
                    displayState: displayState8,
                    children: <Widget>[
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
                    ],
                  ),
                  CustomGestureDetector(
                    title: 'New watchFace store - sifli platform',
                    childrenBCallBack: (CrossFadeState newDisplayState) {
                      setState(() {
                        displayState9 = newDisplayState;
                      });
                    },
                    displayState: displayState9,
                    children: <Widget>[
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
                    ],
                  ),
                  CustomGestureDetector(
                    title: 'New watchFace store - jieli platform',
                    childrenBCallBack: (CrossFadeState newDisplayState) {
                      setState(() {
                        displayState10 = newDisplayState;
                      });
                    },
                    displayState: displayState10,
                    children: <Widget>[
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
                    ],
                  ),
                ])))));
  }

  sendWatchFaceBackground() async {
    print("MOYOUNG-Demo:sendWatchFaceBackground");
    String bitmapPath = "assets/images/img_2.png";
    ByteData bitmapBytes = await rootBundle.load(bitmapPath);
    Uint8List bitmapUint8List = bitmapBytes.buffer.asUint8List();

    String thumbBitmapPath = "assets/images/img_2.png";
    ByteData thumbBitmapBytes = await rootBundle.load(thumbBitmapPath);
    Uint8List thumbBitmapUint8List = thumbBitmapBytes.buffer.asUint8List();

    // 部分手机原相机拍摄的图片可能上板会被旋转，这可能是由于图片中的EXIF的orientation并不为0导致，尽量让客户通过裁剪图片尺寸，修正旋转方向以解决该问题
    var bitmapUint8List1 = await FlutterImageCompress.compressWithList(
      bitmapUint8List,
      minHeight: 240,
      minWidth: 296,
      quality: 100,
      rotate: 0,
    );
    var thumbBitmapUint8List1 = await FlutterImageCompress.compressWithList(
      thumbBitmapUint8List,
      minHeight: 240,
      minWidth: 296,
      quality: 100,
      rotate: 0,
    );

    WatchFaceBackgroundBean bgBean = WatchFaceBackgroundBean(
      bitmap: bitmapUint8List,
      thumbBitmap: thumbBitmapUint8List,
      type: _watchFaceLayoutInfo!.compressionType,
      width: _watchFaceLayoutInfo!.width,
      height: _watchFaceLayoutInfo!.height,
      thumbWidth: _watchFaceLayoutInfo!.thumWidth,
      thumbHeight: _watchFaceLayoutInfo!.thumHeight,
    );
    print("MOYOUNG-Demo:blePlugin.sendWatchFaceBackground - ${watchFaceBackgroundBeanToJson(bgBean)}");
    widget.blePlugin.sendWatchFaceBackground(bgBean);
  }

  Future<void> querySupportWatchFace() async {
    _supportWatchFaceBean = await widget.blePlugin.querySupportWatchFace;
    _watchFaceType = _supportWatchFaceBean!.type;
    setState(() {
      if (_watchFaceType == SupportWatchFaceType.ordinary) {
        displayState9 = CrossFadeState.showFirst;
        displayState10 = CrossFadeState.showFirst;
        _storeType = SupportWatchFaceType.ordinary;
        _displayWatchFace = _supportWatchFaceBean!.supportWatchFaceInfo!.displayWatchFace!;
        _supportWatchFaceList = _supportWatchFaceBean!.supportWatchFaceInfo!.supportWatchFaceList!;
      } else if (_watchFaceType == SupportWatchFaceType.sifli) {
        displayState7 = CrossFadeState.showFirst;
        displayState8 = CrossFadeState.showFirst;
        displayState10 = CrossFadeState.showFirst;
        _storeType = SupportWatchFaceType.sifli;
        _supportWatchFaceList = _supportWatchFaceBean!.sifliSupportWatchFaceInfo!.typeList!;
      } else if (_watchFaceType == SupportWatchFaceType.jieli) {
        displayState7 = CrossFadeState.showFirst;
        displayState8 = CrossFadeState.showFirst;
        displayState9 = CrossFadeState.showFirst;
        _storeType = SupportWatchFaceType.jieli;
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
    isNewWatch = false;
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
    int platform = widget.device.platform;
    _watchFaceSize = await widget.blePlugin.queryAvailableStorage(platform);
    setState(() {
      _watchFaceSize *= 1024;
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
      tagList = result.list!;
      _tagId = result.list![0].tagId!;
    }
  }

  Future<void> queryWatchFaceStoreList(String storeType) async {
    _watchFacelist = [];
    isNewWatch = true;
    if (tagList.isNotEmpty && _firmwareVersion != "" && _supportWatchFaceList.isNotEmpty) {
      for (var i = 0; i < tagList.length; i++) {
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
              tagId: tagList[i]!.tagId!),
        );
        setState(() {
          _watchFacelist.addAll(watchFacelist);
        });
      }
    }
  }
}
