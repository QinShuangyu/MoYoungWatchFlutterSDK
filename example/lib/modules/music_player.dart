import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

class MusicPlayerPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const MusicPlayerPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<MusicPlayerPage> createState() {
    return _MusicPlayerPage();
  }
}

class _MusicPlayerPage extends State<MusicPlayerPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Music Player"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () =>
                      widget.blePlugin.setPlayerState(
                          PlayerStateType.musicPlayerPause),
                  child: const Text("setPlayerState(0)")),
              ElevatedButton(
                  onPressed: () =>
                      widget.blePlugin.setPlayerState(
                          PlayerStateType.musicPlayerPlay),
                  child: const Text("setPlayerState(1)")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.sendSongTitle("111"),
                  child: const Text("sendSongTitle()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.sendLyrics("lyrics"),
                  child: const Text("sendLyrics()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.closePlayerControl,
                  child: const Text("closePlayerControl()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.sendCurrentVolume(50),
                  child: const Text("sendCurrentVolume()")),
              ElevatedButton(
                  onPressed: () => widget.blePlugin.sendMaxVolume(100),
                  child: const Text("sendMaxVolume()")),
            ])
            )
        )
    );
  }
}
