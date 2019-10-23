import 'dart:io';

import 'package:unbottled/models/models.dart';

abstract class Api {
  Future<User> authenticate(String emailOrUsername, String password);

  Future<User> refreshToken(String oldToken);

  Future<void> signOut();

  Future<User> createAccount(String email, String username, String password);

  Future<List<Point>> getPoints(double lat, double lng, double radius);

  Future<List<Point>> getMyPoints();

  Future<Photo> uploadPhoto(File photo);

  Future<Point> addPoint(double lat, double lng, String photoID);
}
