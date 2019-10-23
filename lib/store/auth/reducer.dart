import 'package:redux/redux.dart';
import 'package:unbottled/store/store.dart';

Reducer<AuthState> authReducer = combineReducers([
  TypedReducer<AuthState, SignedInAction>(_signedIn),
  TypedReducer<AuthState, SignedOutAction>(_signedOut),
]);

AuthState _signedIn(AuthState state, SignedInAction action) {
  return state.rebuild((b) => b..user.replace(action.user));
}

AuthState _signedOut(AuthState state, SignedOutAction action) {
  return state.rebuild((b) => b..user = null);
}
