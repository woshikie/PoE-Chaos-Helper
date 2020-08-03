import 'dart:math';

import 'package:poe_chaos_helper/classes/collection_piece.dart';

class Collection {
  final List<CollectionPiece> pieces = [
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
