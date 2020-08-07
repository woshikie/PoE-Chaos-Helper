// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poe_compact_league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoeCompactLeague _$PoeCompactLeagueFromJson(Map<String, dynamic> json) {
  return PoeCompactLeague(
    json['id'] as String,
    json['realm'] as String,
    json['description'] as String,
    json['url'] as String,
    json['registerAt'] == null
        ? null
        : DateTime.parse(json['registerAt'] as String),
    json['startAt'] == null ? null : DateTime.parse(json['startAt'] as String),
    json['endAt'] == null ? null : DateTime.parse(json['endAt'] as String),
    json['delveEvent'] as bool,
    json['rules'] as List,
  );
}

Map<String, dynamic> _$PoeCompactLeagueToJson(PoeCompactLeague instance) =>
    <String, dynamic>{
      'id': instance.id,
      'realm': instance.realm,
      'description': instance.description,
      'url': instance.url,
      'registerAt': instance.registerAt?.toIso8601String(),
      'startAt': instance.startAt?.toIso8601String(),
      'endAt': instance.endAt?.toIso8601String(),
      'delveEvent': instance.delveEvent,
      'rules': instance.rules,
    };
