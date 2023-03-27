import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/common/ColorHelper.dart';
import 'package:weather_app/common/TextStyleHelper.dart';

import '../common/Constants.dart';
import '../data/entities/WeatherApiResponse.dart';
import '../viewmodel/WeatherViewModel.dart';

class WeatherCard extends StatelessWidget {
  WeatherApiResponse? weatherInfo;
  WeatherViewModel? weatherVM;

  WeatherCard({required this.weatherInfo, required this.weatherVM});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: ColorHelper.white,
                ),
                Text(
                  weatherInfo?.name ?? EMPTY_STRING,
                  style: TextStyleHelper.displaySubTitle,
                )
              ],
            ),
            InkWell(
              child: Icon(
                Icons.sync,
                color: ColorHelper.black,
                weight: 100,
                size: 50,
              ),
              onTap: () {
                internetCheck(context);
              },
            ),
            getIcon(),
            Text(
              '${weatherInfo?.main?.temp ?? EMPTY_STRING}\u2103',
              style: TextStyleHelper.displayTitle,
            ),
            Text(
              '${weatherInfo?.main?.temp_min ?? EMPTY_STRING}\u2103 '
                  '/ ${weatherInfo?.main?.temp_max ?? EMPTY_STRING}\u2103 ',
              style: TextStyleHelper.captionLarge,
            ),
            Text(
                  'Feels Like ${weatherInfo?.main?.feels_like}\u2103',
              style: TextStyleHelper.captionLarge,
            ),
            Text(
              getWeatherDesc(),
              style: TextStyleHelper.captionLarge
                  .copyWith(fontWeight: FontWeight.w400),
            ),
            Text(
              getDate(),
              style: TextStyleHelper.captionSmall
                  .copyWith(fontWeight: FontWeight.w400),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Divider(
                thickness: 2,
              ),
            ),
            Container(
              color: ColorHelper.white,
              padding: EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  humidityWindInfo(
                    'assets/images/wind.png',
                    '${weatherInfo?.wind?.speed} km/h',
                    "Wind"
                  ),
                  humidityWindInfo(
                      'assets/images/humidity.png',
                      '${weatherInfo?.main?.humidity}',
                      "Humidity"
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getIcon() {
    if (weatherVM?.iconUrl != null) {
      return CachedNetworkImage(
        imageUrl: weatherVM?.iconUrl ?? EMPTY_STRING,
        placeholder: (context, url) {
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            child: Image.asset(
              "assets/images/dropsFading.gif",
              height: 50,
              width: 50,
            ),
          );
        },
        height: 200,
        width: 200,
        fit: BoxFit.fill,
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        child: Image.asset(
          "assets/images/noPermission.png",
          height: 50,
          width: 50,
          fit: BoxFit.fill,
        ),
      );
    }
  }

  String getDate() {
    var date = DateTime.fromMillisecondsSinceEpoch((weatherInfo?.dt ?? 0) * NUM_1000);
    return DateFormat.yMd().add_jm().format(date);
  }

  String getWeatherDesc() {
    String desc = EMPTY_STRING;
    weatherInfo?.weather?.forEach((element) {
      desc = "$desc ${element.description}";
    });
    return desc;
  }

  Widget humidityWindInfo(String image, String info, String type) {
    return Column(
      children: [
        Image.asset(
          image,
          width: 25,
          height: 25,
          fit: BoxFit.fill,
        ),
        Text(
          info,
          style: TextStyleHelper.captionSmall
              .copyWith(fontWeight: FontWeight.w400),
        ),
        Text(
          type,
          style: TextStyleHelper.captionSmall
              .copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  internetCheck(BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      weatherVM?.fetch();
      weatherVM?.fetchForecast();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
          Text('No internet. Turn on Internet to access weather info')));
    }
  }
}
