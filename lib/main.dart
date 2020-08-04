import 'package:flutter/material.dart';
import 'package:poe_chaos_helper/constants.dart';
import 'package:poe_chaos_helper/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  gPREFS = await SharedPreferences.getInstance();
  runApp(POEChaosHelper());
}

class POEChaosHelper extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
