import 'package:unbottled/store/store.dart';

AppState rootReducer(AppState state, action) {
  return state.rebuild(
    (b) => b
      ..auth.replace(authReducer(state.auth, action))
      ..myPoints.replace(myPointsReducer(state.myPoints, action))
      ..points.replace(pointsReducer(state.points, action)),
  );
}
