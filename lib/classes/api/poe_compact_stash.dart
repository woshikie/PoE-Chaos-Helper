import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'poe_compact_stash.g.dart';

@JsonSerializable()

/// This class briefly describes a stash tab only
class PoeCompactStash {
  final String n, id;
  final int index;
  final Color color;
  PoeCompactStash(this.n, this.id, this.index, this.color);

  factory PoeCompactStash.fromJson(Map<String, dynamic> json) => _$PoeCompactStashFromJson(json);
  Map<String, dynamic> toJson() => _$PoeCompactStashToJson(this);
}
