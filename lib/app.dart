import 'package:flutter/material.dart';
import 'package:unbottled/screens/screens.dart';

class UnbottledApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unbottled',
      home: MainScreen(),
    );
  }
}
