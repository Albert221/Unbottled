import 'package:unbottled/store/store.dart';

AppState rootReducer(AppState state, action) {
  return state
      .rebuild((b) => b..points.replace(pointsReducer(state.points, action)));
}
