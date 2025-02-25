import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class WeatherPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const WeatherPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<WeatherPage> createState() {
    return _WeatherPage();
  }
}

class _WeatherPage extends State<WeatherPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Weather"),
            ),
            body: Center(
              child: ListView(
                children: [
                  ElevatedButton(
                      child: const Text('sendTodayWeather()'),
                      onPressed: () => widget.blePlugin.sendTodayWeather(
                          TodayWeatherBean(
                              city: "changsha",
                              lunar: "晴",
                              festival: "儿童节",
                              pm25: 111,
                              temp: 20,
                              weatherId: 5))),
                  ElevatedButton(
                      child: const Text('sendFutureWeather()'),
                      onPressed: () => widget.blePlugin.sendFutureWeather(
                              getFutureWeathers()
                          )),
                ],
              ),
            )
        )
    );
  }

  FutureWeatherListBean getFutureWeathers() {
    FutureWeatherBean futureWeatherBean1 = FutureWeatherBean(
        weatherId: 5,
        lowTemperature: 10,
        highTemperature: 30);
    FutureWeatherBean futureWeatherBean2 = FutureWeatherBean(
        weatherId: 6,
        lowTemperature: 11,
        highTemperature: 40);

    List<FutureWeatherBean> futureList = [];
    futureList.add(futureWeatherBean1);
    futureList.add(futureWeatherBean2);

    return FutureWeatherListBean(future: futureList);
  }
}
