import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:unbottled/api/api.dart';
import 'package:unbottled/models/models.dart';

class ServerApi implements Api {
  final _client = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
  ));

  String _accessToken;

  FutureOr<T> _handleError<T>(error) {
    if (error is DioError) {
      final response = error.response;
      print(response);
      return Future<T>.error(
          '${response.statusCode}: ${response.data['error'] ?? ''}');
    }

    throw error;
  }

  @override
  Future<User> authenticate(String emailOrUsername, String password) {
    return _client
        .post('/auth/authenticate', data: {
          'email_or_username': emailOrUsername,
          'password': password,
        })
        .then((response) {
          _accessToken = response.data['access_token'];

          return response.data['user'];
        })
        .then(
            (user) => modelsSerializers.deserializeWith(User.serializer, user))
        .catchError((err) => _handleError(err));
  }

  @override
  Future<void> signOut() async {
    _accessToken = null;
  }

  @override
  Future<User> createAccount(String email, String username, String password) {
    // TODO: implement createAccount
    return null;
  }

  @override
  Future<List<Point>> getPoints(double lat, double lng, double radius) {
    // TODO: implement getPoints
    return null;
  }

  @override
  Future<Photo> uploadPhoto(File photo) {
    // TODO: implement uploadPhoto
    return null;
  }

  @override
  Future<Point> addPoint(double lat, double lng, String photoID) {
    // TODO: implement addPoint
    return null;
  }
}
