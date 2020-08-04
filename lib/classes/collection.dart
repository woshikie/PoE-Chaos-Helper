import 'dart:convert';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:poe_chaos_helper/classes/collection_piece.dart';
import 'package:poe_chaos_helper/constants.dart';

part 'collection.g.dart';

@JsonSerializable(explicitToJson: true)
class Collection {
  static const String _PREFS_KEY = 'COLLECTION';
  final List<CollectionPiece> pieces;
  static final _template = [
    CollectionPiece(name: 'Helmet'),
    CollectionPiece(name: 'Amulet'),
    CollectionPiece(name: 'Body Armour'),
    CollectionPiece(name: 'Belt'),
    CollectionPiece(name: 'Shoes'),
    CollectionPiece(name: 'Gloves'),
    CollectionPiece(name: 'Rings', setCount: 2),
    CollectionPiece(name: 'Weapon (1h)', setCount: 2),
    CollectionPiece(name: 'Weapon (2h)'),
  ];
  Collection({List<CollectionPiece> pieces}) : pieces = pieces ?? _template;
  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  static Future<Collection> fromSharedPrefs() async {
    String jsonStr = (await Constants.gPREFS).getString(_PREFS_KEY);
    if (jsonStr != null) return Collection.fromJson(json.decode(jsonStr));
    return Collection();
  }

  static Future<void> toSharedPrefs(Collection collection) async {
    String jsonStr = json.encode(collection.toJson());
    (await Constants.gPREFS).setString(_PREFS_KEY, jsonStr);
  }

  /// Returns weapon set count
  int get _weaponSetCount {
    return pieces[7].setCount + pieces[8].setCount;
  }

  /// Returns set count
  int get setCount {
    return [
      pieces[0].setCount,
      pieces[1].setCount,
      pieces[2].setCount,
      pieces[3].setCount,
      pieces[4].setCount,
      pieces[5].setCount,
      pieces[6].setCount,
      _weaponSetCount,
    ].reduce(min);
  }

  /// Removes [times] set(s) from collection
  void removeSet({int times = 1}) {
    if (setCount < times) return;
    for (int i = 0; i < 7; i++) pieces[i].removeSet(times: times);
    _removeWeaponSet(times: times);
  }

  /// Removes [times] weapon set(s), assuming 2x1h is preferred
  void _removeWeaponSet({int times = 1}) {
    if (_weaponSetCount < times) return;
    int weapon1hSet = pieces[7].setCount;
    int weapon2hSet = pieces[8].setCount;
    if (weapon1hSet >= times)
      pieces[7].removeSet(times: times);
    else {
      pieces[7].removeSet(times: pieces[7].setCount);
      pieces[8].removeSet(times: times - pieces[7].setCount);
    }
  }

  void clearAll() {
    for (int i = 0; i < pieces.length; i++) pieces[i].count = 0;
  }
}
