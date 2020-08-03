import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poe_chaos_helper/classes/collection.dart';
import 'package:poe_chaos_helper/classes/collection_piece.dart';
import 'package:poe_chaos_helper/components/collection_piece_counter.dart';
import 'package:poe_chaos_helper/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Collection collection = Collection();

  List<Widget> get _children {
    List<Widget> ret = [];
    for (CollectionPiece piece in collection.pieces) {
      ret.add(
        CollectionPieceCounter(
          count: piece.count,
          name: piece.name,
          hasSet: piece.hasSet,
          onChange: (newCount) {
            setState(() {
              piece.count = newCount;
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
    });
  }

  void removeOneSet() {
    setState(() {
      collection.removeSet();
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
        child: Column(
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
        ),
      ),
    );
  }
}
