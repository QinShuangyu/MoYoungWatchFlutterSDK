import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:path_provider/path_provider.dart';

import '../components/base/CustomGestureDetector.dart';
import '../utils/net/network_image_ssl.dart';

GlobalKey<NavigatorState> _key = GlobalKey();

class SendWatchFace extends StatefulWidget {
  final MoYoungBle blePlugin;
  final WatchFaceBean watchFaceInfo;
  final WatchFaceStoreTypeBean watchFaceStoreTypeBean;
  final bool isNewWatch;

  const SendWatchFace({
    Key? key,
    required this.watchFaceInfo,
    required this.isNewWatch,
    required this.blePlugin,
    required this.watchFaceStoreTypeBean,
  }) : super(key: key);

  @override
  _SendWatchFaceState createState() => _SendWatchFaceState();
}

class _SendWatchFaceState extends State<SendWatchFace> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
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
  int _progress = -1;
  int _error = -1;
  int id = 1;
  String file = "";

  CrossFadeState displayState1 = CrossFadeState.showSecond;
  CrossFadeState displayState2 = CrossFadeState.showSecond;
  CrossFadeState displayState3 = CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    subscriptStream();
    if (widget.isNewWatch) {
      queryWatchFaceDetail();
    } else {
      id = widget.watchFaceInfo.id!;
      file = widget.watchFaceInfo.file!;
    }
  }

  void subscriptStream() {
    _streamSubscriptions.add(widget.blePlugin.wfFileTransEveStm.listen(
      (FileTransBean event) {
        print("MOYOUNG-demo:wfFileTransEveStm - ${wfFileTransBeanToJson(event)}");
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
              if (widget.watchFaceStoreTypeBean.storeType == SupportWatchFaceType.jieli) {
                sendWatchFaceId(id);
              }
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
    return WillPopScope(
      onWillPop: () async {
        if (_key.currentState != null && _key.currentState!.canPop()) {
          _key.currentState?.pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Send WatchFace"),
          automaticallyImplyLeading: false, // 禁用默认的返回按钮
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // 手动处理返回逻辑
            },
          ),
        ),
        body: Center(
          child: ListView(children: <Widget>[
            CustomGestureDetector(
                title: 'new watch',
                childrenBCallBack: (CrossFadeState newDisplayState) {
                  setState(() {
                    displayState1 = newDisplayState;
                  });
                },
                displayState: displayState1,
                children: <Widget>[
                  const Text("Note:new watch need click", style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                  Text("watchFaceDetailsInfo: ${watchFaceDetailsBeanToJson(_watchFaceDetailsInfo!)}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ElevatedButton(child: const Text('6. queryWatchFaceDetail()'), onPressed: () => queryWatchFaceDetail()),
                ]),
            CustomGestureDetector(
              title: 'send online watch face',
              childrenBCallBack: (CrossFadeState newDisplayState) {
                setState(() {
                  displayState2 = newDisplayState;
                });
              },
              displayState: displayState2,
              children: <Widget>[
                ImageLoader(
                  width: 44,
                  imageUrl: widget.watchFaceInfo.preview!,
                  fit: BoxFit.contain,
                ),
                Text("id: $id", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text("file: $file", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Text("", style: TextStyle(height: 3)),
                const Text("Note:Query watchFace store", style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                Text("progress: $_progress", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text("error: $_error", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ElevatedButton(
                  child: const Text('1. sendWatchFace(_watchFaceDetailsInfo)'),
                  onPressed: () => sendWatchFace(id, file),
                ),
                const Text("Note:JieLi need click step 2", style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                ElevatedButton(
                  child: const Text('2. sendWatchFaceId(_watchFaceDetailsInfo)'),
                  onPressed: () => sendWatchFaceId(id),
                ),
                ElevatedButton(
                  child: const Text("abortWatchFace()"),
                  onPressed: () => widget.blePlugin.abortWatchFace,
                ),
                ElevatedButton(
                  child: const Text("deleteWatchFace()"),
                  onPressed: () => widget.blePlugin.deleteWatchFace(id),
                ),
              ],
            ),
            CustomGestureDetector(
              title: 'send local watch face',
              childrenBCallBack: (CrossFadeState newDisplayState) {
                setState(() {
                  displayState3 = newDisplayState;
                });
              },
              displayState: displayState3,
              children: <Widget>[
                const Text("Note:Query watchFace store", style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                Text("progress: $_progress", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text("error: $_error", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ElevatedButton(
                    child: const Text('1. localFileUpload'),
                    onPressed: () {
                      if (_watchFaceDetailsInfo!.file.isNotEmpty) {
                        downloadFile(_watchFaceDetailsInfo!.file);
                      } else {
                        downloadFile("https://qcdn.moyoung.com/files/646444b65a51d0a871f7af2138c2e31f.bin");
                      }
                    }),
                const Text("Note:JieLi need click step 2", style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                ElevatedButton(
                  child: const Text('2. sendWatchFaceId(_watchFaceDetailsInfo)'),
                  onPressed: () => widget.blePlugin.sendWatchFaceId(1),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> queryWatchFaceDetail() async {
    widget.watchFaceStoreTypeBean.id = widget.watchFaceInfo.id!;
    WatchFaceDetailResultBean watchFaceDetailResult = await widget.blePlugin.queryWatchFaceDetail(widget.watchFaceStoreTypeBean);
    setState(() {
      id = watchFaceDetailResult.watchFaceDetailsInfo!.id;
      file = watchFaceDetailResult.watchFaceDetailsInfo!.file;
      _watchFaceDetailsInfo = watchFaceDetailResult.watchFaceDetailsInfo!;
    });
  }

  sendWatchFace(id, file) async {
    print("MOYOUNG-Demo:sendWatchFace id:$id file:$file");
    // Download the file and save
    int index = file.lastIndexOf('/');
    String name = file.substring(index, file.length);
    String pathFile = "";
    await getApplicationDocumentsDirectory().then((value) => pathFile = value.path + name);

    BaseOptions options = BaseOptions(
      baseUrl: file,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);
    await dio.download(file, pathFile);

    //call native interface
    CustomizeWatchFaceBean info = CustomizeWatchFaceBean(index: id, file: pathFile);
    print("MOYOUNG-Demo:blePlugin.sendWatchFace - ${customizeWatchFaceBeanToJson(info)}");
    await widget.blePlugin.sendWatchFace(SendWatchFaceBean(watchFaceFlutterBean: info, timeout: 30));
  }

  sendWatchFaceId(id) async {
    await widget.blePlugin.sendWatchFaceId(id);
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
