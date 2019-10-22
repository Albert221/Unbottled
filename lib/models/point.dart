import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'point.g.dart';

abstract class Point implements Built<Point, PointBuilder> {
  String get id;

  @BuiltValueField(wireName: 'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'author_id')
  String get authorID;

  double get latitude;

  double get longitude;

  @nullable
  Photo get photo;

  @BuiltValueField(wireName: 'average_taste')
  double get averageTaste;

  Point._();

  factory Point([updates(PointBuilder b)]) = _$Point;

  static Serializer<Point> get serializer => _$pointSerializer;
}

abstract class Photo implements Built<Photo, PhotoBuilder> {
  String get id;

  @BuiltValueField(wireName: 'author_id')
  String get authorID;

  String get filename;

  @nullable
  String get url;

  Photo._();

  factory Photo([updates(PhotoBuilder b)]) = _$Photo;

  static Serializer<Photo> get serializer => _$photoSerializer;
}
