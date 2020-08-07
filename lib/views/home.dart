import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poe_chaos_helper/classes/api/poe_api.dart';
import 'package:poe_chaos_helper/classes/collection.dart';
import 'package:poe_chaos_helper/classes/collection_piece.dart';
import 'package:poe_chaos_helper/classes/constants.dart';
import 'package:poe_chaos_helper/components/collection_piece_counter.dart';
import 'package:poe_chaos_helper/views/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final Random _random = Constants.random;
  static const int REFRESH_DELAY = 1000;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Collection collection;
  Timer _timer;
  SharedPreferences _prefs;
  bool _doFetch = false;
  bool get doFetch => _doFetch;
  set doFetch(bool newVal) {
    _doFetch = newVal;
    if (_doFetch && _timer == null) {
      _timer = Timer(Duration.zero, fetchAPI);
    }
  }

  Future<void> fetchAPI() async {
    if (!doFetch) {
      _timer = null;
      return;
    }
    if (_prefs == null) _prefs = await Constants.gPREFS;
    final List<String> selectedTabsIndex = _prefs.getStringList(Settings.KEY_TABS_INDEX);
    final String selectedLeague = _prefs.getString(Settings.KEY_SELECTED_LEAGUE);
    final String selectedRealm = _prefs.getString(Settings.KEY_REALM);
    final String accountName = _prefs.getString(Settings.KEY_ACCOUNT_NAME);
    final String poesessid = _prefs.getString(Settings.KEY_POESESSID);
    const List<String> patterns = [
      '/Armours/Helmets/',
      '/Amulets/',
      '/Armours/BodyArmours/',
      '/Belts/',
      '/Armours/Boots/',
      '/Armours/Gloves/',
      '/Rings/',
      '/Weapons/OneHandWeapons/',
      '/Weapons/TwoHandWeapons/',
    ];
    PoeAPI.setPoeSessionID(poesessid);
    List<Future<List<String>>> futures = [];
    for (String tabIndex in selectedTabsIndex) {
      futures.add(PoeAPI.getStashItems(
        league: selectedLeague,
        realm: selectedRealm,
        accountName: accountName,
        tabIndex: tabIndex,
      ));
    }
    List<List<String>> resultList = await Future.wait(futures);
    List<String> results = resultList.expand((element) => element).toList();
    setState(() {
      for (int i = 0; i < patterns.length; i++) {
        //collection.pieces[i].count = min(collection.pieces[i].count, results.where((element) => element.contains(patterns[i])).toList().length);
        collection.pieces[i].count = results.where((element) => element.contains(patterns[i])).toList().length;
      }
    });

    _timer = Timer(Duration(milliseconds: Home.REFRESH_DELAY), fetchAPI);
  }

  void saveCollection() {
    Collection.toSharedPrefs(collection);
  }

  List<Widget> get _children {
    List<Widget> ret = [];
    for (CollectionPiece piece in collection.pieces) {
      ret.add(
        CollectionPieceCounter(
          count: piece.count,
          name: piece.name,
          hasSet: piece.hasSet,
          onChange: (newCount) {
            print('${piece.name} onChange($newCount)');
            setState(() {
              piece.count = newCount;
              saveCollection();
            });
          },
        ),
      );
    }
    return ret;
  }

  String get setText {
    return '${collection.setCount} Set${collection.setCount > 1 ? 's' : ''}';
  }

  /// Clears all count
  void clearAll() async {
    setState(() {
      collection.clearAll();
      collection = null;
    });
    collection = await Collection.fromSharedPrefs();
  }

  void removeOneSet() {
    setState(() {
      collection.removeSet();
      saveCollection();
    });
  }

  Widget get mainBodyChild {
    if (collection != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RaisedButton(
                color: Colors.red,
                child: Text('Clear all'),
                onPressed: clearAll,
              ),
              Text(
                setText,
                style: Theme.of(context).textTheme.headline5,
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('-1 Set'),
                onPressed: removeOneSet,
              ),
            ],
          ),
          ..._children,
        ],
      );
    }
    return Constants.getTemplateWaiting(context);
  }

  Future<void> checkFetchAPI() async {
    bool doFetch = (await Constants.gPREFS).getBool(Settings.KEY_FETCH_API) ?? false;
    if (this.doFetch == doFetch) return;
    setState(() {
      this.doFetch = doFetch;
    });
  }

  void initSettings() {
    checkFetchAPI();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Collection.fromSharedPrefs().then((value) {
      setState(() {
        collection = value;
      });
    });
    initSettings();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: false);
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: (3 * ScreenUtil().scaleWidth / ScreenUtil.textScaleFactor),
            ),
        iconTheme: Theme.of(context).iconTheme.copyWith(
              size: 32.nsp,
            ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(TITLE),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Settings())).then((value) {
                  initSettings();
                });
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 64.w),
              child: mainBodyChild,
            ),
          ),
        ),
      ),
    );
  }
}
