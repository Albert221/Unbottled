import 'package:unbottled/store/store.dart';

AppState rootReducer(AppState state, action) {
  return state.rebuild(
    (b) => b
      ..auth.replace(authReducer(state.auth, action))
      ..points.replace(pointsReducer(state.points, action)),
  );
}
