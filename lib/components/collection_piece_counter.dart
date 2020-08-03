import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionPieceCounter extends StatelessWidget {
  final String name;
  final Function onChange, onAdd, onRemove, onClear;
  final int count;
  final bool hasSet;
  CollectionPieceCounter({
    Key key,
    this.name,
    this.onChange,
    this.onAdd,
    this.onRemove,
    this.onClear,
    this.count = 0,
    this.hasSet = false,
  }) : super(key: key);

  String get _title {
    return "$name ($count)";
  }

  void _clear() {
    onChange?.call(0);
    onClear?.call(0);
  }

  void _add() {
    onChange?.call(count + 1);
    onAdd?.call(count + 1);
  }

  void _remove() {
    if (count > 0) {
      onChange?.call(count - 1);
      onRemove?.call(count - 1);
    }
  }

  Color get _bgColor {
    if (hasSet) return Colors.green;
    return Colors.transparent;
  }

  final double splashRadius = 64.nsp;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  splashRadius: splashRadius,
                  icon: Icon(Icons.add),
                  onPressed: _add,
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Text(
                    _title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 24.w,
          ),
          IconButton(
            splashRadius: splashRadius,
            icon: Icon(Icons.remove),
            onPressed: _remove,
          ),
          IconButton(
            color: Colors.red,
            splashRadius: splashRadius,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.clear),
            onPressed: _clear,
          ),
        ],
      ),
    );
  }
}
