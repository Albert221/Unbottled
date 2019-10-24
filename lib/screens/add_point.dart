import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
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

  void _onAddPointHereTap({@required bool withPhoto}) {
    _mapCompleter.future.then((controller) async {
      final mapSize =
          (_mapKey.currentContext.findRenderObject() as RenderBox).size;
      final center = await controller.getLatLng(ScreenCoordinate(
        x: mapSize.width ~/ 2,
        y: mapSize.height ~/ 2,
      ));

      final api = ApiProvider.of(context);
      String photoId;

      if (withPhoto) {
        print('before pick image');
        final photo = await ImagePicker.pickImage(source: ImageSource.camera);
        print('before upload');
        final photoApi = await api.uploadPhoto(photo);
        print('after upload');
        photoId = photoApi.id;
      }

      api.addPoint(center.latitude, center.longitude, photoId).then((point) {
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
    final onSurface = Theme.of(context).colorScheme.onSurface;

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
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton.icon(
                      icon: Icon(Icons.add_a_photo, color: onPrimary),
                      label: Text(
                        'ADD WITH PHOTO',
                        style: TextStyle(color: onPrimary),
                      ),
                      onPressed: () => _onAddPointHereTap(withPhoto: true),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    RaisedButton.icon(
                      icon: Icon(Icons.add_location, color: onSurface),
                      label: Text(
                        'ADD',
                        style: TextStyle(color: onSurface),
                      ),
                      onPressed: () => _onAddPointHereTap(withPhoto: false),
                      color: Theme.of(context).colorScheme.surface,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
