import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/common/ColorHelper.dart';
import 'package:weather_app/common/TextStyleHelper.dart';

import '../common/Constants.dart';
import '../data/entities/WeatherApiResponse.dart';

class WeatherTodayHour extends StatelessWidget {
  List<WeatherApiResponse> list;

  WeatherTodayHour(this.list);

  @override
  Widget build(BuildContext context) {
    var gridList = list.map((e) {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch((e.dt ?? 0) * NUM_1000);
      String time = DateFormat.Hm().format(date);
      return Container(
        padding: EdgeInsets.all(10),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          color: ColorHelper.white,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '${e.main?.temp_min}\u2103/${e.main?.temp_max}\u2103',
                  style: TextStyleHelper.captionSmall2,
                ),
                CachedNetworkImage(
                  imageUrl: "$IMAGE_URL${e.weather?.first.icon}@2x.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.fill,
                ),
                Text(time, style: TextStyleHelper.captionSmall)
              ],
            ),
          ),
        ),
      );
    });
    return Column(
      children: [
        Text(
            "TODAY",
          style: TextStyleHelper.description,
        ),
        LayoutGrid(
          gridFit: GridFit.loose,
          columnSizes: [1.fr, 1.fr],
          rowSizes: List.generate(gridList.length, (index) => auto),
          children: gridList.toList(),
        )
      ],
    );
  }
}
