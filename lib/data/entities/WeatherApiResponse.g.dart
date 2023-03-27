// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WeatherApiResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherApiResponse _$WeatherApiResponseFromJson(Map<String, dynamic> json) =>
    WeatherApiResponse(
      id: json['id'] as int?,
      timezone: json['timezone'] as num?,
      dt: json['dt'] as int?,
      cod: json['cod'] as int?,
      name: json['name'] as String?,
      main: json['main'] == null
          ? null
          : WeatherTemp.fromJson(json['main'] as Map<String, dynamic>),
      wind: json['wind'] == null
          ? null
          : WeatherWind.fromJson(json['wind'] as Map<String, dynamic>),
    )..weather = (json['weather'] as List<dynamic>?)
        ?.map((e) => WeatherDesc.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$WeatherApiResponseToJson(WeatherApiResponse instance) =>
    <String, dynamic>{
      'timezone': instance.timezone,
      'id': instance.id,
      'name': instance.name,
      'cod': instance.cod,
      'dt': instance.dt,
      'weather': instance.weather,
      'main': instance.main,
      'wind': instance.wind,
    };
