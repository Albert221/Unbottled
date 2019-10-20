import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:unbottled/screens/screens.dart';
import 'package:unbottled/store/store.dart';

class UnbottledApp extends StatelessWidget {
  final Store<AppState> store;

  const UnbottledApp({Key key, @required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Unbottled',
        home: MainScreen(),
      ),
    );
  }
}
