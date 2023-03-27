import '../entities/WeatherApiResponse.dart';
import 'ApiResponse.dart';

abstract class WeatherRepo {
  Future<ApiResponse<WeatherApiResponse>> fetchWeatherCondition(
      String latitude,
      String longitude
  );

  Future<ApiResponse<List<WeatherApiResponse>>> fetchForecast(
      String latitude,
      String longitude
  );
}