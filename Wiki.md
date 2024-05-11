# 1 Initialization
MoYoungBle is the entrance of the SDK. The client needs to maintain the instance of MoYoungBle, and it needs to initialize the instance of MoYoungBle when using it.
```
final MoYoungBle _blePlugin = MoYoungBle();
```

# 2 Scan BLE Device
## 2.1 Sets scan listener

When the scan is enabled, the scan event listener stream bleScanEveStm will be triggered, and the scan result will be returned through the bleScanEveStm listener stream and stored in the “event” as a BleScanEvent object.
```dart
_blePlugin.bleScanEveStm.listen(
  (BleScanBean event) async {
    /// Do something with new state 
  });
```
Callback Description（event）:

BleScanBean：

| callback value | callback value type |        callback value description         |
| -------------- | :------------------ | :---------------------------------------: |
| isCompleted    | bool                |               is completed                |
| address        | String              |              Device address               |
| mRssi          | int                 |              equipment rssi               |
| mScanRecord    | List<int>           |       Bluetooth scan device record        |
| name           | String              |              Equipment name               |
| platform       | int                 | Watch type, refer to McuPlatform for type |

McuPlatform：

| type               | value | value description |
| ------------------ | ----- | ----------------- |
| PLATFORM_NONE      | 0     |                   |
| PLATFORM_NORDIC    | 1     |                   |
| PLATFORM_HUNTERSUN | 2     |                   |
| PLATFORM_REALTEK   | 3     |                   |
| PLATFORM_GOODIX    | 4     |                   |
| PLATFORM_SIFLI     | 5     |                   |
| PLATFORM_JIELI     | 6     |                   |



## 2.2 Start scan

When scanning Bluetooth devices, it will first obtain the open status of Bluetooth, and only when the  permission is allowed and the Bluetooth is turned on can start normal scanning. 

```dart
_blePlugin.startScan(10*1000).then((value) => {
     /// Do something with new state 
    }).onError((error, stackTrace) => {
  });
```

Parameter Description :

- The scan duration can be set in milliseconds. 
- Since Bluetooth scanning is a time-consuming operation, it is recommended to set the scanning time to 10 seconds.

## 2.3 Cancel scan

Turn off the bluetooth scan, and the result listens to the callback through the bleScanEveStm data stream.

```
_blePlugin.cancelScan;
```

# 3 Connect
## 3.1 Sets connect State listener

Gets the watch's Mac address by scanning the received bleScanEveStm. When the device is connected to Bluetooth, it will trigger Bluetooth connection monitoring. The connection and callback state is monitored through the stateEveStm data stream, and the results are saved in "event".

Add event stream listener.

```
_blePlugin.connStateEveStm.listen(
  (ConnectStateBean event) {
   // Do something with new state
  }),
```

Parameter Description :

ConnectStateBean :

| vlaue        | value type | value description                         |
| ------------ | ---------- | ----------------------------------------- |
| autoConnect  | bool       | Indicates whether reconnection is enabled |
| connectState | int        | Returns the value in ConnectionState      |

ConnectionState:

| vlaue              | value type | value description |
| :----------------- | :--------- | :---------------- |
| stateDisconnected  | int        | disconnected(0)   |
| stateConnecting    | int        | connecting(1)     |
| stateConnected     | int        | connected(2)      |
| stateDisconnecting | int        | disconnecting(3)  |

## 3.2 Connect

Connect to Bluetooth by passing the ConnectBean parameter.

```dart
_blePlugin.connect(ConnectBean connectBean);
```

Parameter Description :

ConnectDeviceBean :

| value       | value type | value description                    |
| ----------- | ---------- | ------------------------------------ |
| autoConnect | bool       | Sets whether reconnection is enabled |
| address     | String     | The address of the device            |
| uuid        | String     | uuid of the device（Not required）   |

## 3.3 IsConnected

Establish a Bluetooth connection with the device by passing in the device's Mac address.

```dart
bool connectedState = await _blePlugin.isConnected(String address);
```

## 3.4 Disconnect

Disconnected watch,disconnect returns true. It is recommended to add an appropriate delay when disconnecting and reconnecting, so that the system can recover resources and guarantee the connection success rate.

```
bool disconnect = await _blePlugin.disconnect;
```

## 3.5 Reconnect

Reconnect the last connected device.(ios Only Method).

```
await _blePlugin.reconnect;
```

## 3.6 Connect Device

Connect peripherals.

```
await _blePlugin.connectDevice(ConnectDeviceBean);
```

Parameter Description :

ConnectDeviceBean :

| value       | value type | value description                    |
| :---------- | :--------- | :----------------------------------- |
| mac         | String     | device address                       |
| peripheral  | dynamic    | peripheral equipment                 |
| autoConnect | bool       | Sets whether reconnection is enabled |

# 4 Time

## 4.1 Sync Time

Synchronize the time of your phone and watch.

timestamp is an optional parameter and defaults to the current time.

```dart
_blePlugin.queryTime(int? timestamp);
```

## 4.2 Sets Time System

Sets the system time of the watch.

```dart
_blePlugin.sendTimeSystem(TimeSystemType);
```

Parameter Description :

TimeSystemType:

| value        | value type | value description |
| :----------- | :--------- | :---------------- |
| timeSystem12 | int        | 12-Hour Time      |
| timeSystem24 | int        | 24-Hour Time      |

## 4.3 Gets Time System

Gets the time system of the watch.

```dart
int timeSystemType = await _blePlugin.queryTimeSystem;
```

# 5 Firmware
## 5.1 Sets firmware listener

```dart
_blePlugin.oTAEveStm.listen(
        (OTABean event) {
           /// Do something with new state,for example:
          setState(() {
            switch(event.type){
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
                break;
              default:
                break;
            }
          });
        });
```

Callback Description （event）:

OTABean：

| value           | value type       | value description                                            |
| :-------------- | :--------------- | :----------------------------------------------------------- |
| type            | int              | Gets the type of the callback return value, where Type is the value corresponding to OTAProgressType |
| upgradeProgress | int              | Upgrade progress                                             |
| upgradeError    | UpgradeErrorBean | Firmware upgrade error data is reported                      |

UpgradeErrorBean:

| value        | value type | value description |
| :----------- | :--------- | :---------------- |
| error        | int        | error type        |
| errorContent | String     | error content     |

OTAProgressType:

| type             | value | value description                  |
| :--------------- | :---- | :--------------------------------- |
| downloadStart    | 1     | Firmware version download starts   |
| downloadComplete | 2     | Firmware version download complete |
| progressStart    | 3     | OTA start                          |
| progressChanged  | 4     | OTA process changes                |
| upgradeCompleted | 5     | OTA completed                      |
| upgradeAborted   | 6     | OTA abort                          |
| error            | 7     | OTA error                          |

## 5.2 Gets firmware version

Gets the current firmware version of the watch.

```dart
String firmwareVersion = await _blePlugin.queryFirmwareVersion;
```

## 5.3 Gets customize version

> [!CAUTION]
>
> The method only supports JM iTOUCH Active watches and Active 3 watches.

Gets the firmware version of the custom watch.

```dart
String customizeVersion = await _blePlugin.queryCustomizeVersion;
```

## 5.3 Check firmware

Gets the latest version information.

```dart
CheckFirmwareVersionBean bean = await _blePlugin.checkFirmwareVersion(FirmwareVersion info);
```

Parameter Description :

 FirmwareVersion:

| value   | value type | value description                            |
| :------ | :--------- | :------------------------------------------- |
| version | String     | Get through _blePlugin.queryFirmwareVersion; |
| otaType | int        | Upgrade type, from OTAType                   |

OTAType：

| value             | value type | value description |
| :---------------- | :--------- | :---------------- |
| normalUpgeadeType | int        | normal upgeade    |
| betaUpgradeType   | int        | beta upgrade      |
| forcedUpdateType  | int        | forced update     |

Callback Description:

CheckFirmwareVersionBean

| callback value      | callback value type | callback value description                          |
| :------------------ | :------------------ | :-------------------------------------------------- |
| firmwareVersionInfo | FirmwareVersionBean | The latest version information                      |
| isLatestVersion     | bool                | Check whether the information is the latest version |

FirmwareVersionBean：

| value         | value type | value description                                    |
| ------------- | :--------- | :--------------------------------------------------- |
| version       | String     | Current firmware version number of the watch         |
| changeNotes   | String     | change note                                          |
| changeNotesEn | int        | english change note                                  |
| type          | bool       | Upgrade type, same as OTAType                        |
| mcu           | int        | MCU type, used to distinguish upgrade mode           |
| tpUpgrade     | String     | Whether you need to upgrade tp, the default is false |

OTAType：

| value             | value type | value description |
| :---------------- | :--------- | :---------------- |
| normalUpgeadeType | int        | normal upgeade    |
| betaUpgradeType   | int        | beta upgrade      |
| forcedUpdateType  | int        | forced update     |

## 5.4 Satrt OTA<Android partial support>

The firmware upgrade is divided into four upgrade methods.The calling method is as follows:

Note:
1. There is no first and second upgrade methods on the ios side.
2. Before starting the firmware upgrade, you need to ensure that the watch battery is above 50%.

```dart
_blePlugin.startOTA(OtaBean info);
```

Parameter Description :

OtaBean:

| value   | value type | value description                                            |
| :------ | :--------- | :----------------------------------------------------------- |
| address | int        | The mac address of the device                                |
| type    | int        | The type of firmware upgrade method obtained by the mcu obtained according to the firmware version of the device,the value is OTAMcuType |

OTAMcuType:

| type | value | value description         |
| :-------- | :---- | :------------------------ |
| startHsOta  | 1     | The first way to upgrade  |
| startRtkOta | 2     | The second way to upgrade |
| startOta  | 3     | The third way to upgrade  |
| startDefaultOta   | 4     | The four way to upgrade   |
| startSifliOta | 5 | Sifli firmware upgrade |
| startJieliOta | 6 | Jieli firmware upgrade |

the upgrade method is determined according to the mcu value in the firmware version information of the current watch.

The mcu value of the firmware version is obtained by the checkFirmwareVersion method.

```dart
switch (mcu) {
  case 4:
  case 8:
  case 9:
    oTAType = OTAMcuType.startHsOta;
        ///The first way to upgrade,<Only android support>
    await _blePlugin
        .startOTA(OtaBean(address: address, type: OTAMcuType.startHsOta));
    break;
  case 7:
  case 11:
  case 71:
  case 72:
    oTAType = OTAMcuType.startRtkOta;
        ///The second way to upgrade,<Only android support>
    await _blePlugin
        .startOTA(OtaBean(address: address, type: OTAMcuType.startRtkOta));
    break;
  case 10:
    oTAType = OTAMcuType.startOta;
        ///The third way to upgrade
    await _blePlugin
        .startOTA(OtaBean(address: address, type: OTAMcuType.startOta));
    break;
    case 5:
        _oTAType = OTAMcuType.startSifliOta;
        await widget.blePlugin.startOTA(OtaBean(address: address, type: OTAMcuType.startSifliOta));
        break;
    case 6:
        _oTAType = OTAMcuType.startJieliOta;
        await widget.blePlugin.startOTA(OtaBean(address: address, type: 		       		OTAMcuType.startJieliOta));
        break;
  default:
    oTAType = OTAMcuType.startDefaultOta;
        ///The four way to upgrade
    await _blePlugin
        .startOTA(OtaBean(address: address, type: OTAMcuType.startDefaultOta));
    break;
}
```

Note: When it is the first upgrade method, the address uses the mac address in the OTA upgrade mode obtained through _blePlugin.queryDeviceOtaStatus;

## 5.5 Abort OTA<Android partial support>

Firmware abort is divided into three methods. Among them, the third upgrade method and the fourth upgrade method share a suspension method

Abort the firmware upgrade by the upgrade type obtained when the firmware version was upgraded.

Note: The ios side does not support the first and second upgrade methods, that is, the OTAMcuType parameter does not support the values of startHsOta and startRtkOta.

```dart
_blePlugin.abortOTA(OTAMcuType);
```

## 5.6 Watch OTA status<Android partial support>

```dart
int deviceDfuStatus = await _blePlugin.queryDeviceOtaStatus;
```

## 5.7 Gets Hs OTA address

Get the mac address in OTA mode.

```dart
String hsDfuAddress = await _blePlugin.queryHsOtaAddress;
```

## 5.8 Enable Hs OTA

```dart
_blePlugin.enableHsOta;
```

## 5.9 Gets Goodix OTA type

```dart
int type = await _blePlugin.queryOtaType;
```

## 5.10 Sifli Start OTA

Sifli watch starts firmware upgrade, parameter is the path of upgrade file.

Sifli watches cannot stop firmware upgrades.

```dart
_widget.blePlugin.sifliStartOTA(upgradeFilePath)
```

## 5.11 Jieli Start OTA

Jieli watch starts firmware upgrade.

```dart
_widget.blePlugin.jieliStartOTA
```

## 5.12 Jieli Abort OTA

Jieli watch stops firmware upgrade.

```dart
_widget.blePlugin.jieliAbortOTA
```

# 6 Battery

## 6.1 Sets Device Battery listener

Sets the watch battery monitoring stream deviceBatteryEveStm to return data about the watch battery.

```dart
_blePlugin.deviceBatteryEveStm.listen(
      (DeviceBatteryBean event) {
    /// Do something with new state,for example:
    setState(() {
      switch(event.type){
        case DeviceBatteryType.deviceBattery:
     		  _deviceBattery = event.deviceBattery!;
              break;
        case DeviceBatteryType.subscribe:
              _subscribe = event.subscribe!;
              break;
        default:
              break;  
      }
    });
  },
),
```

Callback Description（event）:

DeviceBatteryBean:

| callback value | callback value type | callback value description                                   |
| :------------- | :------------------ | :----------------------------------------------------------- |
| type           | int                 | Gets the type of the callback return value, where Type is the value corresponding to DeviceBatteryType |
| subscribe      | bool                | Whether the battery subscription is successful               |
| deviceBattery  | int                 | watch battery                                                |

DeviceBatteryType:

| type          | value | value description                                            |
| :------------ | :---- | :----------------------------------------------------------- |
| subscribe     | 1     | Data that represents a power subscription listening callback |
| deviceBattery | 2     | Represents the data for the power monitor callback           |

## 6.2 Gets Device Battery

Gets the current battery of the watch. When the battery level of the watch exceeds 100, it means the watch is charging.

The result is returned through the data stream deviceBatteryEveStm and stored in the deviceBattery field in "event".

```dart
_blePlugin.queryDeviceBattery;
```

## 6.3 Subscription battery

When the battery of the watch changes, the result is returned through the data stream deviceBatteryEveStm and saved in the subscribe field in "event".

```dart
_blePlugin.subscribeDeviceBattery;
```

# 7 UserInfo
## 7.1 Sets UserInfo

Sets the user's personal information to the watch.

```dart
_blePlugin.sendUserInfo(UserBean info);
```

Parameter Description :

UserBean:

| value  | value type | value description                                       |
| :----- | :--------- | :------------------------------------------------------ |
| weight | int        | Weight (used to calculate calories)                     |
| height | int        | Height (used to calculate the distance of the activity) |
| gender | int        | Gender (used to measure blood pressure or blood oxygen) |
| age    | int        | Age (for measuring blood pressure or blood oxygen)      |

## 7.2 Sets step length

In the watch firmware 1.6.6 and above, you can set the step length to the watch to calculate the activity data more accurately.

The parameter stepLength represents the distance between each step, in centimeters.

```dart
_blePlugin.sendStepLength(int stepLength);
```

Parameter Description :

| value      | value type | value description                           |
| :--------- | :--------- | :------------------------------------------ |
| stepLength | int        | Distance between each step, in centimeters. |

# 8 Weather

## 8.1 Sets today's weather

Set the watch's weather for today.

```dart
_blePlugin.sendTodayWeather(TodayWeatherBean info);
```

Parameter Description :

TodayWeatherBean:

| value     | value type | value description                         |
| :-------- | :--------- | :---------------------------------------- |
| city      | String     | City                                      |
| lunar     | String     | Lunar Festival (not necessary)            |
| festival  | String     | festival(not necessary)                   |
| pm25      | int        | PM2.5                                     |
| temp      | int        | Real-time temperature                     |
| weatherId | int        | Weather status,Parameter source WeatherId |

WeatherId：

|   type    | value | value description |
| :-------: | :---- | :---------------: |
|  cloudy   | 0     |   partly cloudy   |
|   foggy   | 1     |        fog        |
| overcast  | 2     |     overcast      |
|   rainy   | 3     |       rainy       |
|   snowy   | 4     |       snowy       |
|   sunny   | 5     |       sunny       |
| sandstorm | 6     |     sandstorm     |
|   haze    | 7     |       haze        |

## 8.2 Sets weather in the next 7 days

Sets the weather for the next 7 days to the watch.

```
_blePlugin.sendFutureWeather(FutureWeatherListBean info);
```

Parameter Description :

FutureWeatherListBean:

| value  | value type              | value description |
| :----- | :---------------------- | :---------------- |
| future | List<FutureWeatherBean> | future weather    |

FutureWeatherBean:

| value           | value type |  value description  |
| --------------- | :--------- | :-----------------: |
| weatherId       | int        |     weather Id      |
| lowTemperature  | int        | lowest temperature  |
| highTemperature | int        | maximum temperature |

# 9 Steps

## 9.1 Sets steps listener

Sets the steps change listener stepsChangeEveStm, and the result is saved in the "event" through the data stream return, which is returned as a StepsChangeBean object.

```dart
_blePlugin.stepsChangeEveStm.listen(
        (StepsChangeBean event) {
            /// Do something with new state
  });
```

Callback Description（event）:

StepsChangeBean：

| callback value   | callback value type | callback value description |
| :--------------- | :------------------ | :------------------------- |
| type             | int                 | days,from StepsChangeType  |
| stepsInfo        | StepInfoBean        | steps information          |
| historyStepsInfo | HistoryStepInfoBean | history Steps Info         |

StepsChangeType:

| type              | value | value description                      |
| :---------------- | :---- | :------------------------------------- |
| stepChange        | 1     | Gets the callback for the step change. |
| historyStepChange | 2     | Gets the step history callback.        |

StepInfoBean:

| value    | value type | value description |
| :------- | :--------- | :---------------- |
| steps    | int        | Step data         |
| distance | int        | Distance data     |
| calories | int        | Calories data     |
| time     | int        | Duration          |

HistoryStepInfoBean:

| value      | value type   | value description |
| ---------- | ------------ | ----------------- |
| historyDay | String       | Historical date   |
| stepsInfo  | StepInfoBean | steps information |

## 9.2 Gets today's steps

Get today's step count data. The query result will be obtained through the stepsChangeEveStm monitoring stream, and the type is todaySteps.

```dart
_blePlugin.querySteps;
```

## 9.3 Gets historical steps

The watch can save the number of activity steps in the past three days, and can query the number of activity steps in a certain day.

Gets the activity steps data in a certain day. The query result will be obtained through the stepsChangeEveStm listening stream, and the type is yesterdaySteps or dayBeforeYesterdaySteps.

```dart
_blePlugin.queryHistorySteps(StepsDetailDateType);
```

Parameter Description :

StepsDetailDateType:

Use yesterdaySteps and dayBeforeYesterdaySteps parameters.

| value                 | value type | value description |
| :-------------------- | :--------- | :---------------- |
| today                 | int        | 0                 |
| yesterday             | int        | 1                 |
| theDayBeforeYesterday | int        | 2                 |
| threeDaysAgo          | int        | 3                 |
| fourDaysAgo           | int        | 4                 |
| fiveDaysAgo           | int        | 5                 |
| sixDaysAgo            | int        | 6                 |

## 9.4 Sets steps detail listener

Set a step detail listener stepsDetailEveStm, and the result is saved in the "event" through the data stream return, which is returned as a StepsDetailBean object.

```dart
 _blePlugin.stepsDetailEveStm.listen(
     /// Do something with new state，for example:
        (StepsDetailBean event) {
          if (!mounted) return;
          setState(() {
            switch (event.type) {
              case StepsDetailType.stepsCategoryChange:
                stepsCategoryInfo = event.stepsCategoryInfo!;
                break;
              case StepsDetailType.actionDetailsChange:
                actionDetailsInfo = event.actionDetailsInfo!;
                break;
              default:
                break;
            }
          });
        },
      ),
```

Callback Description（event）:

StepsDetailBean：

| callback value    | callback value type | callback value description                                   |
| :---------------- | :------------------ | :----------------------------------------------------------- |
| type              | int                 | Weather change return value type, the type is StepsDetailType |
| stepsCategoryInfo | StepsCategoryBean   | The last two and a half hours                                |
| actionDetailsInfo | ActionDetailsBean   | Data on the number of steps taken throughout the day         |

Parameter Description :

StepsDetailType:

| type                | value | value description                                            |
| ------------------- | ----- | ------------------------------------------------------------ |
| stepsCategoryChange | 1     | Obtain the callbacks of the half-hour statistics of the last two days |
| actionDetailsChange | 2     | Gets the callback of the all-day step statistics             |

StepsCategoryBean：

| value        | value type |
| ------------ | ---------- |
| historyDay   | String     |
| timeInterval | int        |
| stepsList    | List<int>  |

ActionDetailsBean:

| value        | value type |
| ------------ | ---------- |
| historyDay   | String     |
| stepsList    | List<int>  |
| distanceList | List<int>  |
| caloriesList | List<int>  |

## 9.5 Gets steps detail

Some watches support categorical statistics for the past two days.

Gets classification statistics for the past two days. The query result will be obtained through the stepsDetailEveStm listening stream and saved in "event" as the StepsDetailBean object.

```
_blePlugin.queryStepsDetail(StepsDetailDateType);
```

## 9.6 Gets action details

> [!CAUTION]
>
> The method only supports JM iTOUCH Active watches and Active 3 watches.

Get half-hour counts of steps, distance, and calories throughout the day.

The query result will be obtained through the stepsDetailEveStm listening stream and saved in "event" as the ActionDetailsBean object.

```dart
_blePlugin.queryActionDetails(StepsDetailDateType);
```



# 10 Sleep

## 10.1 Sets sleep listener

Sets up a sleep monitor sleepChangeEveStm, and save the returned value in "event" with the value of the SleepBean object.

```dart
      _blePlugin.sleepChangeEveStm.listen(
        (SleepBean event) {
          /// Do something with new state,for example:
          setState(() {
            switch (event.type) {
              case SleepType.sleepChange:
                _totalTime = event.sleepInfo!.totalTime!;
                _restfulTime = event.sleepInfo!.restfulTime!;
                _lightTime = event.sleepInfo!.lightTime!;
                _soberTime = event.sleepInfo!.soberTime!;
                _remTime = event.sleepInfo!.remTime!;
                _details = event.sleepInfo!.details;
                break;
              case SleepType.historySleepChange:
                _timeType = event.historySleep!.timeType!;
                _totalTime = event.historySleep!.sleepInfo!.totalTime!;
                _restfulTime = event.historySleep!.sleepInfo!.restfulTime!;
                _lightTime = event.historySleep!.sleepInfo!.lightTime!;
                _soberTime = event.historySleep!.sleepInfo!.soberTime!;
                _remTime = event.historySleep!.sleepInfo!.remTime!;
                _details = event.historySleep!.sleepInfo!.details;
                break;
              case SleepType.goalSleepTimeChange:
                _goalSleepTime = event.goalSleepTime!;
                break;
              default:
                break;
            }
          });
        },
      ),
```

Callback Description（event）:

SleepBean：

| callback value | callback value type | callback value description                              |
| :------------- | :------------------ | :------------------------------------------------------ |
| type           | int                 | Weather change return value type, the type is SleepType |
| sleepInfo      | SleepInfo           | Current sleep information                               |
| historySleep   | HistorySleepBean    | Historical sleep information                            |
| goalSleepTime  | int                 | Target sleep time                                       |

SleepType:

| value               | value type | value description                                      |
| :------------------ | :--------- | :----------------------------------------------------- |
| sleepChange         | 1          | Gets the data returned by the current sleep monitor    |
| historySleepChange  | 2          | Gets the data returned by the historical sleep monitor |
| goalSleepTimeChange | 3          | Get the data returned by the target sleep time         |

SleepInfo：

| value       | value type       | value description |
| :---------- | :--------------- | :---------------- |
| totalTime   | int              | Total sleep time  |
| restfulTime | int              | restful time      |
| lightTime   | int              | light time        |
| soberTime   | int              | awake time        |
| remTime     | int              | rem time          |
| details     | List<DetailBean> | Sleep details     |

DetailBean:

| value     | value type | value description |
| --------- | ---------- | ----------------- |
| startTime | int        | Start time        |
| endTime   | int        | End time          |
| totalTime | int        | Total time        |
| type      | int        | Time type         |

HistorySleepBean：

| value     | value type | value description                                            |
| :-------- | :--------- | :----------------------------------------------------------- |
| timeType  | int        | days,from SleepHistoryTimeType                               |
| sleepInfo | SleepInfo  | Specifies the user's historical sleep information for the date type |

Parameter Description :

SleepHistoryTimeType:

Use yesterdaySleep and dayBeforeYesterdaySleep parameters.

| value                 | value type | value description |
| :-------------------- | :--------- | :---------------- |
| yesterday             | int        | 1                 |
| theDayBeforeYesterday | int        | 2                 |

## 10.2 Gets today's sleep

The sleep clear time of the watch is 8 pm, and the sleep time recorded by the watch is from 8 pm to 10 am the next day.

Gets detailed data for a training. The query result will be obtained through the sleepChangeEveStm listening stream and saved in the SleepBean.sleepInfo field.

```dart
_blePlugin.querySleep;
```

Built-in algorithm to increase rem sleep for watches that do not support rem.

```dart
_blePlugin.queryRemSleep;
```

## 10.3 Gets historical sleep

The watch can save the sleep data of the past three days, and can query the sleep data of a certain day.

Gets the sleep data of a certain day. The query result will be obtained through the sleepChangeEveStm listening stream and saved in the SleepBean.past field and the SleepBean.pastSleepInfo field.

```dart
_blePlugin.queryHistorySleep(HistoryTimeType);
```

## 10.4 Sets goal sleep time

The watch sets the target sleep time in minutes.

The time must be a multiple of 10, with a minimum of 10 and a maximum of 750.

```dart
_blePlugin.sendGoalSleepTime(10);
```

## 10.5 Gets gole sleep time

Gets the sleep data of a certain day. The query result will be obtained through the sleepChangeEveStm listening stream and saved in the SleepBean.past field and the SleepBean.goalSleepTime field.

```dart
_blePlugin.queryGoalSleepTime;
```

# 11 Unit system

## 11.1 Sets the unit system

The watch supports setting the time system to metric and imperial.

```
/// type see UnitSystemType
_blePlugin.sendUnitSystem(UnitSystemType);
```

Parameter Description :

 UnitSystemType:

| value          | value type | value description |
| :------------- | :--------- | :---------------- |
| metricSystem   | int        | 0                 |
| imperialSystem | int        | 1                 |

## 11.2 Gets the unit system

```
int unitSystemType = await _blePlugin.queryUnitSystem;
```

# 12 Quick view
## 12.1 Sets the quick view

Turns the quick view on or off.

```dart
/// quickViewState: true enable; false otherwise.
_blePlugin.sendQuickView(bool enable);
```

## 12.2 Gets the quick view

Gets the quick view state of the device.

```dart
bool quickViewState = await _blePlugin.queryQuickView;
```

## 12.3 Sets the effective time for quick view

The watch supports setting the effective time period for turning the wrist and turning on the screen, and it is only valid when turning the wrist and turning on the screen within the set time period.

```dart
_blePlugin.sendQuickViewTime(PeriodTimeBean);
```

Parameter Description :

PeriodTimeBean:

| value       | value type | value description     |
| ----------- | ---------- | --------------------- |
| endHour     | int        | end time hours        |
| endMinute   | int        | end time in minutes   |
| startHour   | int        | start time hours      |
| startMinute | int        | start time in minutes |

## 12.4 Gets the effective time for quick view

```dart
PeriodTimeResultBean info = await _blePlugin.queryQuickViewTime;
```

Callback Description:

PeriodTimeResultBean: 

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| periodTimeType | int                 | type of event              |
| periodTimeInfo | PeriodTimeBean      | specific event             |

PeriodTimeType：

| value            | value type | value description |
| ---------------- | ---------- | ----------------- |
| doNotDistrubType | int        | 1                 |
| quickViewType    | int        | 2                 |

Notes：PeriodTimeResultBean is a class shared by Do not disturb and Quick View. By specifying the type of periodTimeType, it indicates that the returned periodTimeInfo belongs to the information of that function

# 13 Goal steps
## 13.1 Sets goal steps

Push the user's target step number to the watch. When the number of activity steps on the day reaches the target number of steps, the watch will remind you to reach the target.

```dart
_blePlugin.sendGoalSteps(int goalSteps);
```

## 13.2 Gets goal steps

Gets the target number of steps set in the watch.

```dart
int goalSteps = await _blePlugin.queryGoalSteps;
```

## 13.3 Sets daily goals

```dart
_blePlugin.sendDailyGoals(DailyGoalsInfoBean);
```

Parameter Description :

DailyGoalsInfoBean:

| value        | value type | value description |
| ------------ | ---------- | ----------------- |
| steps        | int        | Steps data        |
| calories     | int        | Calories data     |
| trainingTime | int        | Duration          |
| distance     | int        | Distance data     |

## 13.4 Gets daily goals

```dart
DailyGoalsInfoBean dailyGoalsInfo = blePlugin.queryDailyGoals;
```

## 13.5 Sets training day goals

```dart
_blePlugin.sendTrainingDayGoals(DailyGoalsInfoBean);
```

## 13.6 Gets training day goals

```dart
DailyGoalsInfoBean dailGoalsInfo = _blePlugin.queryTrainingDayGoals
```

## 13.7 Sets training days

```dart
_blePlugin.sendTrainingDays(TrainingDayInfoBean);
```

Parameter Description :

TrainingDayInfoBean:

| value        | value type | value description        |
| ------------ | ---------- | ------------------------ |
| enable       | bool       | Support training or not. |
| trainingDays | List<int>  | Date of training         |

## 13.8 Gets training days

```dart
TrainingDayInfoBean trainingDay = _blePlugin.queryTrainingDay;
```

## 13.9 Sets and obtain exercise target reminder switch status

```dart
_blePlugin.sendGoalsRemindState(GoalsRemindStateBean);
```

Parameter Description :

GoalsRemindStateBean:

| value          | value type | value description      |
| -------------- | ---------- | ---------------------- |
| stepsEnable    | bool       | distanceEnable         |
| caloriesEnable | bool       | calories enable status |
| distanceEnable | bool       | distance enable status |

## 13.10 Gets exercise target reminder switch status

```dart
GoalsRemindStateBean goalsRemindStateBean = _blePlugin.queryGoalsRemindState;
```

# 14 Watchface

## 14.1 Sets watchface index

The watch supports a variety of different watchfaces, which can be switched freely.

Send watchface type,Parameters provided by WatchFaceType.

```
_blePlugin.sendDisplayWatchFace(WatchFaceType);
```

Parameter Description :

WatchFaceType:

| value                 | value type | value description |
| --------------------- | ---------- | ----------------- |
| firstWatchFace        | int        | 1                 |
| secondWatchFace       | int        | 2                 |
| thirdWatchFace        | int        | 3                 |
| newCustomizeWatchFace | int        | 4                 |

## 14.2 Gets the watchface

Gets the watchface being displayed.

```dart
int displayWatchFace = await _blePlugin.queryDisplayWatchFace;
```

## 14.3 Gets the watchface layout

```dart
WatchFaceLayoutBean info = await _blePlugin.queryWatchFaceLayout;
```

Parameter Description :

WatchFaceLayoutBean：

| value                | value type | value description                                            |
| -------------------- | ---------- | ------------------------------------------------------------ |
| backgroundPictureMd5 | String     | The background image MD5 has a length of 32 bits. When padded with 0, the background image  restores the default background. |
| compressionType      | String     | The compression type(LZO,RGB_DEDUPLICATION,RGB_LINE, ORIGINAL) |
| height               | int        | The watch face height default 240 px.                        |
| textColor            | int        | font color(RGB)                                              |
| thumHeight           | int        | The thum watch face height,The default is 0, which means it is not supported |
| thumWidth            | int        | The thum watch face width,The default is 0, which means it is not supported |
| timeBottomContent    | int        | Whether the content below the time is displayed. 0 means no display and 1 means display. |
| timePosition         | int        | Time location. 0 means top right and 1 means bottom right.   |
| timeTopContent       | int        | Whether the content above the time is displayed. 0 means no display and 1 means display. |
| width                | int        | The watch face width default 240 px.                         |

WatchFaceLayoutType:

| value                     | value type | value description           |
| ------------------------- | ---------- | --------------------------- |
| watchFaceTimeTop          | int        | Time is at the top right    |
| watchFaceTimeBottom       | int        | Time is at the bottom right |
| watchFaceContentclose     | int        | Do not display anything     |
| watchFaceContentDate      | int        | Date                        |
| watchFaceContentSleep     | int        | Sleep                       |
| watchFaceContentHeartRate | int        | Heart Rate                  |
| watchFaceContentStep      | int        | Steps                       |

## 14.4 Sets the watchface layout

```dart
_blePlugin.sendWatchFaceLayout(WatchFaceLayoutBean);
```

## **14.5 Sets watchface background Listener**Training

Sets up a watchface background transmission monitor fileTransEveStm, and save the returned value in "event" with the value of the FileTransBean object.

```dart
_blePlugin.fileTransEveStm.listen(
      (FileTransBean event) {
       /// Do something with new state,for example:
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
```

Callback Description（event）:

FileTransBean：

| callback value | callback value type | callback value description                                  |
| -------------- | ------------------- | ----------------------------------------------------------- |
| type           | int                 | Weather change return value type, the type is TransType     |
| isError        | bool                | Determine whether the dial background transmission is wrong |
| progress       | int                 | Dial background transfer progress                           |

TransType：

| type           | value | value description                                            |
| -------------- | ----- | ------------------------------------------------------------ |
| transStart     | 1     | Indicates that the dial background is obtained and the data returned by the monitor is transmitted |
| transChanged   | 2     | Retrieves the data returned by the dial background transmission monitor |
| transCompleted | 3     | It means to obtain the data returned by monitoring the dial background after transmission |
| error          | 4     | Indicates dial background transmission error listening for returned data |

## 14.6 Sets the watchface background

The dial of the 1.3-inch color screen supports the replacement of the background image with a picture size of 240 * 240 px. Compressed indicates whether the picture needs to be compressed (the watch with the master control of 52840 does not support compression and is fixed to false); timeout indicates the timeout period, in seconds. The progress is called back by _blePlugin.fileTransEveStm.listen.

```dart
_blePlugin.sendWatchFaceBackground(WatchFaceBackgroundBean);
```


Parameter Description :

WatchFaceBackgroundBean:

| callback value | callback value type | callback value description              |
| -------------- | ------------------- | --------------------------------------- |
| bitmap         | Uint8List           | The bitmap of background image          |
| thumbBitmap    | Uint8List           | The bitmap of thumbnail                 |
| type           | String              | WatchFaceLayoutBean.WatchFaceLayoutType |
| thumbWidth     | int                 | width of thumbBitmap                    |
| thumbHeight    | int                 | height of thumbBitmap                   |
| width          | int                 | width of bitmap                         |
| height         | int                 | height of bitmap                        |

## 14.7 Abort watchface background

Stop sending the watchface background.

```dart
_blePlugin.abortWatchFaceBackground;
```

## 14.8 Gets available storage

Check your watch's available storage space to see if you can download a new watch face. It's in kilobytes, which you multiply by 1024.

```dart
int _watchFaceSize = _blePlugin.queryAvailableStorage;
_watchFaceSize *= 1024；
```

## 14.9 Gets support watchface type

When the watch switches dials, it needs to query the type supported by the dial. jieli's clock face memory size is measured in bytes.

```dart
SupportWatchFaceBean _supportWatchFaceBean = await widget.blePlugin.querySupportWatchFace;
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
```

callback description：

SupportWatchFaceBean:

| callback value            | callback value type       | callback value description                  |
| ------------------------- | ------------------------- | ------------------------------------------- |
| type                      | String                    | SupportWatchFaceType                        |
| supportWatchFaceInfo      | SupportWatchFaceInfo      | Ordinary watch supports dial information    |
| sifliSupportWatchFaceInfo | SifliSupportWatchFaceInfo | Sifli watch supports watch face information |
| jieliSupportWatchFaceInfo | JieliSupportWatchFaceInfo | Jieli watch supports watch face information |

SupportWatchFaceType:

| type     | value     | value description |
| -------- | --------- | ----------------- |
| ordinary | "DEFAULT" | Default watch     |
| sifli    | "SIFLI"   | Sifli watch       |
| jieli    | "JIELI"   | Jieli watch       |

SupportWatchFaceInfo:

| value                | value type | value description                  |
| -------------------- | ---------- | ---------------------------------- |
| displayWatchFace     | int        | The watch face currently displayed |
| supportWatchFaceList | List<int>  | List of supported watch faces      |

## 14.10 Gets the watchface store

According to the watchface type supported by the watch, obtain a list of watchfaces that the watch can be replaced. 

Gets the list of available watch faces by way of paging query.

```dart
List<WatchFaceBean> listInfo= await _blePlugin.queryWatchFaceStore(WatchFaceStoreBean);
```

WatchFaceStoreBean :

| value                | value type | value description              |
| -------------------- | ---------- | ------------------------------ |
| watchFaceSupportList | List<int>  | watchface support type         |
| firmwareVersion      | String     | Dial firmware version number   |
| pageCount            | int        | Number of watch faces per page |
| pageIndex            | int        | current page number            |

Precautions:

watchFaceSupportList:parameters are obtained by the _blePlugin.querySupportWatchFace.

firmwareVersion:Get the firmware version number through _blePlugin.queryFirmwareVersion.

## 14.11 Gets the watchface information of the watchface ID

```dart
WatchFaceIdBean info = await _blePlugin.queryWatchFaceOfID(id);
```

Parameter Description :

WatchFaceIdBean:

| value | value type | value description                                            |
| ----- | ---------- | ------------------------------------------------------------ |
| id    | int        | The information of the dial is obtained by the id of the dial, and the parameters are obtained by the _blePlugin.queryDisplayWatchFace |

callback description：

WatchFaceIdBean:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| watchFace      | WatchFace           | watch face file            |
| error          | String              | error message              |
| code           | int                 | return code                |

WatchFace:

| value   | value type | value description             |
| ------- | ---------- | ----------------------------- |
| id      | int        | file id                       |
| preview | String     | Watchface  Image preview link |
| file    | String     | Watchface file download link  |

## 14.12 Sets watchface file listener

```dart
      _blePlugin.wfFileTransEveStm.listen(
        (FileTransBean event) {
          /// Do something with new state,for example:
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
```

Callback Description（event）:

FileTransBean：

| callback value | callback value type | callback value description                              |
| -------------- | ------------------- | ------------------------------------------------------- |
| type           | int                 | Weather change return value type, the type is TransType |
| isError        | bool                | Check whether the dial file transfer is incorrect       |
| progress       | int                 | Dial file transfer progress                             |

TransType：

| type           | value | value description                                            |
| -------------- | ----- | ------------------------------------------------------------ |
| transStart     | 1     | Retrieves the dial file and begins transmitting the data returned by the listener |
| transChanged   | 2     | Retrieves the data returned by the dial file transfer listener |
| transCompleted | 3     | Indicates that the data returned after the dial file transfer is completed |
| error          | 4     | Indicates a dial file transfer error listening for returned data |

## 14.13 Sets a watchface file

Send the watchface file of the new watchface to the watch, during which the watch will restart. 

```dart
_blePlugin.sendWatchFace(SendWatchFaceBean bean);
```

Parameter Description :

SendWatchFaceBean:

| value                | value type             | value description                |
| -------------------- | ---------------------- | -------------------------------- |
| watchFaceFlutterBean | CustomizeWatchFaceBean | Dial file information            |
| timeout              | int                    | The dial file transfer timed out |

CustomizeWatchFaceBean:

| value | value type | value description                               |
| ----- | ---------- | ----------------------------------------------- |
| index | int        | file id                                         |
| file  | String     | The address where the watch face file is stored |

## 14.14 Sets watch face id

Upload the watch face id, this method only works for jieli watches. You'll need to call this method once the jieli watch face has been uploaded.

```dart
_blePlugin.sendWatchFaceId(id);
```



## 14.14 Query Jieli WatchFace Info

Query Jieli watch face information.

```dart
JieliWatchFaceBean jieliWatchFace = _widget.blePlugin.queryJieliWatchFaceInfo;
```

JieliWatchFaceBean:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| apiVersion     | int                 | Special for Jieli watches. |
| feature        | int                 | Special for Jieli watches. |

## 14.15 Query WatchFace Store Tag List

```dart
WatchFaceStoreTagListResult result = _widget.blePlugin.queryWatchFaceStoreTagList(
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
int _tagId = result.list![0].tagId!;
```

**Precautions:**

**typeList**: parameters are obtained by the _blePlugin.querySupportWatchFace.

**firmwareVersion**: Get the firmware version number through _blePlugin.queryFirmwareVersion.

**maxSize**: Jieli watches are obtained through the querySupportWatchFace interface. Sifli and normal watches are obtained through the queryAvailableStorage interface.

## 14.16 Query WatchFace Store List

The new version of the Get Watch market, it is recommended to use the new version of the watch market to get the watch face, which supports normal, Sifli and Jieli watches.

```dart
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
```

WatchFaceBean:

| value   | value type | value description             |
| ------- | ---------- | ----------------------------- |
| id      | int        | file id                       |
| preview | String     | Watchface  Image preview link |
| file    | String     | Watchface file download link  |

**Precautions:**

**typeList**: parameters are obtained by the _blePlugin.querySupportWatchFace.

**firmwareVersion**: Get the firmware version number through _blePlugin.queryFirmwareVersion.

**maxSize**: Jieli watches are obtained through the querySupportWatchFace interface. Sifli and normal watches are obtained through the queryAvailableStorage interface.

**tagId**: Get through queryWatchFaceStoreTagList interface.

## 14.17 Query WatchFace Detail

New version of get watch face details.

```dart
WatchFaceDetailResultBean watchFaceDetailResult = _widget.blePlugin.queryWatchFaceDetail(
        WatchFaceStoreTypeBean(
            storeType: storeType,
            id: _watchFacelist[0].id!,
            typeList: _supportWatchFaceList,
            firmwareVersion: _firmwareVersion,
            apiVersion: _apiVersion,
            feature: _feature,
            maxSize: _watchFaceSize),
      );
```

WatchFaceDetailResultBean:

| callback value       | callback value type  | callback value description |
| -------------------- | -------------------- | -------------------------- |
| watchFaceBean        | WatchFaceBean        | WatchFace information      |
| watchFaceDetailsInfo | WatchFaceDetailsBean | WatchFace details          |
| error                | String               | Error messages             |

watchFaceBean:

| value   | value type | value description             |
| ------- | ---------- | ----------------------------- |
| id      | int        | file id                       |
| preview | String     | Watchface  Image preview link |
| file    | String     | Watchface file download link  |

watchFaceDetailsInfo:

| value                  | value type                   | value description |
| ---------------------- | ---------------------------- | ----------------- |
| id                     | int                          |                   |
| name                   | String                       |                   |
| download               | int                          |                   |
| size                   | int                          |                   |
| file                   | String                       |                   |
| preview                | String                       |                   |
| remarkCn               | String                       |                   |
| remarkEn               | String                       |                   |
| recommendWatchFaceList | List<RecommendWatchFaceBean> |                   |

RecommendWatchFaceBean:

| value   | value type | value description |
| ------- | ---------- | ----------------- |
| id      | int        |                   |
| name    | String     |                   |
| size    | int        |                   |
| preview | String     |                   |



# 15 Alarm

## 15.1 Gets all alarm

Gets all alarm clock information saved by the watch.

```dart
AlarmBean alarm = _blePlugin.queryAllNewAlarm;
```

Callback Description:

AlarmBean:

| callback value | callback value type  | callback  value description                                  |
| -------------- | -------------------- | ------------------------------------------------------------ |
| list           | List<AlarmClockBean> | A list of alarm clocks.                                      |
| isNew          | bool                 | If it is a new watch, true means new watch, false means old watch. |

Parameter Description :

AlarmClockBean:

| value      | value type | value description         |
| ---------- | ---------- | ------------------------- |
| id         | int        | An integer starting at 0. |
| hour       | int        | hour (24-hour format)     |
| minute     | int        | minute                    |
| repeatMode | int        | from RepeatMode           |
| enable     | bool       | enable                    |

RepeatMode：

| single                    | sunday           | monday           | tuesday           | wednesday           | thursday           | friday           | saturday           | everyday |
| ------------------------- | ---------------- | ---------------- | ----------------- | ------------------- | ------------------ | ---------------- | ------------------ | -------- |
| Single, only valid today. | Repeat on Sunday | Repeat on Monday | Repeat on Tuesday | Repeat on Wednesday | Repeat on Thursday | Repeat on Friday | Repeat on Saturday | Everyday |

## 15.2 Sets alarm

1. The old watch fixed three alarm clocks, can not be added and deleted.
2. The new watch has up to 8 alarms that can be added and removed.

```dart
_blePlugin.sendNewAlarm(AlarmClockBean);
```

## 15.3 Deleted alarm(new)

The method only supports new watches.

```dart
_blePlugin.deleteNewAlarm(AlarmClockBean.id);
```

## 15.3 Deleted all alarm(new)

The method only supports new watches.

```dart
_blePlugin.deleteAllNewAlarm();
```

# 16 Language

## 16.1 Sets the watch language

Sets the language of the watch. When setting the language, the language version will be set. Simplified Chinese is set to the Chinese version, and non-simplified Chinese is set to the international version.

```dart
_blePlugin.sendDeviceLanguage(DeviceLanguageType);
```

Parameter Description :

DeviceLanguageType:

| type                   | value | value type | value description   |
| ---------------------- | ----- | ---------- | ------------------- |
| languageEnglish        | 0     | int        | English             |
| languageChinese        | 1     | int        | Chinese Simplified  |
| languageJapanese       | 2     | int        | Japanese            |
| languageKorean         | 3     | int        | Korean              |
| languageGerman         | 4     | int        | German              |
| languageFrensh         | 5     | int        | French              |
| languageSpanish        | 6     | int        | Spanish             |
| languageArabic         | 7     | int        | Arabic              |
| languageRussian        | 8     | int        | Russian             |
| languageTraditional    | 9     | int        | traditional Chinese |
| languageUkrainian      | 10    | int        | Ukrainian           |
| languageItalian        | 11    | int        | Italian             |
| languagePortuguese     | 12    | int        | Portuguese          |
| languageDutch          | 13    | int        | Dutch               |
| languagePolish         | 14    | int        | Polish              |
| languageSwedish        | 15    | int        | Swedish             |
| languageFinnish        | 16    | int        | Finnish             |
| languageDanish         | 17    | int        | Danish              |
| languageNorwegian      | 18    | int        | Norwegian           |
| languageHungarian      | 19    | int        | Hungarian           |
| languageCzech          | 20    | int        | Czech               |
| languageBulgarian      | 21    | int        | Bulgarian           |
| languageRomanian       | 22    | int        | Romanian            |
| languageSlovakLanguage | 23    | int        | Slovak Language     |
| languageLatvian        | 24    | int        | Latvian             |

Precautions: Italian and Portuguese only support watch firmware 1.7.1 and above.

## 16.2 Gets device version

Gets the version of the watch in use.

```dart
int type = _blePlugin.queryDeviceVersion;
```

## 16.3 Gets the watch language

Gets the language that the watch is using and the list of languages supported by the watch. 

```dart 
DeviceLanguageBean info = await _blePlugin.queryDeviceLanguage;
```

Callback Description:

| callback value | callback value type | callback  value description |
| -------------- | ------------------- | --------------------------- |
| languageType   | List<int>           | All language types          |
| type           | int                 | current language type       |

# 17 Notification

## 17.1 Sets other message state<Only android support>

Enable or disable other notifications.

```dart
_blePlugin.sendOtherMessageState(bool);
```

## 17.2 Gets other message state<Only android support>

```dart
bool state = _blePlugin.queryOtherMessageState;
```

## 17.3 Gets message list

Gets the message types supported by the watch.

```dart
List<int> messageType = _blePlugin.queryMessageList;
```

## 17.4 Sets message

To send various types of message content to the watch, obtain the firmware version of the watch first.

```dart
_blePlugin.sendMessage(MessageBean);
```

Parameter Description :

MessageBean:

| **value**     | value type | value description                                          |
| ------------- | ---------- | ---------------------------------------------------------- |
| title         | String     | Message title                                              |
| message       | String     | Message content                                            |
| type          | int        | Messagetype(BleMessageType)                                |
| versionCode   | int        | Firmware version (for example: MOY-AA2-1.7.6,which is 176) |
| isHs          | bool       | Whether the MCU is HS, please confirm the MCU              |
| isSmallScreen | bool       | Is the watch screen smaller than                           |

BleMessageType:

| **value**           | value type | value description |
| ------------------- | ---------- | ----------------- |
| call                | int        | 0                 |
| sms                 | int        | 1                 |
| wechat              | int        | 2                 |
| qq                  | int        | 3                 |
| facebook            | int        | 130               |
| twitter             | int        | 131               |
| whatsApp            | int        | 4                 |
| wechatIn            | int        | 5                 |
| instagram           | int        | 6                 |
| skype               | int        | 7                 |
| kaKao               | int        | 8                 |
| line                | int        | 9                 |
| email               | int        | 11                |
| messenger           | int        | 12                |
| zalo                | int        | 13                |
| telegram            | int        | 14                |
| viber               | int        | 15                |
| nateOn              | int        | 16                |
| gmail               | int        | 17                |
| calendar            | int        | 18                |
| dailyHunt           | int        | 19                |
| outlook             | int        | 20                |
| yahoo               | int        | 21                |
| inshorts            | int        | 22                |
| phonepe             | int        | 23                |
| gpay                | int        | 24                |
| paytm               | int        | 25                |
| swiggy              | int        | 26                |
| zomato              | int        | 27                |
| uber                | int        | 28                |
| ola                 | int        | 29                |
| reflexApp           | int        | 30                |
| snapchat            | int        | 31                |
| ytMusic             | int        | 32                |
| youTube             | int        | 33                |
| linkEdin            | int        | 34                |
| amazon              | int        | 35                |
| flipkart            | int        | 36                |
| netFlix             | int        | 37                |
| hotstar             | int        | 38                |
| amazonPrime         | int        | 39                |
| googleChat          | int        | 40                |
| wynk                | int        | 41                |
| googleDrive         | int        | 42                |
| dunzo               | int        | 43                |
| gaana               | int        | 44                |
| missCall            | int        | 45                |
| whatsAppBusiness    | int        | 46                |
| dingtalk            | int        | 47                |
| tiktok              | int        | 48                |
| lyft                | int        | 49                |
| mail                | int        | 50                |
| googleMaps          | int        | 51                |
| slack               | int        | 52                |
| microsoftTeams      | int        | 53                |
| mormaiiSmartwatches | int        | 54                |
| other               | int        | 128               |

## 17.5 Sets push notifications(old)<Only ios support>

Enable or disable other push notifications

```
_blePlugin.setNotification(List<int> NotificationType);
```

Parameter Description :

NotificationType:

| **value**           | value type | value description |
| ------------------- | ---------- | ----------------- |
| call                | int        | 0                 |
| sms                 | int        | 1                 |
| wechat              | int        | 2                 |
| qq                  | int        | 3                 |
| facebook            | int        | 4                 |
| twitter             | int        | 5                 |
| instagram           | int        | 6                 |
| skype               | int        | 7                 |
| whatsApp            | int        | 8                 |
| line                | int        | 9                 |
| kakao               | int        | 10                |
| gmail               | int        | 11                |
| messenger           | int        | 12                |
| zalo                | int        | 13                |
| telegram            | int        | 14                |
| viber               | int        | 15                |
| nateOn              | int        | 16                |
| gmail               | int        | 17                |
| calenda             | int        | 18                |
| dailyHunt           | int        | 19                |
| outlook             | int        | 20                |
| yahoo               | int        | 21                |
| inshorts            | int        | 22                |
| phonepe             | int        | 23                |
| gpay                | int        | 24                |
| paytm               | int        | 25                |
| swiggy              | int        | 26                |
| zomato              | int        | 27                |
| uber                | int        | 28                |
| ola                 | int        | 29                |
| reflexApp           | int        | 30                |
| snapchat            | int        | 31                |
| ytMusic             | int        | 32                |
| youTube             | int        | 33                |
| linkEdin            | int        | 34                |
| amazon              | int        | 35                |
| flipkart            | int        | 36                |
| netFlix             | int        | 37                |
| hotstar             | int        | 38                |
| amazonPrime         | int        | 39                |
| googleChat          | int        | 40                |
| wynk                | int        | 41                |
| googleDrive         | int        | 42                |
| dunzo               | int        | 43                |
| gaana               | int        | 44                |
| missCall            | int        | 45                |
| whatsAppBusiness    | int        | 46                |
| dingtalk            | int        | 47                |
| tikTok              | int        | 48                |
| lyft                | int        | 49                |
| mail                | int        | 50                |
| googleMaps          | int        | 51                |
| slack               | int        | 52                |
| microsoftTeams      | int        | 53                |
| mormaiiSmartwatches | int        | 54                |
| other               | int        | 128               |

## 17.6 Gets push notifications(old)<Only ios support>

Returns an object of type NotificationBean.

```dart
NotificationBean notificationBean = await _blePlugin.getNotification;
```

Callback NotificationBean:

| callback value | callback value type | callback  value description                                  |
| -------------- | ------------------- | ------------------------------------------------------------ |
| isNew          | bool                | Determine if the data is new to the device                   |
| list           | List<int>           | Older devices return a list of supported message types, and newer devices return a list of 0's and 1's |

## 17.7 Sets push notifications(new)<Only ios support>

You need to get the supported message types first and create an array of the same length from the array of message types. The positions in the array are important, and each position represents a different message type. If you want to set a message, you simply set the corresponding number in the array to 0 or 1,0 for off and 1 for on.

```dart
List<int> list = List.filled(messageType.length, 0, growable: false);
list[2] = 1;
list[3] = 1;
_blePlugin.setNotification(list);
```

## 17.8 Gets push notifications(old)<Only ios support>

Returns an object of type NotificationBean.

```dart
NotificationBean notificationBean = _blePlugin.getNotification;
```

## 17.9 End call<Only android support>

When the watch receives a push of a phone type message, the watch will vibrate for a fixed time. Call this interface to stop the watch from vibrating when the watch answers the call or hangs up the call.

```dart
_blePlugin.endCall;
```

## 17.10 Sets call contact name<Only android support>

Only send the name of the outgoing contact. The incoming contact still uses sendMessage.

```dart
_blePlugin.sendCallContactName("name");
```

## 17.11 Call notification<Only android support>

Call notifications are turned off by default, so you can turn them on or off using this method.

true is used to enable incoming call notifications and false is used to disable incoming call notifications.

```dart
_blePlugin.enableIncomingNumber(true);
```

> Note:
>
> 1. You need to manually add phone permissions
> 2. Xiaomi mobile phone to obtain the incoming call number needs to obtain the Xiaomi custom permissions (read phone information)
> 3. Applications cannot listen to incoming calls after they are killed

# 18 Sedentary reminder

## 18.1 Sets sedentary reminder

Turn sedentary reminders on or off.

```dart
_blePlugin.sendSedentaryReminder(bool enable);
```

## 18.2 Gets sedentary reminder

Gets sedentary reminder status.

```dart
bool enable = await _blePlugin.querySedentaryReminder;
```

## 18.3 Sets sedentary reminder time

Sets the effective period of sedentary reminder.

```dart
_blePlugin.sendSedentaryReminderPeriod(SedentaryReminderPeriodBean info);
```

Parameter Description :

SedentaryReminderPeriodBean:

| **value** | value type | value description                        |
| --------- | ---------- | ---------------------------------------- |
| period    | int        | Sedentary reminder period (unit: minute) |
| steps     | int        | Maximum number of steps                  |
| startHour | int        | Start time (24-hour clock)               |
| endHour   | int        | End time (24-hour clock)                 |

## 18.4 Get sedentary reminder time

Query the watch for sedentary reminder valid period.

```dart
SedentaryReminderPeriodBean info = await _blePlugin.querySedentaryReminderPeriod()
```

# 19 Find the watch

Find the watch, the watch will vibrate for a few seconds after receiving this command.

```dart
_blePlugin.findDevice;
```

# 20 Heart rate

## 20.1 Sets heart rate listener

All heart rate related data will pass the _blePlugin.heartRateEveStm.listen callback.

```dart
_blePlugin.heartRateEveStm.listen(
        (HeartRateBean event) {
            /// Do something with new state,for example:
          setState(() {
            switch (event.type) {
              case HeartRateType.measuring:
                _measuring = event.measuring!;
                break;
              case HeartRateType.onceMeasureComplete:
                _onceMeasureComplete = event.onceMeasureComplete!;
                break;
              case HeartRateType.bloodOxygen:
                _historyHrList = event.historyHrList!;
                break;
              case HeartRateType.measureComplete:
                _measureComplete = event.measureComplete!;
                break;
              case HeartRateType.hourMeasureResult:
                _hour24MeasureResultList.add(event.hour24MeasureResult!);
                break;
              case HeartRateType.measureResult:
                _trainingList = event.trainingList!;
                break;
              default:
                break;
            }
          });
        });
```

Callback Description（event）:

HeartRateBean：

| callback value      | callback value type         | callback  value description                                  |
| ------------------- | --------------------------- | ------------------------------------------------------------ |
| type                | int                         | Get the corresponding return value according to type, where type is the value corresponding to HeartRateType |
| measuring           | int                         | The last dynamic heart rate measurement result               |
| onceMeasureComplete | int                         | Take a heart rate measurement                                |
| historyHrList       | List<HistoryHeartRateBean>  | Historical heart rate data                                   |
| measureComplete     | MeasureCompleteBean         | Heart rate data                                              |
| hour24MeasureResult | HeartRateInfo               | Heart rate measurement data for today or the previous day    |
| trainingList        | List<TrainingHeartRateBean> | Dynamic heart rate data                                      |

HistoryHeartRateBean：

| callback value | callback value type | callback  value description |
| -------------- | ------------------- | --------------------------- |
| date           | String              | date                        |
| hr             | int                 | heart rate                  |

MeasureCompleteBean:

| callback value         | callback value type | callback  value description          |
| ---------------------- | ------------------- | ------------------------------------ |
| historyDynamicRateType | String              | Heart rate type, exercise heart rate |
| heartRate              | HeartRateInfo       | heart rate                           |

HeartRateInfo:

| callback value | callback value type | callback  value description     |
| -------------- | ------------------- | ------------------------------- |
| startTime      | int                 | start measure heart rate time   |
| heartRateList  | List<int>           | heart rate list                 |
| timeInterval   | int                 | Heart rate measurement interval |
| heartRateType  | String              | Heart rate measurement type     |

TrainingHeartRateBean：

| type          | startTime                       | endTime                       | validTime                                    | steps                                   | distance                                               | calories |
| ------------- | ------------------------------- | ----------------------------- | -------------------------------------------- | --------------------------------------- | ------------------------------------------------------ | -------- |
| SportModeType | Start time (unit: milliseconds) | End time (unit: milliseconds) | Effective duration of exercise(unit: second) | Number of steps (partial motion mode is | Active distance (partial motion mode is not supported) | Calories |

SportModeType：

| callback value     | callback value type | callback  value description |
| ------------------ | ------------------- | --------------------------- |
| walkType           | int                 | Walking                     |
| runType            | int                 | Run                         |
| outdoorCyclingType | int                 | outdoor cycling             |
| ropeType           | int                 | rope                        |
| badmintonType      | int                 | badminton                   |
| basketballType     | int                 | basketball                  |
| footballType       | int                 | football                    |
| swimType           | int                 | swim                        |
| mountaineeringType | int                 | mountaineering              |
| tennisType         | int                 | tennis                      |
| rugbyType          | int                 | rugby                       |
| golfType           | int                 | golf                        |
| yogaType           | int                 | yoga                        |
| workoutType        | int                 | workout                     |
| danceType          | int                 | dance                       |
| baseballType       | int                 | baseball                    |
| ellipticalType     | int                 | elliptical                  |
| indoorCyclingType  | int                 | indoor cycling              |
| freeTrainingType   | int                 | free training               |
| boatingType        | int                 | boating                     |
| trailRunningType   | int                 | trail running               |
| skiType            | int                 | ski                         |
| bowlingType        | int                 | bowling                     |
| dumbbellsType      | int                 | dumbbells                   |
| sitUpsType         | int                 | sit ups                     |
| onFootType         | int                 | on foot                     |
| indoorWalkType     | int                 | indoor walk                 |
| indoorRunType      | int                 | indoor run                  |
| cricketType        | int                 | cricket                     |
| kabAddiType        | int                 | kabAddi                     |

HeartRateType:

| type                | value | value description                                            |
| ------------------- | ----- | ------------------------------------------------------------ |
| measuring           | 1     | Gets the heart rate measurement                              |
| onceMeasureComplete | 2     | Measuring once heart rate                                    |
| heartRate           | 3     | Gets history once heart rate                                 |
| measureComplete     | 4     | Data when heart rate measurement is completed                |
| hourMeasureResult   | 5     | Gets heart rate measurement data                             |
| measureResult       | 6     | Gets Action data,Query the saved heart rate measurements in three sports modes |

## 20.2 Gets last action heart rate measurement

The dynamic heart rate is measured in an unconnected state and the watch can save the last measurement. 

Query the last measured heart rate record saved by the watch. The query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.measuring field，type is measuring.

```dart
_blePlugin.queryLastDynamicRate(HistoryDynamicRateType);
```

Parameter Description :

HistoryDynamicRateType:

| value           | value type | value description |
| --------------- | ---------- | ----------------- |
| firstHeartRate  | String     | first             |
| secondHeartRate | String     | second            |
| thirdHeartRate  | String     | third             |

## 20.3 Enable timing to measure heart rate

The watch supports 24-hour timed measurement of heart rate, starting from 00:00, you can set the measurement interval, the time interval is a multiple of 5 minutes.

```dart
_blePlugin.enableTimingMeasureHeartRate(int interval);
```

## 20.4 Disable timing to measure heart rate

Turn off the timing to measure the heart rate.

```dart
_blePlugin.disableTimingMeasureHeartRate;
```

## 20.5 Gets timing to measure heart rate status

The query timing measures the heart rate on state.

```dart
int timeHR = await _blePlugin.queryTimingMeasureHeartRate;
```

## 20.6 Gets today's heart rate measurement data

Today's heart rate measurement is divided into two types, which are obtained according to the measurement method supported by the corresponding watch. 

Query today's measured heart rate value. The query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.hour24MeasureResult field，type is hourMeasureResult.

```dart
_blePlugin.queryTodayHeartRate(TodayHeartRateType);
```

TodayHeartRateType：

| type                   | value | value description              |
| ---------------------- | ----- | ------------------------------ |
| timingMeasureHeartRate | 1     | Timed heart rate measurement   |
| allDayHeartRate        | 2     | 24-hour continuous measurement |

## 20.7 Gets historical heart rate data

Query the heart rate data of the previous day. The query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.hour24MeasureResult field，type is hourMeasureResult.

```dart
_blePlugin.queryPastHeartRate;
```

## 20.8 Gets Action data

Some watchs support heart rate measurement in a variety of motion modes. The measurements include other motion-related data such as heart rate and calories. This interface is used to obtain data such as calories. The watch can save the last three sports data. Supporting 24-hour continuous measurement of the watch, the exercise heart rate can be obtained from the 24-hour heart rate data according to the movement up time; other watch exercise heart rate and dynamic heart rate acquisition methods are consistent.

The query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.trainingList field，type is measureResult.

```dart
_blePlugin.queryTrainingHeartRate;
```

## 20.9 Measuring once heart rate

Start measuring a single heart rate, the query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.measureComplete field，type is onceMeasureComplete.

```
_blePlugin.startMeasureOnceHeartRate;
```

## 20.10 Stop once heart rate

End a once measurement. A measurement time that is too short will result in no measurement data.

```
_blePlugin.stopMeasureOnceHeartRate;
```

## 20.11 Gets history once heart rate

To query the historical heart rate, the query result will be obtained through the heartRateEveStm monitoring stream and saved in the HeartRateBean.historyHrList field,type is heartRate.

```
_blePlugin.queryHistoryHeartRate;
```

# 21 Blood pressure

## 21.1 Sets blood pressure listener

```dart
       _blePlugin.bloodPressureEveStm.listen(
        (BloodPressureBean event) {
            /// Do something with new state，for example:
          setState(() {
            switch (event.type) {
              case BloodPressureType.continueState:
                _continueState = event.continueState!;
                break;
              case BloodPressureType.pressureChange:
                _bean = event.pressureChange!;
                _systolicBloodPressure = _bean!.sbp!;
                _diastolicBloodPressure = _bean!.dbp!;
                break;
              case BloodPressureType.historyList:
                _historyBpList = event.historyBpList!;
                break;
              case BloodPressureType.continueBP:
                info = event.continueBp!;
                _startTime = info!.startTime!;
                _timeInterval = info!.timeInterval!;
                break;
              default:
                break;
            }
          });
        }),
```

Callback Description（event）:

BloodPressureBean：

| callback value | callback value type            | callback value description                                   |
| -------------- | ------------------------------ | ------------------------------------------------------------ |
| type           | int                            | Get the corresponding return value according to type, where type is the value corresponding to BloodPressureType |
| continueState  | bool                           | Continue to display blood pressure status                    |
| pressureChange | BloodPressureChangeBean        | Obtain the current diastolic and systolic blood pressure     |
| historyBPList  | List<HistoryBloodPressureBean> | historical blood pressure                                    |
| continueBP     | BloodPressureInfo              | 24 hour blood pressure                                       |

BloodPressureType:

| type           | value | value description                                            |
| -------------- | ----- | ------------------------------------------------------------ |
| continueState  | 1     | Query continue blood pressure state                          |
| pressureChange | 2     | Stop measuring blood pressure and return the high and low pressure values |
| historyList    | 3     | Query history once blood pressure                            |
| continueBP     | 4     | Query last 24 hour blood pressure                            |

BloodPressureChangeBean：

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| sbp            | int                 | Systolic blood pressure    |
| dbp            | int                 | Diastolic blood pressure   |

HistoryBloodPressureBean:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| date           | String              | date of measurement        |
| sbp            | int                 | systolic blood pressure    |
| dbp            | int                 | diastolic blood pressure   |

BloodPressureInfo:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| startTime      | int                 | Start measuring time       |
| timeInterval   | int                 | Intervals                  |

## 21.2 Measuring blood pressure

```
_blePlugin.startMeasureBloodPressure;
```

## 21.3 Stop measuring blood pressure

Stop measuring blood pressure, too short a measurement time will result in no measurement results.

The measurement results are monitored through the bloodPressureEveStm data stream, and the returned high and low pressure values are stored in BloodPressureBean.bloodPressureChange and BloodPressureBean.bloodPressureChange1, respectively,type is pressureChange.

```
_blePlugin.stopMeasureBloodPressure;
```

## 21.4 Enable continue blood pressure

```
_blePlugin.enableContinueBloodPressure;
```

## 21.5 Disable continue blood pressure

```
_blePlugin.disableContinueBloodPressure;
```

## 21.6 Gets continue blood pressure state

The measurement results are monitored through the bloodPressureEveStmdata stream, and the continue blood pressure state is stored in BloodPressureBean.continueState,type is continueState.

```
_blePlugin.queryContinueBloodPressureState;
```

## 21.7 Gets last 24 hour blood pressure

The measurement results are monitored through the bloodPressureEveStmdata stream, and the last 24 hour blood pressure is stored in BloodPressureBean.continueBP,type is continueBP.

```
_blePlugin.queryLast24HourBloodPressure;
```

## 21.8 Gets history once blood pressure

The measurement results are monitored through the bloodPressureEveStmdata stream, and the history once blood pressure is stored in BloodPressureBean.historyBPList,type is historyList.

```
_blePlugin.queryHistoryBloodPressure;
```

# 22 Blood oxygen

## 22.1 Sets blood oxygen listener

```dart
_blePlugin.bloodOxygenEveStm.listen(
   (BloodOxygenBean event) {
      /// Do something with new state，for example:
     switch (type) {
              case BloodOxygenType.continueState:
                _continueState = event.continueState!;
                break;
              case BloodOxygenType.timingMeasure:
                _timingMeasure = event.timingMeasure!;
                break;
              case BloodOxygenType.bloodOxygen:
                _bloodOxygen = event.bloodOxygen!;
                break;
              case BloodOxygenType.historyList:
                _historyList = event.historyList!;
                break;
              case BloodOxygenType.continueBO:
                _continueBo = event.continueBo!;
                startTime = _continueBo!.startTime!;
                timeInterval = _continueBo!.timeInterval!;
                break;
              default:
                break;
            }
  });
```

Callback Description（event）:

BloodOxygenBean：

| callback value | callback value type          | callback value description                                   |
| -------------- | ---------------------------- | ------------------------------------------------------------ |
| type           | int                          | Get the corresponding return value according to type, where type is the value corresponding to BloodOxygenType |
| continueState  | bool                         | Timed blood oxygen status                                    |
| timingMeasure  | int                          | Timed oximetry status                                        |
| bloodOxygen    | int                          | Measure blood oxygen results                                 |
| historyList    | List<HistoryBloodOxygenBean> | Historical SpO2 information                                  |
| continueBO     | BloodOxygenInfo              | Timed blood oxygen information                               |

BloodOxygenType:

| type          | value | value description                              |
| ------------- | ----- | ---------------------------------------------- |
| continueState | 1     | Gets continue blood oxygen state               |
| timingMeasure | 2     | Gets timing measurement of blood oxygen status |
| bloodOxygen   | 3     | Gets blood oxygen measurement results          |
| historyList   | 4     | Gets history once blood oxygen                 |
| continueBO    | 5     | Gets timing blood oxygen                       |

HistoryBloodOxygenBean:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| date           | String              | date                       |
| bo             | int                 | blood oxygen               |

BloodOxygenInfo：

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| startTime      | int                 | Start measuring time       |
| timeInterval   | int                 | time interval              |

## 22.2 Measuring blood oxygen

```
_blePlugin.startMeasureBloodOxygen;
```

## 22.3 Stop measuring blood oxygen

When the blood oxygen measurement is stopped, if the measurement time is too short, there will be no measurement results. 

The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.bloodOxygen,type is bloodOxygen.

```
_blePlugin.stopMeasureBloodOxygen;
```

## 22.4 Enable timing measure blood oxygen

measure period = interval * 5 (mins)

```
_blePlugin.enableTimingMeasureBloodOxygen(int interval);
```

## 22.5 Disable timing measure blood oxygen

```
_blePlugin.disableTimingMeasureBloodOxygen;
```

## 22.6 Gets timing measure blood oxygen state

The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.timingMeasure,type is timingMeasure.

```
_blePlugin.queryTimingBloodOxygenMeasureState;
```

## 22.7 Gets timing blood oxygen

The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.continueBO,type is continueBO.

```
_blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType);
```

Parameter Description :

BloodOxygenTimeType:

| value     | value type | value description |
| --------- | ---------- | ----------------- |
| today     | String     | today             |
| yesterday | String     | yesterday         |

## 22.8 Enable continue blood oxygen

```
_blePlugin.enableContinueBloodOxygen;
```

## 22.9 Disable continue blood oxygen

```
_blePlugin.disableContinueBloodOxygen;
```

## 22.10 Gets continue blood oxygen state

The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.continueState,type is continueState.

```
_blePlugin.queryContinueBloodOxygenState;
```

## 22.11 Gets last 24 hour blood oxygen

The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.continueBO,type is continueBO.

```
_blePlugin.queryLast24HourBloodOxygen;
```

## 22.12 Gets history once blood oxygen

The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.historyList,type is historyList.

```
_blePlugin.queryHistoryBloodOxygen;
```

# 23 Take a photo

## 23.1 Sets photo monitor listener

```dart
_blePlugin.cameraEveStm.listen(
  (CameraBean event) {
    // Do something with new state
    if (!mounted) return;
          setState(() {
            switch (event.type) {
              _camera = event.takePhoto!;
            _delayTime = event.delayTime!;
          });
  });
```

Callback Description（event）:

CameraBean:

| callback value | callback value type | callback value description          |
| -------------- | ------------------- | ----------------------------------- |
| takePhoto      | String              | Start taking pictures               |
| delayTime      | int                 | The time of a time-lapse photograph |

## 23.2 Enable camera view

```
_blePlugin.enterCameraView;
```

## 23.3 Exit camera view

```
_blePlugin.exitCameraView;
```

## 23.4 Sets time-lapse photo

Unit: second.

```dart
_blePlugin.sendDelayTaking(100));
```

## 23.5 Gets the time of a time-lapse photo

The data is returned by listening to the cameraEveStm.

```dart
_blePlugin.queryDelayTaking;
```

# 24 Mobile phone related operations

Set up a listener for phone-related operations such as music control, hanging up, and callbacks. The result is returned via the data stream phoneEveStm.

The value data comes from PhoneOperationType and matches it

```dart
_blePlugin.phoneEveStm.listen(
  (int event) {
    // Do something with new state
  })；
```

PhoneOperationType:

| value | value type | value description                                            |
| ----- | ---------- | ------------------------------------------------------------ |
| 0     | int        | Play / Pause                                                 |
| 1     | int        | Previous                                                     |
| 2     | int        | Next                                                         |
| 3     | int        | Hang up the phone. You can press and hold the trigger on the call alert interface. |
| 4     | int        | Turn up the volume                                           |
| 5     | int        | Turn down the volume                                         |
| 6     | int        | Play                                                         |
| 7     | int        | Pause                                                        |

# 25 RSSI<Only android support>

## 25.1 Sets RSSI listener

Set up an RSSI listener deviceRssiEveStm, which returns the RSSI value through the data stream.

```dart
_blePlugin.deviceRssiEveStm.listen(
  (int event) {
    // Do something with new state
  });
```

## 25.2 Read the watch RSSI

Read the real-time RSSI value of the watch. The query result will be obtained through the deviceRssiEveStm listening stream.

```
_blePlugin.readDeviceRssi;
```

# 26 Shut down

```
 _blePlugin.shutDown;
```

# 27 Do not disturb

## 27.1 Sets the do not disturb time

The watch supports the Do Not Disturb period. Do not display message push and sedentary reminders during the time.

```dart
 _blePlugin.sendDoNotDisturbTime(PeriodTimeBean info);
```

Parameter Description :

PeriodTimeBean:

| value       | value type | value description                |
| ----------- | ---------- | -------------------------------- |
| startHour   | int        | Start time hours (24-hour clock) |
| startMinute | int        | Start time minutes               |
| endHour     | int        | End time hours (24-hour clock)   |
| endMinute   | int        | End time minutes                 |

## 27.2 Gets the do not disturb time

Check if do not disturb the time set by the watch.

```dart
PeriodTimeResultBean info = await _blePlugin.queryDoNotDisturbTime;
```

Callback Description(event):

PeriodTimeResultBean:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| periodTimeType | int                 | type of event              |
| periodTimeInfo | PeriodTimeBean      | specific event             |

periodTimeType:

| value            | value type | value description |
| ---------------- | ---------- | ----------------- |
| doNotDistrubType | int        | 1                 |
| quickViewType    | int        | 2                 |

Notes：PeriodTimeResultBean is a class shared by Do not disturb and Quick View. By specifying the type of periodTimeType, it indicates that the returned periodTimeInfo belongs to the information of that function

# 28 Breathing light

## 28.1 Sets the breathing light<Only android support>

```dart
_blePlugin.sendBreathingLight(bool enable);
```

## 28.2 Gets the status of the breathing light<Only android support>

```dart
bool isEable= await _blePlugin.queryBreathingLight;
```

# 29 ECG

## 29.1 Sets ECG listener

Sets the ECG monitor and get the return value through ecgEveStm.

```dart
_blePlugin.ecgEveStm.listen(
        (EgcBean event) {
             /// Do something with new state,for example:
          setState(() {
            switch (event.type) {
              case ECGType.ecgChangeInts:
                _ints = event.ints!;
                break;
              case ECGType.measureComplete:
                break;
              case ECGType.date:
                _date = event.date!;
                break;
              case ECGType.cancel:
                break;
              case ECGType.fail:
                break;
            }
          });
        });
```

Callback Description（event）:

EgcBean:

| callback value | callback value type | callback value description                                   |
| -------------- | ------------------- | ------------------------------------------------------------ |
| type           | int                 | Get the corresponding return value according to type, where type is the value corresponding to ECGType |
| ints           | int[]               | ECG information                                              |
| date           | Date                | date                                                         |

ECGType:

| type            | value | value description        |
| --------------- | ----- | ------------------------ |
| ecgChangeInts   | 1     | measure ECG              |
| measureComplete | 2     | ECG measurement complete |
| date            | 3     | ECG measurement date     |
| cancel          | 4     | ECG measurement off      |
| fail            | 5     | ECG measurement failed   |

## 29.2 Measuring ECG

Start to measure the ECG, the ECG measurement time is 30 seconds, and the user needs to touch the left and right electrodes of the watch with both hands. The value is obtained by listening to the ecgEveStm data stream, and the value is saved in EgcBean.ints,type is ecgChangeInts.

```dart
_blePlugin.startECGMeasure;
```

## 29.3 Stop measuring ECG

```
_blePlugin.stopECGMeasure;
```

## 29.4 Detect new ECG measurement methods

In the new measurement mode, the watch can save the last unsent measurement result; the old version does not.

```dart
bool newMeasurementVersion =await _blePlugin.isNewECGMeasurementVersion;
```

## 29.5 Gets the last ECG data

Gets the ECG data saved by the watch, monitor the data stream through ecgEveStm , and save the value in EgcBean.ints,type is ecgChangeInts.

```dart
_blePlugin.queryLastMeasureECGData;
```

## 29.6 Sets heart rate during ECG measurement

Using the measured data, the instantaneous heart rate is calculated through the ECG algorithm library and sent to the watch.

```
_blePlugin.sendECGHeartRate(int heartRate);
```

# 30 Menstrual Cycle

## 30.1 Sets the menstrual cycle reminder

```
_blePlugin.sendMenstrualCycle(MenstrualCycleBean info);
```

Parameter Description :

MenstrualCycleBean：

| value                | value type | value description                                            |
| -------------------- | ---------- | ------------------------------------------------------------ |
| physiologcalPeriod   | int        | Menstrual cycle (unit: day)1                                 |
| menstrualPeriod      | int        | Menstrual period (unit: day)                                 |
| startDate            | String     | menstrual cycle start time(Month and day are used; all other years, hours, minutes, and seconds are the current time) |
| menstrualReminder    | bool       | Menstrual start reminder time (the day before the menstrual cycle reminder) |
| ovulationReminder    | bool       | Ovulation reminder (a reminder the day before ovulation)     |
| ovulationDayReminder | bool       | Ovulation Day Reminder (Reminder the day before ovulation)   |
| ovulationEndReminder | bool       | Reminder when ovulation is over (a reminder the day before the end of ovulation) |
| reminderHour         | int        | Reminder time (hours, 24 hours)                              |
| reminderMinute       | int        | Reminder time (minutes)                                      |

## 30.2 Gets the menstrual cycle reminder

```dart
MenstrualCycleBean info = await _blePlugin.queryMenstrualCycle;
```

# 31 Find phone

## 31.1 Start find phone

When receiving a callback to find the bracelet phone, the app vibrates and plays a ringtone reminder.

```dart
_blePlugin.startFindPhone;
```

## 31.2 End finding phone

When the user retrieves the phone, the vibrate and ringtone reminder ends, returning to the watch with this command.

```dart
_blePlugin.stopFindPhone;
```

# 32 Music player<Only android support>

## 32.1 Sets player state

Set music player state.

```dart
_blePlugin.setPlayerState(PlayerStateType);
```

Parameter Description :

PlayerStateType：

| type             | value | value description |
| ---------------- | ----- | ----------------- |
| musicPlayerPause | int   | pause             |
| musicPlayerPlay  | int   | play              |

## 32.2 Sets song name

```
_blePlugin.sendSongTitle(String title);
```

## 32.3 Sets lyrics

```
_blePlugin.sendLyrics(String lyrics);
```

## 32.4 Close Music Control

```
_blePlugin.closePlayerControl;
```

## 32.5 Sets max volume

```
_blePlugin.sendMaxVolume(int volume);
```

## 32.6 Sets Current volume

```
_blePlugin.sendCurrentVolume(int volume);
```

# 33 Drink water reminder

## 33.1 Enable drinking reminder

Sets the information of drinking water reminder.

```
_blePlugin.enableDrinkWaterReminder(DrinkWaterPeriodBean info);
```

Parameter Description :

DrinkWaterPeriodBean:

| value       | value type | value description           |
| ----------- | ---------- | --------------------------- |
| enable      | bool       | Drink water reminder status |
| startHour   | int        | start time hours            |
| startMinute | int        | start time in minutes       |
| count       | int        | Number of reminders         |
| period      | int        | reminder interval           |
| currentCups | int        | the current water intake    |

## 33.2 Disable water reminder

```
_blePlugin.disableDrinkWaterReminder;
```

## **33.3 Gets drinking **reminder

```dart
DrinkWaterPeriodBean info = await _blePlugin.queryDrinkWaterReminderPeriod;
```

# 34 Heart rate alarm

## 34.1 Sets the heart rate alarm value

```dart
_blePlugin.setMaxHeartRate(MaxHeartRateBean info);
```

Parameter Description :

MaxHeartRateBean:

| value     | value type | value description                        |
| --------- | ---------- | ---------------------------------------- |
| heartRate | int        | Heart rate alarm value                   |
| enable    | bool       | Status of the wristband heart rate alarm |

## 34.2 Gets the heart rate alarm value

Gets the status of the wristband heart rate alarm and the value of the heart rate alarm.

```dart
MaxHeartRateBean info = await _blePlugin.queryMaxHeartRate;
```

# 35 Movement Training<Only android support>

## 35.1 Sets Monitor training state listener

Modify the training state on the bracelet, and obtain the current measurement state by monitoring the data stream trainingStateEveStm.

```dart
_blePlugin.trainingStateEveStm.listen(
  (int event) {
   // Do something with new state
  })；
```

## 35.2 Start training

```
_blePlugin.startTraining(int type);
```

Parameter Description :

Type is the same as "Heart Rate". Type is the same.

## 35.3 Sets training state

```
_blePlugin.setTrainingState(TrainingHeartRateStateType);
```

Parameter Description :

TrainingHeartRateStateType：

| type             | value | value description |
| ---------------- | ----- | ----------------- |
| trainingPause    | int   | pause state       |
| trainingContinue | int   | continue state    |
| trainingComplete | int   | end state         |

# 36 Protocol version<Only android support>

Gets the protocol version.The current protocol version can be divided into V1 and V2.

```dart
String version=await _blePlugin.getProtocolVersion;
```

# 37 Body temperature

## 37.1 Sets listener of temperature measurement results

Sets the monitoring of body temperature measurement results to return the corresponding data of body temperature.

```dart
_blePlugin.tempChangeEveStm.listen(
        (TempChangeBean event) {
          setState(() {
            /// Do something with new state,for example:
            switch (event.type) {
              case TempChangeType.continueState:
                _enable = event.enable!;
                break;
              case TempChangeType.measureTemp:
                _temp = event.temp!;
                break;
              case TempChangeType.measureState:
                _state = event.state!;
                break;
              case TempChangeType.continueTemp:
                _tempInfo = event.tempInfo;
                _tempTimeType = _tempInfo!.tempTimeType!;
                _startTime = _tempInfo!.startTime!;
                _tempList = _tempInfo!.tempList!;
                break;
              default:
                break;
            }
          });
        });
```

Callback Description（event）:

TempChangeBean：

| callback value | callback value type | callback value description                                   |
| -------------- | ------------------- | ------------------------------------------------------------ |
| type           | int                 | Get the corresponding return value according to type, where type is the value corresponding to TempChangeType |
| enable         | bool                | whether to continue measuring<br />true:enable  false:disable |
| temp           | double              | real-time body temperature                                   |
| state          | bool                | temperature measurement status true:measuring  false:end of measurement |
| tempInfo       | TempInfo            | Body temperature information                                 |

TempChangeType：

| type          | value | value description                                            |
| ------------- | ----- | ------------------------------------------------------------ |
| continueState | 1     | Continue to measure body temperature                         |
| measureTemp   | 2     | Start measuring the temperature obtained by taking the temperature |
| measureState  | 3     | measure body temperature                                     |
| continueTemp  | 4     | The temperature value obtained by continuing to measure the body temperature |

TempInfo

| callback value  | callback value type | callback value description                              |
| --------------- | ------------------- | ------------------------------------------------------- |
| type            | TempTimeType        | Body temperature timing measurement status.             |
| startTime       | long                | Temperature measurement start time                      |
| tempList        | List<Float>         | Temperature record sheet                                |
| measureInterval | int                 | Measurement interval (unit: minute, default 30 minutes) |

TempTimeType:

| type      | value type | value       |
| --------- | ---------- | ----------- |
| today     | String     | "TODAY"     |
| yesterday | String     | "YESTERDAY" |

## 37.2 Start measuring once temperature

Start taking temperature.

When starting a temperature measurement. The query result will be obtained through the tempChangeEveStm monitoring stream, the return type is TempChangeBean, and the real-time body temperature and measurement status are TempChangeBean.temp and TempChangeBean.state,type ismeasureTemp and type is measureState Respectively.

```dart
_blePlugin.startMeasureTemp;
```

## 37.3 Stop measuring once temperature

```
_blePlugin.stopMeasureTemp;
```

## 37.4 Enable timing temperature measurement

When the chronograph measurement is turned on, the watch automatically measures the temperature every half an hour.

```dart
_blePlugin.enableTimingMeasureTemp;
```

## 37.5 Disable timing temperature measurement

```
_blePlugin.disableTimingMeasureTemp;
```

## 37.6 Gets the timing of temperature measurement status

Get the temperature measurement status. The query result will be obtained through the tempChangeEveStm monitoring stream, the type is measureState, and the measurement state is TempChangeBean.state.

```dart
String timingTempState = await _blePlugin.queryTimingMeasureTempState;
```

## 37.7 Gets the result of timing temperature measurement

The measurement state is obtained through tempChangeEveStm, and the result is stored in TempChangeBean.continueTemp.

```dart
_blePlugin.queryTimingMeasureTemp(TempTimeType);
```

# 38 Display time

## 38.1 Sets display time

time is the screen-on time, Bright screen event 5-30s, increment by 5.

```
_blePlugin.sendDisplayTime(DisplayTimeType);
```

Parameter Description :

DisplayTimeType:

| value             | value type | value description |
| ----------------- | ---------- | ----------------- |
| displayFive       | int        | 5s                |
| displayTen        | int        | 10s               |
| displayFifteen    | int        | 15s               |
| displayTwenty     | int        | 20s               |
| displayTwentyFive | int        | 25s               |
| displayThirty     | int        | 30s               |

## 38.2 Gets display time

```dart
int displayTime = await _blePlugin.queryDisplayTime;
```

# 39 Hand washing reminder

## 39.1 Enable hand washing reminder

```dart
 _blePlugin.enableHandWashingReminder(HandWashingPeriodBean info);
```

Parameter Description :

HandWashingPeriodBean:

| value       | value type | value description     |
| ----------- | ---------- | --------------------- |
| enable      | bool       | Whether to open       |
| startHour   | int        | Start time hours      |
| startMinute | int        | Start time in minutes |
| count       | int        | count                 |
| period      | int        | period                |

## 39.2 Disable hand washing reminder

```dart
_blePlugin.disableHandWashingReminder;
```

## 39.3 Gets hand washing reminder

```dart
HandWashingPeriodBean info= await _blePlugin.queryHandWashingReminderPeriod;
```

# 40 Sets local city

```dart
_blePlugin.sendLocalCity(String city);
```

# 41 Temperature system<Only android support>

## 41.1 Sets temperature system

Switch temperature system.

```dart
_blePlugin.sendTempUnit(TempUnit);
```

Parameter Description :

TempUnit:

| value      | value type | value description |
| ---------- | ---------- | ----------------- |
| celsius    | int        | 0                 |
| fahrenheit | int        | 1                 |

## 41.2 Gets temperature system

Get temperature system data. The query result will be obtained through the weatherChangeEveStm listening stream, the return type is tempUnitChange, and the temperature system data is WeatherChangeBean.tempUnit,type is tempUnitChange .

```dart
_blePlugin.queryTempUnit;
```

# 42 Brightness<Only android support>

## 42.1 Sets brightness

```dart
_blePlugin.sendBrightness(int brightness);
```

## 42.2 Gets brightness

```dart
BrightnessBean bean = await _blePlugin.queryBrightness;
```

Callback Description:

BrightnessBean:

| allback value | callback value type | callback value description |
| ------------- | ------------------- | -------------------------- |
| current       | int                 | current brightness         |
| max           | int                 | maximum brightness         |

# 43 Classic Bluetooth address

```
String btAddres = await _blePlugin.queryBtAddress;
```

# 44 Contacts

## 44.1 Sets contacts listener

Set the contact listener, and the result is returned through the data stream contactEveStm, which is returned as a ContactListenBean object.

```dart
_blePlugin.contactEveStm.listen(
        (ContactListenBean event) {
            /// Do something with new state,for example:
          setState(() {
            switch (event.type) {
              case ContactListenType.savedSuccess:
                _savedSuccess = event.savedSuccess!;
                break;
              case ContactListenType.savedFail:
                _savedFail = event.savedFail!;
                break;
              default:
                break;
            }
          });
        });
```

Callback Description（event）:

ContactListenBean:

| callback value | callback value type | callback value description                                   |
| -------------- | ------------------- | ------------------------------------------------------------ |
| type           | int                 | Get the corresponding return value according to type, where type is the value corresponding to ContactListenType. |
| savedSuccess   | int                 | The return value of the success of saving the contact;       |
| savedFail      | int                 | The return value of the failure to save the contact          |

ContactListenType：

| type         | value | value description         |
| ------------ | ----- | ------------------------- |
| savedSuccess | 1     | Set contacts successfully |
| savedFail    | 2     | Failed to set contacts    |

## 44.2 Sets contacts with avatar listener

Sets the contact avatar listener, and the result is returned through the data stream contactAvatarEveStm, which is returned as a FileTransBean object.

```dart
_blePlugin.contactAvatarEveStm.listen(
        (FileTransBean event) {
            /// Do something with new state,for example:
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
        });
```

Callback Description（event）:

FileTransBean:

| callback value | callback value type | callback value description                                   |
| -------------- | ------------------- | ------------------------------------------------------------ |
| type           | int                 | Get the corresponding return value according to type, where type is the value corresponding to TransType. |
| progress       | int                 | set progress                                                 |
| error          | int                 | error code                                                   |

TransType：

| type           | value | value description                   |
| -------------- | ----- | ----------------------------------- |
| transStart     | 1     | Set a contact avatar to get started |
| transChanged   | 2     | Set contact avatar progress changes |
| transCompleted | 3     | Set contact avatar successfully     |
| error          | 4     | Error setting contact avatar        |

## 44.3 Check support contacts

```dart
ContactConfigBean info = await _blePlugin.checkSupportQuickContact;
```

Callback Description:

ContactConfigBean：

| value     | value type | value description                          |
| --------- | ---------- | ------------------------------------------ |
| supported | bool       | Whether symbols are supported, such as ”+“ |
| count     | int        | Maximum number of contacts                 |
| width     | int        | The width of the contact avatar            |
| height    | int        | The height of contact avatar               |

## 44.4 Gets current contacts count

```
int contactCount = _blePlugin.queryContactCount;
```

## 44.5 Sets contact information

Sets the contact, the result is obtained through contactEveStm.

```
_blePlugin.sendContact(ContactBean info);
```

Parameter Description :

ContactBean:

| value   | value type | value description         |
| ------- | ---------- | ------------------------- |
| id      | int        | The contact id            |
| width   | int        | The contact avatar width  |
| height  | int        | The contact avatar height |
| address | int        | The contact address       |
| name    | String     | The contact name          |
| number  | String     | The contact phone number  |
| avatar  | Uint8List? | The contact avatar        |

Precautions:

- The Uint8List? type is a picture type, interacts with the backend, and converts it to a bitmap type at the backend.
- Contacts sent to the watch face, must have an avatar.
- id has size limit. The maximum value of id can be viewed through count in the return value of _blePlugin.checkSupportQuickContact, and cannot be greater than or equal to the queried value.

## 44.6 Sets contact avatar information

Sets the contact avatar  , the result is obtained through contactAvatarEveStm.

```
_blePlugin.sendContactAvatar(ContactBean info);
```

## 44.7 Delete contacts information

Delete contact information based on contact id.

```dart
_blePlugin.deleteContact(int id);
```

## 44.8 Delete contacts avatar  information

Delete contact avatar   information based on contact id.

```dart
_blePlugin.deleteContactAvatar(int id);
```

## 44.9 clear contacts information

```dart
_blePlugin.clearContact();
```

# 45 Battery Saving

## 45.1 Sets battery saving **listener**

Set the battery storage listener, the result is returned through the data stream, and the Batter saving state saved in "event".

```dart
_blePlugin.batterySavingEveStm.listen(
         (bool event) {
         // Do something with new state
        });
```

## 45.2 Sets battery saving state

```
_blePlugin.sendBatterySaving(bool enable);
```

## 45.3 Gets battery saving state

The result of Batter saving state will be obtained through the batterySavingEveStm monitoring stream.

```dart
 _blePlugin.queryBatterySaving;
```

# 46 Pill Reminder

## 46.1 Gets support pill reminder

```dart
PillReminderCallback info = await _blePlugin.queryPillReminder;
```

Parameter Description :

PillReminderBean:

| value        | value type             | value description  |
| ------------ | ---------------------- | ------------------ |
| supportCount | int                    | number of supports |
| list         | List<PillReminderBean> | Pill reminder list |

PillReminderBean:

| value            | value type                              | value description                         |
| ---------------- | --------------------------------------- | ----------------------------------------- |
| id               | int                                     | The pill id                               |
| dateOffset       | int                                     | Start taking medicine in a few            |
| name             | String                                  | The pill name                             |
| repeat           | int                                     | The take medicine every few  days         |
| reminderTimeList | List<PillReminderBean.ReminderTimeBean> | The time point and dosage of the medicine |

PillReminderInfo.ReminderTimeBean:

| value | value type | value description                             |
| ----- | ---------- | --------------------------------------------- |
| time  | int        | Medication time(For example, 100 is 01:40 am) |
| count | int        | The dose                                      |

## **46.2 Sets pill **reminder

```dart
_blePlugin.sendPillReminder(PillReminderBean info);
```

## 46.3 Delete pill reminder

Delete reminder message based on pill reminder id

```dart
_blePlugin.deletePillReminder(int id);
```

## 46.4 Clear pill reminder

```dart
_blePlugin.clearPillReminder;
```

# 47 Tap to wake

## 47.1 Gets tap to wake state

Gets whether it is in the wake-up state. If the result is true, it means that it is in the awake state, otherwise, it is not awake.

```dart
bool wakeState = await _blePlugin.queryWakeState;
```

## 47.2 Sets tap to wake state

```
 _blePlugin.sendWakeState(bool enable);
```

# 48 Training<Only android support>

## 48.1 Sets training listener

Set up a training listener, and the result is returned through the data stream and saved in the "event" as a TrainBean object.

```dart
_blePlugin.trainingEveStm.listen(
        (TrainBean event) {
            /// Do something with new state,for example:
          setState(() {
            switch (event.type) {
              case TrainType.historyTrainingChange:
                _historyTrainList = event.historyTrainList!;
                break;
              case TrainType.trainingChange:
                _trainingList = event.trainingList!;
                break;
              default:
                break;
            }
          });
        });
```

Callback Description（event）：

TrainBean

| callback value   | callback value type    | callback value description                                   |
| ---------------- | ---------------------- | ------------------------------------------------------------ |
| type             | int                    | Get the corresponding return value according to type, where type is the value corresponding to TrainType. |
| historyTrainList | List<HistoryTrainList> | Historical training information.                             |
| trainingInfo     | List<TrainingInfo>     | Training information.                                        |

TrainType:

| type                  | value | value description     |
| --------------------- | ----- | --------------------- |
| historyTrainingChange | 1     | Gets History Training |
| trainingChange        | 2     | Gets Training Detail  |

HistoryTrainList:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| id             | int                 | Training id                |
| startTime      | long                | Training start time        |
| type           | int                 | The training typestartTime |

TrainingInfo:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| type           | int                 | The training type          |
| startTime      | long                | Training start time        |
| endTime        | long                | Training end time          |
| validTime      | int                 | Training duration          |
| steps          | int                 | Steps                      |
| distance       | int                 | Distance                   |
| calories       | int                 | Calories                   |
| hrList         | List<int>           | heart rate list            |

## 48.2 Gets History Training

Get historical training details. The query results will flow through trainingEveStm monitoring, the return type is historyTrainingChange and trainingChange, training history data for TrainBean. HistoryTrainList, The training details data is TrainBean.trainingList.

```dart
_blePlugin.queryHistoryTraining;
```

## 48.3 Gets Training Detail

Get detailed data for training. The query result will be obtained through the trainingEveStm monitoring stream, the return type is trainingChange, and the training detailed data is TrainBean.trainingInfo.

```dart
_blePlugin.queryTraining(int id);
```

Parameter Description :

| value | value type | value description          |
| ----- | ---------- | -------------------------- |
| id    | int        | id is the id of a training |

Precautions:

Get the training history first.

# 49 Calibrate the GSensor

If the screen is not sensitive or inaccurate, the watch can be corrected by calibrating the GSensor. During the calibration process, the watch is placed horizontally on the desktop.

```dart
_blePlugin.sendGsensorCalibration;
```

# 50 Sos

Set up a sos listener, and the result is returned through the data stream and saved in the "event" as a sosChangeEveStem object.

```dart
_blePlugin.sosChangeEveStem.listen(
		(dynamic event) {
				/// Do something with new state,for example:
		}
)
```

# 51 Pairing

Some watches require the user to confirm the pairing on the watch after successful connection.

```dart
int key = _blePlugin.createBond(byte[])
```

# 52 HRV

## 52.1 Sets HRV listener

Set up a HRV listener, and the result is returned through the data stream and saved in the "event" as a newHrvEveStm object.

```dart
_blePlugin.newHrvEveStm.listen(
       (HrvHandlerBean event) {
        ......
    },
  ),
```

Callback Description（event）：

HrvHandlerBean:

| callback value | callback value type      | callback value description                                   |
| -------------- | ------------------------ | ------------------------------------------------------------ |
| type           | int                      | Get the corresponding return value according to type, where type is the value corresponding to HRVType. |
| isSupport      | bool                     | Whether the watch supports                                   |
| value          | int                      | HRV value of the watch                                       |
| list           | List<HistoryHrvInfoBean> | The HRV history of the watch                                 |

HRVType:

| type    | vlaue | value description                           |
| ------- | ----- | ------------------------------------------- |
| support | 1     | Whether the watch supports a callback       |
| hrv     | 2     | Reset the HRV value of the watch            |
| history | 3     | The HRV history of the watch is called back |

HistoryHrvInfoBean：

| value | value type | value description |
| ----- | ---------- | ----------------- |
| date  | String     | Time data         |
| hrv   | int        | HRV value         |

## 52.2 Whether to support HRV

Data is returned by listening.

```dart
_blePlugin.querySupportNewHrv;
```

## 52.3 Start measuring HRV

```dart
_blePlugin.startMeasureNewHrv;
```

## 52.4 Stop measuring HRV

```dart
_blePlugin.stopMeasureNewHrv;
```

## 52.5 Example Query HRV history records

Data is returned by listening.

```dart
_blePlugin.queryHistoryNewHrv
```

# 53 Stress

## 53.1 Set up Stress listener

Set up a sos listener, and the result is returned through the data stream and saved in the "event" as a sosChangeEveStem object.

```dart
_blePlugin.stressEveStm.listen(
            (StressHandlerBean event) {
            /// Do something with new state,for example:
              if (!mounted) return;
          setState(() {
            switch (event.type) {
              case StressHandlerType.support:
                _isSupport = event.isSupport;
                break;
              case StressHandlerType.change:
                _value = event.value;
                break;
              case StressHandlerType.historyChange:
                _list = event.list;
                break;
              case StressHandlerType.timingStateChange:
                _state = event.state;
                break;
              case StressHandlerType.timingChange:
                _timingStressInfo = event.timingStressInfo;
                break;
            }
          });
        },
      ),
```

Callback Description（event）：

StressHandlerBean:

| callback value   | callback value type         | callback value description                                   |
| ---------------- | --------------------------- | ------------------------------------------------------------ |
| type             | int                         | Get the corresponding return value according to type, where type is the value corresponding to StressHandlerType. |
| isSupport        | bool                        | Whether the watch supports a callback                        |
| value            | int                         | Gets the watch stress value callback                         |
| list             | List<HistoryStressInfoBean> | Gets the watch historical stress value callback              |
| state            | bool                        | Gets the watch stress status callback                        |
| timingStressInfo | TimingStressInfoBean        | Gets a callback for the watch time stress information        |

StressHandlerType:

| type              | value | value description                     |
| ----------------- | ----- | ------------------------------------- |
| support           | 1     | Whether the watch supports a callback |
| change            | 2     | Stress change callback                |
| historyChange     | 3     | The historical callback               |
| timingStateChange | 4     | A callback that timing state changes  |
| timingChange      | 5     | A callback to a change in time        |

HistoryStressInfoBean：

| value  | value type | value description |
| ------ | ---------- | ----------------- |
| date   | int        | Time data         |
| stress | int        | Stress data       |

TimingStressInfoBean:

| value  | value type     | value description |
| ------ | -------------- | ----------------- |
| date   | StressDateBean | Stress time data  |
| stress | List<int>      | Stress data list  |

StressDateBean：

| value | value type | value description |
| ----- | ---------- | ----------------- |
| value | int        | Time data         |

## 53.2 Whether stress measurement is supported

If there is a reply, pressure measurement is supported; if there is no reply, pressure measurement is not supported. The data is returned via the StressHandlerBean listener.

```dart
_blePlugin.querySupportStress;
```

## 53.3 Initial stress measurement

After the measurement. The data is returned via the StressHandlerBean listener.

```dart
_blePlugin.startMeasureStress;
```

## 53.4 Stop stress measurement

```dart
_blePlugin.stopMeasureStress;
```

## 53.5 Example Query the stress history

The watch can keep the last 10 measurements. The data is returned via the StressHandlerBean listener.

```dart
_blePlugin.queryHistoryStress;
```

## 53.6 Turn on timing stress measurement

The measurement interval is fixed at half an hour.  The data is returned via the StressHandlerBean listener.

```dart
_blePlugin.enableTimingStress;
```

## 53.7 Turn off timing stress measurement

```dart
_blePlugin.disableTimingStress;
```

## 53.8 Example Query the timing stress measurement status

The data is returned via the StressHandlerBean listener.

```dart
_blePlugin.queryTimingStressState;
```

## 53.9 Query timing stress measurement records

The watch can keep the last two days of measurement records. The data is returned via the StressHandlerBean listener.

```
blePlugin.queryTimingStress(StressDate.today)
```

Parameter Description :

StressDate:

| type      | value     | value description                          |
| --------- | --------- | ------------------------------------------ |
| today     | TODAY     | Today's timing stress measurement record   |
| yesterday | YESTERDAY | Time stress measurement recorded yesterday |

# 54 Electronic business card

## 54.1 Query the number of supported e-cards

If there is a reply, the watch supports electronic business cards. If there is no reply, the watch does not support electronic business cards. The return type for ElectronicCardCountInfoBean.

```dart
ElectronicCardCountInfoBean electronicCardCountInfo = await _blePlugin.queryElectronicCardCount;
```

Parameter Description :

ElectronicCardCountInfoBean:

| value         | value type | value description                           |
| ------------- | ---------- | ------------------------------------------- |
| count         | int        | Supports a maximum number of business cards |
| urlBytesLimit | int        | Maximum number of url bytes (utf-8 format)  |
| savedIdList   | List<int>  | A list of saved e-business card ids         |

## 54.2 Sets up electronic business cards

```dart
_blePlugin.sendElectronicCard(ElectronicCardInfoBean(
      id: 2,
      title: "百度",
      url: "https://www.baidu.com/",
));
```

Parameter Description :

ElectronicCardInfoBean：

| value | value type | value description                                            |
| ----- | ---------- | ------------------------------------------------------------ |
| id    | int        | Electronic business card ID (not more than the maximum number supported) |
| title | String     | Electronic business card title                               |
| url   | String     | Electronic business card link (watch uses this link to produce corresponding QR code) |

## 54.3 Delete e-card

```dart
_blePlugin.deleteElectronicCard(id);
```

## 54.4 Query electronic business card details

```dart
ElectronicCardInfoBean electronicCardInfo = await _blePlugin.queryElectronicCard(2);
```

## 54.5 Electronic business card sorting

Reorder electronic business cards through idList.

```
blePlugin.sendElectronicCardList([2]);
```

# 55 Reminder of Schedule

## 55.1 Set up a schedule reminder listener

Set up a schedule reminder listener, and the result is returned through the data stream and saved in the "event" as a calendarEventEveStem object.

```dart
_blePlugin.calendarEventEveStem.listen(
   (CalendarEventBean event) {
       /// Do something with new state,for example:
     if (!mounted) return;
          setState(() {
            switch(event.type) {
              case CalendarEventType.support:
                _maxNumber = event.maxNumber;
                _list = event.list;
                break;
              case CalendarEventType.details:
                _calendarEventInfo = event.calendarEventInfo;
                break;
              case CalendarEventType.stateAndTime:
                _state = event.state;
                _time = event.time;
                break;
            }
          });
   },
),
```

Callback Description（event）：

CalendarEventBean:

| callback value    | callback value type              | callback value description                                   |
| ----------------- | -------------------------------- | ------------------------------------------------------------ |
| type              | int                              | Get the corresponding return value according to type, where type is the value corresponding to CalendarEventType. |
| maxNumber         | int                              | Supported callback data, indicating the maximum number of reminders |
| list              | List<SavedCalendarEventInfoBean> | Data of whether callbacks are supported, indicating saved reminder events |
| state             | bool                             | Gets schedule reminder status and time callback data, indicating the enabled status |
| time              | int                              | Gets data about the status of the schedule reminder and the time callback, representing the reminder time |
| calendarEventInfo | CalendarEventInfoBean            | Gets the callback for the details of the schedule alert event |

CalendarEventType:

| type         | vlaue | value description                                            |
| ------------ | ----- | ------------------------------------------------------------ |
| support      | 1     | Whether the watch supports a callback                        |
| details      | 2     | Gets the callback for the watch schedule reminder            |
| stateAndTime | 3     | Gets a callback for the schedule alert enabled status and time |

SavedCalendarEventInfoBean：

| vlaue | vlaue type | value description                       |
| ----- | ---------- | --------------------------------------- |
| id    | int        | Event ID                                |
| time  | List<int>  | Reminder time (timestamp, unit: second) |

CalendarEventInfoBean：

| value       | value type | value description                       |
| ----------- | ---------- | --------------------------------------- |
| id          | int        | Event ID                                |
| title       | String     | Event title                             |
| startHour   | int        | Start time hour                         |
| startMinute | int        | Start time minute                       |
| endHour     | int        | End time hour                           |
| endMinute   | int        | End time minutes                        |
| time        | int        | Reminder time (timestamp, unit: second) |

## 55.2 Query whether schedule reminders are supported

Gets the maximum number of reminders and saved reminder events.

```dart
_blePlugin.querySupportCalendarEvent;
```

## 55.3 Set Schedule Reminders

```dart
_blePlugin.sendCalendarEvent(CalendarEventInfoBean(
      id: 1,
      title: "生日",
      startHour: 2,
      startMinute: 30,
      endHour: 4,
      endMinute: 30,
      time: 40,
   ));
```

## 55.4 Delete Schedule Reminders

The parameter is the id of the schedule alert event.

```dart
_blePlugin.deleteCalendarEvent(1);
```

## 55.5 Example Query schedule notification events

The parameter is the id of the schedule alert event.

```dart
_blePlugin.queryCalendarEvent(1)
```

## 55.6 Set the status and time of schedule reminder

minutes The unit is minutes. The value cannot be negative.

```dart
_blePlugin.sendCalendarEventReminderTime(CalendarEventReminderTimeBean(
    enable: false,
    minutes： 30
));
```

## 55.7 Example Query the schedule reminding status and reminding time

```dart
_blePlugin.queryCalendarEventReminderTime;
```

## 55.8 Clear your calendar Reminders

```dart
_blePlugin.clearCalendarEvent;
```

# 56 Vibration intensity

## 56.1 Sets vibration intensity

Adjust the vibration intensity of the watch motor. Vibration intensity is divided into low, medium and strong three grades.

```dart
_blePlugin.sendVibrationStrength(VibrationStrengthType.low);
```

Parameter Description :

VibrationStrengthType:

| type   | value | value description                 |
| ------ | ----- | --------------------------------- |
| low    | 1     | The vibration intensity is low    |
| medium | 2     | The vibration intensity is medium |
| strong | 3     | The vibration intensity is strong |

## 56.2 Query vibration intensity

If there is a reply, the function is supported. If there is no reply, the watch does not support this function.

```dart
VibrationStrength value = await _blePlugin.queryVibrationStrength;
```

Parameter Description :

VibrationStrength:

| value | value type | value description         |
| ----- | ---------- | ------------------------- |
| value | int        | Vibration intensity value |
