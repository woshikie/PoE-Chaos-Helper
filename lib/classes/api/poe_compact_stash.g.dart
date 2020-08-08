// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poe_compact_stash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoeCompactStash _$PoeCompactStashFromJson(Map<String, dynamic> json) {
  return PoeCompactStash(
    json['n'] as String,
    json['id'] as String,
    json['i'] as int,
    PoeCompactStash._colorFromJson(json['color']),
  );
}

Map<String, dynamic> _$PoeCompactStashToJson(PoeCompactStash instance) =>
    <String, dynamic>{
      'n': instance.n,
      'id': instance.id,
      'i': instance.index,
      'color': PoeCompactStash._colorToJson(instance.color),
    };
