import 'dart:async';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:unbottled/api/api.dart';
import 'package:unbottled/models/models.dart';
import 'package:unbottled/store/store.dart';

ThunkAction<AppState> signIn(Api api, String emailOrUsername, String password,
    {Completer completer}) {
  return (Store<AppState> store) {
    api
        .authenticate(emailOrUsername, password)
        .then((user) => store.dispatch(SignedInAction(user)))
        .whenComplete(() => completer?.complete());
  };
}

class SignedInAction {
  final User user;

  SignedInAction(this.user);
}

ThunkAction<AppState> signOut(Api api) {
  return (Store<AppState> store) {
    api.signOut().then((_) => store.dispatch(SignedOutAction()));
  };
}

class SignedOutAction {}
