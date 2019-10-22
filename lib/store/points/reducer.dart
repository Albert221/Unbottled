import 'package:built_collection/built_collection.dart';
import 'package:redux/redux.dart';
import 'package:unbottled/models/point.dart';
import 'package:unbottled/store/points/actions.dart';

Reducer<BuiltList<Point>> pointsReducer = combineReducers([
  TypedReducer<BuiltList<Point>, FetchedPointsAction>(_fetchedPoints),
]);

BuiltList<Point> _fetchedPoints(
    BuiltList<Point> state, FetchedPointsAction action) {
  return state.rebuild((b) => b
    ..removeWhere((point) => action.points.contains(point.id))
    ..addAll(action.points));
}
