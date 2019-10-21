import 'package:flutter/material.dart';
import 'package:unbottled/api/api.dart';

class ApiProvider extends InheritedWidget {
  final Api api;

  ApiProvider({
    Key key,
    @required this.api,
    @required Widget child,
  }) : super(key: key, child: child);

  static Api of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ApiProvider) as ApiProvider).api;

  @override
  bool updateShouldNotify(ApiProvider oldWidget) => api != oldWidget.api;
}
