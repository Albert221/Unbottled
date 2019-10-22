import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:unbottled/api/api.dart';
import 'package:unbottled/models/models.dart';
import 'package:unbottled/store/store.dart';

ThunkAction<AppState> fetchPoints(
    Api api, double lat, double lng, double radius) {
  return (Store<AppState> store) {
    api.getPoints(lat, lng, radius).then((points) {
      store.dispatch(FetchedPointsAction(points));
    });
  };
}

class FetchedPointsAction {
  final List<Point> points;

  FetchedPointsAction(this.points);
}
