import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointScreen extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => PointScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'point-photo',
                child: CachedNetworkImage(
                  imageUrl: 'https://i.imgur.com/vgCTbOl.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                    child: Wrap(
                      spacing: 4,
                      children: [
                        const Icon(Icons.star),
                        const Icon(Icons.star),
                        const Icon(Icons.star),
                        const Icon(Icons.star_half),
                      ],
                    ),
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
                        target: LatLng(10, 10),
                        zoom: 13,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('sds'),
                          position: LatLng(10, 10),
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
  }
}
