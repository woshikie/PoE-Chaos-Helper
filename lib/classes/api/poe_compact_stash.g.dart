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
    Color.fromARGB(255, (json['colour']['r'] as int), (json['colour']['g']) as int, (json['colour']['b']) as int),
  );
}

Map<String, dynamic> _$PoeCompactStashToJson(PoeCompactStash instance) => <String, dynamic>{
      'n': instance.n,
      'id': instance.id,
      'i': instance.index,
      'color': instance.color.value,
    };
