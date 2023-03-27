// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WeatherDesc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDesc _$WeatherDescFromJson(Map<String, dynamic> json) => WeatherDesc(
      id: json['id'] as int,
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$WeatherDescToJson(WeatherDesc instance) =>
    <String, dynamic>{
      'id': instance.id,
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };
