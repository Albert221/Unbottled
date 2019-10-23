import 'package:built_value/built_value.dart';
import 'package:unbottled/models/models.dart';

part 'auth_state.g.dart';

abstract class AuthState implements Built<AuthState, AuthStateBuilder> {
  bool get authenticated => user != null;

  @nullable
  User get user;

  AuthState._();

  factory AuthState([updates(AuthStateBuilder b)]) = _$AuthState;
}
