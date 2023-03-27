import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_app/view/WeatherTodayHour.dart';
import '../common/Constants.dart';
import '../di/DependencyInjection.dart';
import '../viewmodel/WeatherViewModel.dart';
import 'WeatherCard.dart';

class WeatherMainScreen extends StatelessWidget {
  WeatherViewModel _weatherVM = getIt<WeatherViewModel>();

  @override
  Widget build(BuildContext context) {
    internetCheck(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/weather.jpeg",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          ListView(
            children: [
              ValueListenableBuilder(
                  valueListenable: _weatherVM.weatherInfo,
                  builder: (context, value, child) {
                    return WeatherCard(
                      weatherVM: _weatherVM,
                      weatherInfo: value,
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: _weatherVM.forecastInfo,
                  builder: (context, value, child) {
                    return WeatherTodayHour(
                      value
                    );
                  })
            ],
          )
        ],
      ),
    );
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    _weatherVM.fetch();
    _weatherVM.fetchForecast();
    return true;
  }

  Future<bool> internetCheck(BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      await _handleLocationPermission(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('No internet. Turn on Internet to access weather info')));
    }
    return result;
  }

  Widget getIcon() {
    if (_weatherVM.iconUrl != null) {
      return CachedNetworkImage(
        imageUrl: _weatherVM.iconUrl ?? EMPTY_STRING,
        placeholder: (context, url) {
          return Image.asset(
            "assets/images/noPermission.png",
            height: 200,
            width: 200,
            fit: BoxFit.fill,
          );
        },
        height: 100,
        width: 100,
        fit: BoxFit.fill,
      );
    } else {
      return Image.asset(
        "assets/images/noPermission.png",
        height: 100,
        width: 100,
        fit: BoxFit.fill,
      );
    }
  }
}
