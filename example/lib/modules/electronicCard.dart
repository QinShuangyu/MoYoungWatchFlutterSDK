import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class ElectronicCardPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ElectronicCardPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ElectronicCardPage();
  }
}

class _ElectronicCardPage extends State<ElectronicCardPage> {
  String _electronicCardCountInfo = "";
  String _electronicCardInfo = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("ElectronicCard"),
        ),
        body: Center(
          child: ListView(children: <Widget>[

            Text("electronicCardCountInfo: $_electronicCardCountInfo"),
            Text("electronicCardInfo: $_electronicCardInfo"),

            ElevatedButton(
                onPressed: () async {
                  ElectronicCardCountInfoBean electronicCardCountInfo = await widget.blePlugin.queryElectronicCardCount;
                  setState(() {
                    _electronicCardCountInfo = electronicCardCountInfoBeanToJson(electronicCardCountInfo);
                  });
                },
                child: const Text("queryElectronicCardCount")),
            ElevatedButton(
                onPressed: () async {
                  widget.blePlugin.sendElectronicCard(ElectronicCardInfoBean(
                    id: 2,
                    title: "百度",
                    url: "https://www.baidu.com/",
                  ));
                },
                child: const Text("sendElectronicCard")),
            ElevatedButton(
                onPressed: () async {
                  widget.blePlugin.deleteElectronicCard(2);
                },
                child: const Text("deleteElectronicCard")),
            ElevatedButton(
                onPressed: () async {
                  ElectronicCardInfoBean electronicCardInfo = await widget.blePlugin.queryElectronicCard(2);
                  setState(() {
                    _electronicCardInfo = electronicCardInfoBeanToJson(electronicCardInfo);
                  });
                },
                child: const Text("queryElectronicCard")),
            ElevatedButton(
                onPressed: () async {
                  widget.blePlugin.sendElectronicCardList([2]);
                },
                child: const Text("sendElectronicCardList")),
          ]),
        ),
      ),
    );
  }
}
