import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poe_chaos_helper/components/option_row.dart';

class OptionRowTextFormField extends StatelessWidget {
  const OptionRowTextFormField({
    Key key,
    this.initialValue,
    @required this.title,
    this.onSave,
    this.action,
    this.controller,
  }) : super(key: key);
  final String initialValue, title;
  final Function(String) onSave;
  final Widget action;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    String buffer = '';
    return OptionRow(
      title: title,
      control: SizedBox(
        width: 500.w,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                initialValue: controller == null ? initialValue : null,
                onChanged: (String newVal) {
                  buffer = newVal;
                },
              ),
            ),
            if (action != null) action,
            IconButton(
                icon: Icon(Icons.save),
                onPressed: onSave == null
                    ? null
                    : () {
                        onSave(buffer);
                      }),
          ],
        ),
      ),
    );
  }
}
