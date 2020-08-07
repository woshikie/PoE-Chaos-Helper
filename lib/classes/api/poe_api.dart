import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:poe_chaos_helper/classes/api/poe_compact_league.dart';
import 'package:poe_chaos_helper/classes/api/poe_compact_stash.dart';
import 'package:poe_chaos_helper/classes/constants.dart';

class PoeAPI {
  static const ENDPOINT = 'https://www.pathofexile.com';
  static const SSID_PREF_KEY = 'POESESSID';
  static http.Client _client;
  static http.Client get client {
    if (_client == null) _client = http.Client();
    return _client;
  }

  static Map<String, String> _cookieList = {};
  static String get _cookieStr {
    String str = '';
    if (_poeSessionID != null) {
      str += 'POESESSID=$_poeSessionID';
    }
    _cookieList.forEach((key, value) {
      str += '$key=$value;';
    });
    return str;
  }

  static Map<String, String> get _headers {
    Map<String, String> ret = {};
    ret['Accept'] = '*/*';
    ret['Cookie'] = _cookieStr;
    return ret;
  }

  static String _poeSessionID;
  static Future<String> get poeSessionID async {
    if (_poeSessionID == null) {
      _poeSessionID = (await Constants.gPREFS).getString(SSID_PREF_KEY);
    }
    return _poeSessionID;
  }

  static Future<bool> setPoeSessionID(String sessionID) async {
    if (_poeSessionID != sessionID) {
      _poeSessionID = sessionID;
      return await (await Constants.gPREFS).setString(SSID_PREF_KEY, sessionID);
    }
    return true;
  }

  static _argsToStr({@required Map<String, String> args}) {
    String str = '?';
    args.forEach((key, value) {
      str += '$key${value == null ? '' : '='}${value ?? ''}&';
    });
    return str.substring(0, str.length - 1);
  }

  static Future<List<PoeCompactLeague>> getLeagues() async {
    const Map<String, String> args = {
      'type': 'main',
      'realm': 'pc',
      'compact': '1',
    };
    final url = ENDPOINT + '/api/leagues' + _argsToStr(args: args);
    String responseTxt = (await client.get(url, headers: _headers)).body;
    List<PoeCompactLeague> objList = (json.decode(responseTxt) as List).map((i) => PoeCompactLeague.fromJson(i)).toList();
    return objList;
  }

  static Future<List<PoeCompactStash>> getStashTabs({
    String league,
    String realm,
    String accountName,
  }) async {
    final Map<String, String> args = {
      'league': league,
      'realm': realm,
      'accountName': accountName,
      'tabs': '1',
    };
    final url = ENDPOINT + '/character-window/get-stash-items' + _argsToStr(args: args);

    try {
      var response = (await client.get(url, headers: _headers));
      String responseTxt = response.body;
      List<PoeCompactStash> objList = (json.decode(responseTxt)['tabs'] as List).map((i) => PoeCompactStash.fromJson(i)).toList();
      return objList;
    } catch (e) {
      return null;
    }
  }
}
