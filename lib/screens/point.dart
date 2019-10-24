import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unbottled/models/models.dart';
import 'package:unbottled/store/store.dart';
import 'package:unbottled/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class PointScreen extends StatefulWidget {
  static route({@required String pointID}) =>
      MaterialPageRoute(builder: (context) => PointScreen(pointID: pointID));

  final String pointID;

  const PointScreen({Key key, this.pointID}) : super(key: key);

  @override
  _PointScreenState createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  void _addPhoto() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    ApiProvider.of(context).uploadPhoto(image).then((photo) {
      print(photo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Point>(
      converter: (store) => store.state.points.firstWhere(
        (point) => point.id == widget.pointID,
        orElse: () => null,
      ),
      builder: (builder, point) {
        if (point == null) {
          return Scaffold();
        }

        final latLng = LatLng(point.latitude, point.longitude);
        final photoAvailable = point.photo?.url?.isNotEmpty == true;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: photoAvailable ? 300 : null,
                flexibleSpace: photoAvailable
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
                  StoreConnector<AppState, bool>(
                    converter: (store) =>
                        store.state.auth.user?.id == point.authorID &&
                        point.photo?.url?.isEmpty != false,
                    builder: (context, showAddPhoto) => showAddPhoto
                        ? Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.add_a_photo),
                                title: const Text('Add point photo'),
                                onTap: _addPhoto,
                              ),
                              const SizedBox(height: 16),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_pizza),
                    title: const Text('Taste'),
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
                    leading: const Icon(Icons.add_comment),
                    title: const Text('Add your rating'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    leading: Icon(Icons.place),
                    title: Text('Location'),
                    subtitle: Text('No data'),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        launch('https://www.google.com/maps/dir/?api=1&'
                            'travelmode=walking&'
                            'destination=${point.latitude},${point.longitude}'),
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
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueAzure,
                              ),
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
