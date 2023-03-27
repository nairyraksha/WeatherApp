import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/data/entities/WeatherApiResponse.dart';
import 'package:weather_app/di/DependencyInjection.dart';
import 'package:weather_app/data/repository/MyDio.dart';

import 'ApiResponse.dart';
import 'WeatherRepo.dart';

class WeatherRepoImpl implements WeatherRepo {
  final MyDio _dio = getIt<MyDio>();

  @override
  Future<ApiResponse<WeatherApiResponse>> fetchWeatherCondition(
      String latitude,
      String longitude
  ) async {
    Map<String, String> queryParams = {
      "units": "metric",
      "lat": latitude,
      "lon": longitude
    };

    return safeApiCall(() async {
      String path = '/weather';
      var response = await _dio.getDio().get(path, queryParameters: queryParams);
      WeatherApiResponse weatherInfo = WeatherApiResponse.fromJson(response.data);
      return ApiResponseSuccess(weatherInfo);
    });
  }

  @override
  Future<ApiResponse<List<WeatherApiResponse>>> fetchForecast(
      String latitude,
      String longitude
  ) async {
    Map<String, String> queryParams = {
      "units": "metric",
      "lat": latitude,
      "lon": longitude
    };
    return safeApiCall(() async {
      String path = '/forecast';
      var response = await _dio.getDio().get(path, queryParameters: queryParams);
      ApiResponse<List<WeatherApiResponse>> parseResponse(dynamic data) {
        var parsed = data['list'].cast<Map<String, dynamic>>();
        List<WeatherApiResponse> response = parsed.map<WeatherApiResponse>((element) {
          WeatherApiResponse info = WeatherApiResponse.fromJson(element);
          return info;
        }).toList();
        return ApiResponseSuccess(response);
      }
      return compute(parseResponse, response.data);
    });
  }

  Future<ApiResponse<T>> safeApiCall<T>(
      Future<ApiResponse<T>> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioError catch (dioErr) {
      switch (dioErr.type) {
        case DioErrorType.connectionTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          return ApiFailure(ApiException(ApiExceptionType.timeOutException));
        case DioErrorType.badCertificate:
          return ApiFailure(ApiException(ApiExceptionType.authException));
        case DioErrorType.badResponse:
          return ApiFailure(ApiException(ApiExceptionType.badResponse));
        case DioErrorType.cancel:
        case DioErrorType.connectionError:
        case DioErrorType.unknown:
          return ApiFailure(ApiException(ApiExceptionType.unKnown));
      }
    } catch (exc) {
      return ApiFailure(ApiException(ApiExceptionType.unKnown));
    }
  }
}