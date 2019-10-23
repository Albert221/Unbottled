import 'package:built_collection/built_collection.dart';
import 'package:redux/redux.dart';
import 'package:unbottled/models/point.dart';
import 'package:unbottled/store/my_points/actions.dart';
import 'package:unbottled/store/points/actions.dart';

Reducer<BuiltList<Point>> myPointsReducer = combineReducers([
  TypedReducer<BuiltList<Point>, FetchedMyPointsAction>(_fetchedMyPoints),
]);

BuiltList<Point> _fetchedMyPoints(
    BuiltList<Point> state, FetchedMyPointsAction action) {
  return state.rebuild((b) => b
    ..removeWhere(
        (point) => action.points.any((pointX) => pointX.id == point.id))
    ..addAll(action.points));
}
