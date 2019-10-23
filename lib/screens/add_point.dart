import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unbottled/screens/point.dart';
import 'package:unbottled/store/store.dart';
import 'package:unbottled/widgets/api_provider.dart';

class AddPointScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddPointScreen());

  @override
  _AddPointScreenState createState() => _AddPointScreenState();
}

class _AddPointScreenState extends State<AddPointScreen> {
  final _mapCompleter = Completer<GoogleMapController>();
  final _mapKey = GlobalKey();

  void _onAddPointHereTap() {
    _mapCompleter.future.then((controller) async {
      final mapSize =
          (_mapKey.currentContext.findRenderObject() as RenderBox).size;
      final center = await controller.getLatLng(ScreenCoordinate(
        x: mapSize.width ~/ 2,
        y: mapSize.height ~/ 2,
      ));

      final api = ApiProvider.of(context);
      api.addPoint(center.latitude, center.longitude).then((point) {
        StoreProvider.of<AppState>(context).dispatch(fetchMyPoints(api));

        Navigator.pushReplacement(
          context,
          PointScreen.route(pointID: point.id),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a point'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            key: _mapKey,
            myLocationEnabled: true,
            onMapCreated: (controller) => _mapCompleter.complete(controller),
            initialCameraPosition: CameraPosition(
              target: LatLng(20, 20),
              zoom: 13,
            ),
          ),
          Container(
            width: 2,
            height: double.infinity,
            color: Colors.black45,
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.black45,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: RaisedButton.icon(
                  icon: Icon(Icons.add_location, color: onPrimary),
                  label: Text(
                    'ADD POINT HERE',
                    style: TextStyle(
                      color: onPrimary,
                    ),
                  ),
                  onPressed: _onAddPointHereTap,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
