import 'dart:io';

import 'package:dio/dio.dart';

class MyDio {
  static const queryParams = {"appid": "0aef12644b8419e9f16e511557a19756"};

  Dio getDio() {
    return Dio(BaseOptions(
        baseUrl: 'https://api.openweathermap.org/data/2.5',
        connectTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        contentType: Headers.jsonContentType,
        headers: {
          HttpHeaders.authorizationHeader: "api token",
          "x-app-info": "network-example"
        },
        validateStatus: (status) =>
            status != null && status >= 200 && status <= 300,
        queryParameters: queryParams))
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true))
      ..transformer = BackgroundTransformer();
  }
}
