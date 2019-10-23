import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:unbottled/api/api.dart';
import 'package:unbottled/models/models.dart';

class ServerApi implements Api {
  final _client = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8080',
  ));

  String _accessToken;

  ServerApi() {
    _client.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequestInterceptor,
    ));
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
        .then(userDeserialize)
        .catchError((err) => _handleError<User>(err));
  }

  @override
  Future<User> refreshToken(String oldToken) {
    return _client
        .post('/auth/refresh-token', data: {'old_token': oldToken})
        .then((response) {
          _accessToken = response.data['access_token'];
          return response.data['user'];
        })
        .then(userDeserialize)
        .catchError((err) => _handleError<User>(err));
  }

  @override
  Future<void> signOut() async {
    _accessToken = null;
  }

  @override
  Future<User> createAccount(String email, String username, String password) {
    return _client
        .post('/user', data: {
          'email': email,
          'username': username,
          'password': password,
        })
        .then((response) => response.data['user'])
        .then(userDeserialize)
        .catchError((err) => _handleError<User>(err));
  }

  @override
  Future<List<Point>> getPoints(double lat, double lng, double radius) {
    return _client
        .get('/point/$lat,$lng,$radius')
        .then((response) => response.data['points'])
        .then((points) => List.from(points).map(pointDeserialize).toList())
        .catchError((err) => _handleError<List<Point>>(err));
  }

  @override
  Future<List<Point>> getMyPoints() {
    assert(_accessToken != null);

    return _client
        .get('/point/mine')
        .then((response) => response.data['points'])
        .then((points) => List.from(points).map(pointDeserialize).toList())
        .catchError((err) => _handleError<List<Point>>(err));
  }

  @override
  Future<Photo> uploadPhoto(File photo) {
    assert(_accessToken != null);

    return _client
        .post(
          '/point/photo',
          data: photo.readAsBytesSync(),
          options: Options(headers: {'Content-Type': 'image/json'}),
        )
        .then((response) => response.data['photo'])
        .then(photoDeserialize)
        .catchError((err) => _handleError<User>(err));
  }

  @override
  Future<Point> addPoint(double lat, double lng, [String photoID]) {
    assert(_accessToken != null);

    return _client
        .post('/point', data: {
          'latitude': lat,
          'longitude': lng,
          'photo_id': photoID,
        })
        .then((response) => response.data['point'])
        .then(pointDeserialize)
        .catchError((err) => _handleError<List<Point>>(err));
  }

  FutureOr<T> _handleError<T>(error) {
    if (error is DioError) {
      if (error.error is SocketException) {
        return Future<T>.error('Cannot connect to the server');
      }

      final response = error.response;
      return Future<T>.error(
          '${response.statusCode}: ${response.data['error'] ?? ''}');
    }

    throw error;
  }

  Future<RequestOptions> _onRequestInterceptor(RequestOptions options) async {
    if (_accessToken == null) {
      return options;
    }

    // ignore: dead_code
    if (false /* isTokenExpired */) {
      await refreshToken(_accessToken);
    }

    return options..headers['Authorization'] = 'Bearer $_accessToken';
  }
}
