import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'WeatherTemp.g.dart';

@JsonSerializable()
class WeatherTemp extends Equatable {
  double? temp;
  double? temp_min;
  double? temp_max;
  double? feels_like;
  int? humidity;

  WeatherTemp({this.temp, this.temp_max, this.temp_min, this.feels_like, this.humidity});

  @override
  List<Object?> get props => [temp, temp_min, temp_max];

  factory WeatherTemp.fromJson(Map<String, dynamic> json) => _$WeatherTempFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherTempToJson(this);
}