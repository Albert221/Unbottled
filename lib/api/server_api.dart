import 'dart:io';

import 'package:unbottled/api/api.dart';
import 'package:unbottled/models/models.dart';

class ServerApi implements Api {
  String _accessToken;

  @override
  Future<User> authenticate(String emailOrUsername, String password) {
    // TODO: implement authenticate
    return null;
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