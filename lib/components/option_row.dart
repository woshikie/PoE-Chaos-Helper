import 'package:flutter/material.dart';

class OptionRow extends StatelessWidget {
  static TextStyle defaultTextStyle;
  final TextStyle settingTextStyle;
  final String title;
  final Widget control;
  OptionRow({
    Key key,
    this.settingTextStyle,
    Widget control,
    @required this.title,
  })  : this.control = control ?? Container(),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: settingTextStyle ?? defaultTextStyle,
        ),
        control
      ],
    );
  }
}
