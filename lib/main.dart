import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart' show thunkMiddleware;
import 'package:unbottled/api/api.dart';
import 'package:unbottled/app.dart';
import 'package:unbottled/store/reducer.dart';
import 'package:unbottled/store/store.dart';

void main() {
  final store = Store<AppState>(
    rootReducer,
    initialState: AppState(),
    middleware: [
      thunkMiddleware,
      (store, action, next) {
        print(action.toString());
        next(action);
      },
    ],
  );

  runApp(UnbottledApp(
    store: store,
    api: ServerApi(),
  ));
}
