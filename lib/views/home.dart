import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poe_chaos_helper/classes/collection.dart';
import 'package:poe_chaos_helper/classes/collection_piece.dart';
import 'package:poe_chaos_helper/classes/constants.dart';
import 'package:poe_chaos_helper/components/collection_piece_counter.dart';
import 'package:poe_chaos_helper/views/setting.dart';

class Home extends StatefulWidget {
  final Random _random = Constants.random;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Collection collection;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Collection.fromSharedPrefs().then((value) {
      setState(() {
        collection = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(TITLE),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Settings()));
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 64.w),
        child: mainBodyChild,
      ),
    );
  }
}
