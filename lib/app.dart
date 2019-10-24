import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:unbottled/api/api.dart';
import 'package:unbottled/screens/screens.dart';
import 'package:unbottled/store/store.dart';
import 'package:unbottled/widgets/api_provider.dart';

class UnbottledApp extends StatelessWidget {
  final Store<AppState> store;
  final Api api;

  const UnbottledApp({
    Key key,
    @required this.store,
    @required this.api,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ApiProvider(
      api: api,
      child: StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Unbottled',
          home: MainScreen(),
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}
