import 'package:json_annotation/json_annotation.dart';

part 'poe_compact_league.g.dart';

@JsonSerializable()
class PoeCompactLeague {
  final String id, realm, description, url;
  final DateTime registerAt, startAt, endAt;
  final bool delveEvent;
  final List<dynamic> rules;

  PoeCompactLeague(this.id, this.realm, this.description, this.url, this.registerAt, this.startAt, this.endAt, this.delveEvent, this.rules);

  factory PoeCompactLeague.fromJson(Map<String, dynamic> json) => _$PoeCompactLeagueFromJson(json);
  Map<String, dynamic> toJson() => _$PoeCompactLeagueToJson(this);
}
