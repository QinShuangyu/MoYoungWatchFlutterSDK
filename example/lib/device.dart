import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_bluetooth_plugin/moyoung_ble.dart';

import 'package:moyoung_bluetooth_plugin_example/modules/protocl_version.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/quick_view.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/sedentary_reminder.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/sets_local_city.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/shut_down.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/sleep.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/steps.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/take_photo.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/temperature_system.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/time.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/unitsystem.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/user_info.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/watch_face.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/weather.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/blood_oxygen.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/classic_bluetooth_address.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/ecg.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/find_watch.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/Language.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/music_player.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/pill_reminder.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/rssi.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/tap_wake.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/Training.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/alarm.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/battery.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/battery_saving.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/blood_pressure.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/body_temperature.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/breathing_light.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/brightness.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/contacts.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/display_time.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/drink_water_reminder.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/find_phone.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/firmware.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/goal_steps.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/hand_washing_reminder.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/heart_rate.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/heart_rate_alarm.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/menstrual_cycle.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/not_disturb.dart';
import 'package:moyoung_bluetooth_plugin_example/modules/notification.dart';

class DevicePage extends StatefulWidget {
  final BleScanBean device;

  const DevicePage({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DevicePage();
  }
}

class _DevicePage extends State<DevicePage> {
  late BleScanBean device = widget.device;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final MoYoungBle _blePlugin = MoYoungBle();

  int _connetionState = -1;
  bool isConn = false;

  String oTAType="";

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.connStateEveStm.listen(
        (int event) {
          setState(() {
            _connetionState = event;
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
          title: const Text('Device'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              Text('${device.name},${device.address}'),

              Text('connectionState= $_connetionState'),

              ElevatedButton(
                  child: const Text('isConnected()'),
                  onPressed: () {
                    _blePlugin.isConnected(device.address);
                  }),
              ElevatedButton(
                  child: const Text("connect()"),
                  onPressed: () {
                    _blePlugin.connect(device.address);
                    isConn = true;
                  }),
              ElevatedButton(
                  child: const Text('disconnect()'),
                  onPressed: () {
                    isConn = false;
                    _blePlugin.disconnect;
                  }),
              const Text("Module functions are as follows:",
              style: TextStyle(
                fontSize: 20,
                height: 2.0,
              )),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TimePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("4-Time")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return FirmwarePage(
                              blePlugin: _blePlugin,
                              device: device,
                            );
                          }));
                    }
                  },
                  child: const Text("5-Firmware")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BatteryPage(
                              blePlugin: _blePlugin,
                            );
                          })
                      );
                    }
                  },
                  child: const Text("6-Battery")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return UserInfoPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("7-UserInfo")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return WeatherPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("8-Weather")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return StepsPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("9-Steps")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return SleepPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("10-Sleep")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return UnitSystemPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("11-UnitSystem")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return QuickViewPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("12-QuickView")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return GoalStepsPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("13-GoalSteps")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return WatchFacePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("14-WatchFace")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return AlarmPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("15-Alarm")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return LanguagePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("16-Language")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return NotificationPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("17-Notification")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return SedentaryReminderPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("18-SedentaryReminder")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return FindWatchPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("19-FindWatch")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return HeartRatePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("20-HeartRate")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BloodPressurePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("21-BloodPressure")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BloodOxygenPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("22-BloodOxygen")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TakePhotoPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("23 & 24-TakePhoto")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return RSSIPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("25-RSSI")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ShutDownPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("26-ShutDown")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return NotDisturbPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("27-NotDisturb")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BreathingLightPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("28-BreathingLight")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ECGPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("29-ECG")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MenstrualCyclePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("30-MenstrualCycle")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return FindPhonePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("31-FindPhone")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MusicPlayerPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("32-MusicPlayer")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return DrinkWaterReminderPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("33-DrinkWaterReminder")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return HeartRateAlarmPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("34-HeartRateAlarm")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ProtocolVersionPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("36-ProtocolVersion")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BodyTemperaturePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("37-BodyTemperature")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return DisplayTimePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("38-DisplayTime")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return HandWashingReminderPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("39-HandWashingReminder")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return SetsLocalCityPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("40-SetsLocalCity")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TemperatureSystemPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("41-TemperatureSystem")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BrightnessPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("42-Brightness")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ClassicBluetoothAddressPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("43-ClassicBluetoothAddress")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ContactsPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("44-Contacts")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BatterySavingPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("45-BatterySaving")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return PillReminderPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("46-PillReminder")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TapWakePage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("47-TapWake")),
              ElevatedButton(
                  onPressed: () {
                    if(isConn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return TrainingPage(
                              blePlugin: _blePlugin,
                            );
                          }));
                    }
                  },
                  child: const Text("35 & 48-Training")),
            ],
          ),
        ),
      ),
    );
  }
}
