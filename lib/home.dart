import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:poe_chaos_helper/classes/collection.dart';
import 'package:poe_chaos_helper/classes/collection_piece.dart';
import 'package:poe_chaos_helper/components/collection_piece_counter.dart';
import 'package:poe_chaos_helper/constants.dart';

class Home extends StatefulWidget {
  final Random _random = Random();
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Collection collection;
  Random get _random => widget._random;

  Color get _randomColor {
    return Color.fromARGB(255, _random.nextInt(256), _random.nextInt(256), _random.nextInt(256));
  }

  List<Color> get _randomColors {
    return [
      _randomColor,
      _randomColor,
      _randomColor,
    ];
  }

  Widget get _templateWaiting {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Loading from shared preference...',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 64.h,
          ),
          SizedBox(
            height: 500.nsp,
            width: 500.nsp,
            child: LoadingIndicator(
              indicatorType: Indicator.values[_random.nextInt(Indicator.values.length)],
              color: _randomColor,
              colors: _randomColors,
            ),
          ),
        ],
      ),
    );
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
  void clearAll() {
    setState(() {
      collection.clearAll();
      saveCollection();
    });
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
    return _templateWaiting;
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
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 64.w),
        child: mainBodyChild,
      ),
    );
  }
}
