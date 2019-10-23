import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unbottled/models/models.dart';
import 'package:unbottled/screens/point.dart';
import 'package:unbottled/store/store.dart';
import 'package:unbottled/widgets/api_provider.dart';
import 'package:unbottled/widgets/widgets.dart';

class MyPointsScreen extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => MyPointsScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My points'),
      ),
      body: StoreConnector<AppState, List<Point>>(
        onInit: (store) => store.dispatch(
          fetchMyPoints(ApiProvider.of(context)),
        ),
        converter: (store) => store.state.myPoints.toList(),
        builder: (context, points) => points.isNotEmpty
            ? ListView.builder(
                itemCount: points.length,
                itemBuilder: (context, i) {
                  final point = points[i];
                  final latLng = LatLng(point.latitude, point.longitude);

                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      PointScreen.route(pointID: point.id),
                    ),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: IgnorePointer(
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: latLng,
                                  zoom: 15,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId(point.id),
                                    position: latLng,
                                  ),
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            child: IconTheme(
                              data: const IconThemeData(
                                  color: Colors.orangeAccent),
                              child: Rating(rating: point.averageTaste),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text('You have not added any points yet!'),
              ),
      ),
    );
  }
}
