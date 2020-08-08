import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'poe_compact_stash.g.dart';

@JsonSerializable()

/// This class briefly describes a stash tab only
class PoeCompactStash {
  final String n, id;

  @JsonKey(name: 'i')
  final int index;

  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color colour;

  static Color _colorFromJson(dynamic json) {
    return Color.fromARGB(255, json['r'], json['g'], json['b']);
  }

  static Map<String, int> _colorToJson(Color color) {
    return {
      'r': color.red,
      'g': color.green,
      'b': color.blue,
    };
  }

  PoeCompactStash(this.n, this.id, this.index, this.colour);

  factory PoeCompactStash.fromJson(Map<String, dynamic> json) => _$PoeCompactStashFromJson(json);
  Map<String, dynamic> toJson() => _$PoeCompactStashToJson(this);
}
