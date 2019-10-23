import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:unbottled/models/models.dart';

part 'serializers.g.dart';

@SerializersFor(const [Point, User])
final Serializers modelsSerializers = (_$modelsSerializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer()))
    .build();

final userDeserialize =
    (user) => modelsSerializers.deserializeWith(User.serializer, user);
final pointDeserialize =
    (point) => modelsSerializers.deserializeWith(Point.serializer, point);
final photoDeserialize =
    (point) => modelsSerializers.deserializeWith(Photo.serializer, point);
