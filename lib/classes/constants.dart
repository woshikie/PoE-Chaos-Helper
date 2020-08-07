import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String TITLE = Constants.TITLE;

class Constants {
  static const String TITLE = 'PoE Chaos Helper';
  static SharedPreferences _gPREFS;
  static Future<SharedPreferences> get gPREFS async {
    if (_gPREFS == null) _gPREFS = await SharedPreferences.getInstance();
    return _gPREFS;
  }

  static final Random _random = Random();
  static Random get random => _random;
  static Color get randomColor {
    return Color.fromARGB(255, _random.nextInt(256), _random.nextInt(256), _random.nextInt(256));
  }

  static List<Color> get randomColors {
    return [
      randomColor,
      randomColor,
      randomColor,
    ];
  }

  static Widget getTemplateWaiting(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Loading... Please Wait',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 64.h,
          ),
          Container(
            height: 500.nsp,
            width: 500.nsp,
            child: LoadingIndicator(
              indicatorType: Indicator.values[random.nextInt(Indicator.values.length)],
              color: randomColor,
              colors: randomColors,
            ),
          ),
        ],
      ),
    );
  }
}
