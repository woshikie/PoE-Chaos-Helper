import 'package:shared_preferences/shared_preferences.dart';

const String TITLE = Constants.TITLE;

class Constants {
  static const String TITLE = 'PoE Chaos Helper';
  static SharedPreferences _gPREFS;
  static Future<SharedPreferences> get gPREFS async {
    if (_gPREFS == null) _gPREFS = await SharedPreferences.getInstance();
    return _gPREFS;
  }
}
