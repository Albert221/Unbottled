import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unbottled/models/models.dart';
import 'package:unbottled/store/store.dart';
import 'package:unbottled/widgets/widgets.dart';

class PointScreen extends StatelessWidget {
  static route({@required String pointID}) =>
      MaterialPageRoute(builder: (context) => PointScreen(pointID: pointID));

  const PointScreen({Key key, this.pointID}) : super(key: key);

  final String pointID;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Point>(
      converter: (store) =>
          store.state.points.firstWhere((point) => point.id == pointID),
      builder: (builder, point) {
        final latLng = LatLng(point.latitude, point.longitude);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                flexibleSpace: point.photo != null
                    ? FlexibleSpaceBar(
                        background: Hero(
                          tag: 'point-photo',
                          child: CachedNetworkImage(
                            imageUrl: point.photo.url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : null,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  ListTile(
                    leading: Icon(Icons.local_pizza),
                    title: Text('Taste'),
                    subtitle: Text('3.5 stars'),
                    trailing: Hero(
                      tag: 'point-taste',
                      child: IconTheme(
                        data: const IconThemeData(color: Colors.orangeAccent),
                        child: Rating(rating: point.averageTaste),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.add_comment),
                    title: Text('Add your rating'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.place),
                    title: Text('Location'),
                    subtitle: Text('No data'),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: 250,
                      child: IgnorePointer(
                        child: GoogleMap(
                          myLocationButtonEnabled: false,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: latLng,
                            zoom: 13,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(point.id),
                              position: latLng,
                            )
                          },
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
