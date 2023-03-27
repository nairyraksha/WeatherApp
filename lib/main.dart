import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/common/ThemeHelper.dart';
import 'package:weather_app/di/DependencyInjection.dart';
import 'package:weather_app/view/WeatherMainScreen.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: ThemeHelper.appBarTheme
      ),
      home: WeatherMainScreen(),
    );
  }
}