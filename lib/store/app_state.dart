import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:unbottled/models/models.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  BuiltList<Point> get points;

  AppState._();

  factory AppState([updates(AppStateBuilder b)]) {
    return _$AppState
        ._(
            points: BuiltList([
          Point((b) => b
            ..id = ''
            ..createdAt = DateTime.now()
            ..authorID = ''
            ..latitude = 10
            ..longitude = 10
            ..averageTaste = 2.3),
        ]))
        .rebuild(updates);
  }
}
