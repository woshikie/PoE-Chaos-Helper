import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'collection_piece.g.dart';

@JsonSerializable()

/// Class describing a piece of collection. i.e. Helmet, Boots, Gloves
class CollectionPiece {
  /// Piece Name
  final String name;

  /// Piece Count
  int _count;

  ///Count required to be a set
  int setRequiredCount;

  CollectionPiece({
    @required this.name,
    int count,
    int setCount,
  })  : _count = count == null ? 0 : count,
        setRequiredCount = setCount == null ? 1 : setCount;

  factory CollectionPiece.fromJson(Map<String, dynamic> json) => _$CollectionPieceFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionPieceToJson(this);

  /// returns [true] if there is enough counts of this piece to be considered a set
  bool get hasSet {
    if (setRequiredCount == null) return false;
    return _count >= setRequiredCount;
  }

  /// returns number of set
  @JsonKey(ignore: true)
  int get setCount {
    try {
      return (_count / setRequiredCount).floor();
    } catch (e) {
      return 0;
    }
  }

  /// returns current count
  int get count {
    return _count;
  }

  /// sets current count
  set count(newCount) {
    _count = newCount;
  }

  void removeSet({times = 1}) {
    _count -= (setRequiredCount * times);
    assert(_count >= 0, 'Removed too much sets!');
  }
}
