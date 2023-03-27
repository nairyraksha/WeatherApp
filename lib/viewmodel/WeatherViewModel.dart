import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/data/entities/WeatherApiResponse.dart';
import 'package:weather_app/data/repository/ApiResponse.dart';
import 'package:weather_app/data/repository/WeatherRepoImpl.dart';
import 'package:weather_app/di/DependencyInjection.dart';

import '../common/Constants.dart';

class WeatherViewModel {
  final WeatherRepoImpl _weatherRepo = getIt<WeatherRepoImpl>();

  String? iconUrl;

  var weatherInfo = ValueNotifier<WeatherApiResponse>(WeatherApiResponse());
  String weatherErrorMsg = EMPTY_STRING;

  fetch() async {
    weatherInfo.value = WeatherApiResponse();
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    var response = await _weatherRepo.fetchWeatherCondition(
      position.latitude.toString(),
      position.longitude.toString()
    );
    if (response is ApiResponseSuccess<WeatherApiResponse>) {
      WeatherApiResponse info = response.payload;
      weatherInfo.value = info;
      iconUrl = "$IMAGE_URL${info.weather?.first.icon}@2x.png";
    } else if (response is ApiFailure<WeatherApiResponse>) {
      weatherErrorMsg = response.error.toString();
    }
  }

  var forecastInfo = ValueNotifier<List<WeatherApiResponse>>([WeatherApiResponse()]);
  String forecastErrorMsg = EMPTY_STRING;

  fetchForecast() async {
    forecastInfo.value = [WeatherApiResponse()];
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    var response = await _weatherRepo.fetchForecast(
        position.latitude.toString(),
        position.longitude.toString()
    );
    if (response is ApiResponseSuccess<List<WeatherApiResponse>>) {
      List<WeatherApiResponse> info = response.payload;
      DateTime now = DateTime.now();
      DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      forecastInfo.value = info.where((element) {
        var date = DateTime.fromMillisecondsSinceEpoch((element.dt ?? 0) * NUM_1000);
        return date.isBefore(endOfDay);
      }).toList();
      print("finalListFOrToday - ${forecastInfo.value.length}");
    } else if (response is ApiFailure<List<WeatherApiResponse>>) {
      forecastErrorMsg = response.error.toString();
    }
  }
}