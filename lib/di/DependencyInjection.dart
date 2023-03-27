import 'package:get_it/get_it.dart';
import 'package:weather_app/data/repository/MyDio.dart';
import 'package:weather_app/data/repository/WeatherRepoImpl.dart';
import 'package:weather_app/viewmodel/WeatherViewModel.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<MyDio>(() => MyDio());
  getIt.registerLazySingleton<WeatherViewModel>(() => WeatherViewModel());
  getIt.registerLazySingleton(() => WeatherRepoImpl());
}
