import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:unbottled/api/api.dart';
import 'package:unbottled/models/models.dart';
import 'package:unbottled/store/store.dart';

ThunkAction<AppState> fetchMyPoints(Api api) {
  return (Store<AppState> store) {
    api.getMyPoints().then((points) {
      store.dispatch(FetchedMyPointsAction(points));
    });
  };
}

class FetchedMyPointsAction {
  final List<Point> points;

  FetchedMyPointsAction(this.points);
}
