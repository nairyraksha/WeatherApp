import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'WeatherWind.g.dart';

@JsonSerializable()
class WeatherWind extends Equatable {
  double? speed;
  double? deg;
  double? gust;

  WeatherWind({this.speed, this.deg, this.gust});

  @override
  List<Object?> get props => [speed];

  factory WeatherWind.fromJson(Map<String, dynamic> json) => _$WeatherWindFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherWindToJson(this);
}