// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_piece.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionPiece _$CollectionPieceFromJson(Map<String, dynamic> json) {
  return CollectionPiece(
    name: json['name'] as String,
    count: json['count'] as int,
    setCount: json['setCount'] as int,
  );
}

Map<String, dynamic> _$CollectionPieceToJson(CollectionPiece instance) => <String, dynamic>{
      'name': instance.name,
      'setCount': instance._setCount,
      'count': instance.count,
    };
