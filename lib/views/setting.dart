import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poe_chaos_helper/classes/api/poe_api.dart';
import 'package:poe_chaos_helper/classes/api/poe_compact_league.dart';
import 'package:poe_chaos_helper/classes/api/poe_compact_stash.dart';
import 'package:poe_chaos_helper/classes/constants.dart';
import 'package:poe_chaos_helper/components/option_row.dart';
import 'package:poe_chaos_helper/components/option_row_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  static const String KEY_FETCH_API = 'isFetchAPI';
  static const String KEY_SELECTED_LEAGUE = 'selectedLeague';
  static const String KEY_POESESSID = PoeAPI.SSID_PREF_KEY;
  static const String KEY_ACCOUNT_NAME = 'accountName';
  static const String KEY_REALM = 'selectedRealm';
  static const String KEY_TABS = 'selectedTabs';
  static const String KEY_TABS_INDEX = 'selectedTabsIndex';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static String get keyFetchAPI => Settings.KEY_FETCH_API;
  static String get keySelectedLeague => Settings.KEY_SELECTED_LEAGUE;
  static String get keyPoesessid => Settings.KEY_POESESSID;
  static String get keyAccountName => Settings.KEY_ACCOUNT_NAME;
  static String get keyRealm => Settings.KEY_REALM;
  static String get keyTabs => Settings.KEY_TABS;
  static String get keyTabsIndex => Settings.KEY_TABS_INDEX;

  static const List<String> _realms = ['pc', 'xbox', 'sony'];
  List<PoeCompactLeague> leagues;
  List<PoeCompactStash> stashes;
  List<String> selectedTabs = [];
  List<int> selectedTabsIndex = [];

  TextEditingController _poesessidController = TextEditingController();
  String _poesessid;
  String get poesessid => _poesessid;
  set poesessid(String newVal) {
    if (newVal == _poesessid) return;
    setState(() {
      _poesessid = newVal;
    });
    PoeAPI.setPoeSessionID(newVal);
  }

  String _accountName;
  String get accountName => _accountName;
  set accountName(String newVal) {
    if (newVal == _accountName) return;
    setState(() {
      _accountName = newVal;
    });
    Constants.gPREFS.then((value) {
      value.setString(keyAccountName, newVal);
    });
  }

  PoeCompactLeague _selectedLeague;
  PoeCompactLeague get selectedLeague => _selectedLeague;
  set selectedLeague(PoeCompactLeague newVal) {
    if (newVal == _selectedLeague) return;
    setState(() {
      _selectedLeague = newVal;
    });
    (Constants.gPREFS).then((pref) {
      pref.setString(keySelectedLeague, newVal.id);
    });
  }

  String _selectedRealm = 'pc';
  String get selectedRealm => _selectedRealm;
  set selectedRealm(String newVal) {
    if (_selectedRealm == newVal) return;
    setState(() {
      _selectedRealm = newVal;
    });
    (Constants.gPREFS).then((pref) {
      pref.setString(keyRealm, newVal);
    });
  }

  bool _isFetchAPI = false;
  bool get isFetchAPI => _isFetchAPI;
  set isFetchAPI(bool newVal) {
    setState(() {
      _isFetchAPI = newVal;
    });
    (Constants.gPREFS).then((pref) {
      pref.setBool(keyFetchAPI, newVal);
    });
    if (newVal) initOptions();
  }

  bool get _optionsLoaded {
    if (!isFetchAPI) return true;
    return (leagues != null && selectedLeague != null);
  }

  bool get _isLoading {
    return !_optionsLoaded;
  }

  static TextStyle _settingTextStyle;
  TextStyle get settingTextStyle {
    if (_settingTextStyle == null) {
      _settingTextStyle = Theme.of(context).textTheme.bodyText1.copyWith(
            fontSize: 52.nsp,
          );
    }
    return _settingTextStyle;
  }

  Widget get mainBody {
    if (_isLoading) return Constants.getTemplateWaiting(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 64.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OptionRow(
            title: 'Fetch from API',
            control: Switch(
                value: isFetchAPI,
                onChanged: (bool newVal) {
                  isFetchAPI = newVal;
                }),
          ),
          ...options,
        ],
      ),
    );
  }

  Widget get _templateTabs {
    return Text('Loading... Please ensure above settings are correct', style: settingTextStyle);
  }

  List<Widget> get tabsOptions {
    return [
      Text('Tabs', style: settingTextStyle),
      (stashes == null)
          ? _templateTabs
          : Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: stashes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: stashes[index].color,
                    child: CheckboxListTile(
                      value: (selectedTabs.contains(stashes[index].id)),
                      onChanged: (isChecked) {
                        if (isChecked) {
                          if (!selectedTabs.contains(stashes[index].id)) {
                            selectedTabs.add(stashes[index].id);
                            selectedTabsIndex.add(stashes[index].index);
                          }
                        } else {
                          selectedTabs.removeWhere((element) => (element == stashes[index].id));
                          selectedTabsIndex.removeWhere((element) => (element == stashes[index].index));
                        }
                        onStashTabsUpdate();
                      },
                      title: Text(
                        stashes[index].n,
                        style: settingTextStyle.copyWith(color: Colors.yellow),
                      ),
                    ),
                  );
                },
              ),
            ),
    ];
  }

  List<Widget> get options {
    if (isFetchAPI == false) return [];
    return [
      OptionRow(
        title: 'League',
        control: DropdownButton<PoeCompactLeague>(
          value: selectedLeague,
          items: leagues
              .map((e) => DropdownMenuItem<PoeCompactLeague>(
                    child: Text(e.id),
                    value: e,
                  ))
              .toList(),
          onChanged: (PoeCompactLeague selected) {
            setState(() {
              selectedLeague = selected;
              print(selected);
            });
          },
        ),
      ),
      OptionRow(
        title: 'Realm',
        control: DropdownButton<String>(
          value: selectedRealm,
          items: _realms
              .map(
                (e) => DropdownMenuItem<String>(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          onChanged: (String selected) {
            selectedRealm = selected;
          },
        ),
      ),
      OptionRowTextFormField(
        title: 'Account Name',
        initialValue: accountName,
        onSave: (String newVal) {
          accountName = newVal;
        },
      ),
      OptionRowTextFormField(
        title: 'POESESSID',
        controller: _poesessidController,
        onSave: (String newVal) {
          poesessid = newVal;
        },
        action: IconButton(
          icon: Icon(Icons.settings_overscan),
          onPressed: () async {
            try {
              ScanResult result = await BarcodeScanner.scan();
              poesessid = result.rawContent;
              _poesessidController.text = result.rawContent;
            } catch (e) {
              //TODO: Request for permission again?
            }
          },
        ),
      ),
      ...tabsOptions,
    ];
  }

  Future<void> initOptions() async {
    await initLeagues();
    await Future.wait([
      initSelectedLeague(),
      initSelectedRealm(),
      initAccountName(),
      initPOESESSID(),
    ]);
    await initStashTabs();
    await initSelectedStashTabs();
    await initSelectedStashTabsIndex();
    setState(() {});
  }

  Future<void> initLeagues() async {
    leagues = await PoeAPI.getLeagues();
    setState(() {});
  }

  Future<void> initFetchFromAPI() async {
    isFetchAPI = (await Constants.gPREFS).getBool(keyFetchAPI) ?? false;
  }

  Future<void> initSelectedLeague() async {
    String selectedLeagueID = (await Constants.gPREFS).getString(keySelectedLeague);
    int needle = leagues.indexWhere((element) => element.id == selectedLeagueID);
    if (needle == -1)
      selectedLeague = leagues[0];
    else
      selectedLeague = leagues[needle];
  }

  Future<void> initSelectedRealm() async {
    selectedRealm = (await Constants.gPREFS).getString(keyRealm);
  }

  Future<void> initAccountName() async {
    accountName = (await Constants.gPREFS).getString(keyAccountName);
  }

  Future<void> initPOESESSID() async {
    poesessid = (await Constants.gPREFS).getString(keyPoesessid);
    _poesessidController.text = poesessid;
  }

  Future<void> initStashTabs() async {
    final required = [selectedLeague, selectedRealm, accountName];
    if (required.any((element) => (element == null))) return;
    stashes = await PoeAPI.getStashTabs(
      league: selectedLeague.id,
      realm: selectedRealm,
      accountName: accountName,
    );
  }

  Future<void> initSelectedStashTabs() async {
    selectedTabs = (await Constants.gPREFS).getStringList(keyTabs);
  }

  Future<void> initSelectedStashTabsIndex() async {
    selectedTabsIndex = (await Constants.gPREFS).getStringList(keyTabsIndex).map((e) => int.parse(e)).toList();
  }

  Future<void> onStashTabsUpdate() async {
    setState(() {});
    SharedPreferences prefs = await Constants.gPREFS;
    prefs.setStringList(keyTabs, selectedTabs);
    prefs.setStringList(keyTabsIndex, selectedTabsIndex.map((e) => e.toString()).toList());
  }

  @override
  void initState() {
    super.initState();
    initFetchFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    OptionRow.defaultTextStyle = settingTextStyle;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: mainBody,
    );
  }
}
