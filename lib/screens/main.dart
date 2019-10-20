import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:unbottled/models/models.dart';
import 'package:unbottled/screens/screens.dart';
import 'package:unbottled/store/store.dart';
import 'package:unbottled/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _defaultCoordinates = LatLng(52.237049, 21.017532);

  final _mapCompleter = Completer<GoogleMapController>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchInputFocusNode = FocusNode();

  String _selectedPointId;
  bool _mapCentering = false;

  @override
  void initState() {
    super.initState();

    _searchInputFocusNode.addListener(() => setState(() {}));
    Location().requestPermission().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          StoreConnector<AppState, List<Point>>(
            converter: (store) => store.state.points.toList(),
            builder: (context, points) => GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (controller) => _mapCompleter.complete(controller),
              initialCameraPosition: const CameraPosition(
                target: _defaultCoordinates,
                zoom: 4,
              ),
              onCameraMoveStarted: () {
                if (!_mapCentering) {
                  setState(() => _selectedPointId = null);
                }
              },
              onCameraIdle: () => setState(() => _mapCentering = false),
              markers: points
                  .map((point) => Marker(
                      markerId: MarkerId(point.id),
                      position: LatLng(point.latitude, point.longitude),
                      onTap: () {
                        setState(() {
                          _selectedPointId = point.id;
                          _mapCentering = true;
                        });
                      }))
                  .toSet(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSearchBar(context),
                  const Spacer(),
                  if (_selectedPointId != null) _buildPointCard(context)
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: const Text('Sign out'),
              onTap: () {},
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add a point'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.stars),
              title: const Text('My points'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(4),
      elevation: 4,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextField(
            focusNode: _searchInputFocusNode,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search...',
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 48,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
              const Spacer(),
              if (_searchInputFocusNode.hasFocus)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => FocusScope.of(context).unfocus(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointCard(BuildContext context) {
    final point = StoreProvider.of<AppState>(context).state.points.firstWhere(
          (point) => point.id == _selectedPointId,
          orElse: () => null,
        );

    return point != null
        ? ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: 200),
            child: Material(
              elevation: 4,
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                    context, PointScreen.route(pointID: point.id)),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Hero(
                      tag: 'point-photo',
                      child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          // basically an Ink.image, but with borderRadius
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(point.photo !=
                                      null
                                  ? point.photo.id
                                  : 'http://fakeimg.pl/300x200/?text=No+photo'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Hero(
                        tag: 'point-taste',
                        child: IconTheme(
                          data: const IconThemeData(color: Colors.white),
                          child: Rating(
                            rating: point.averageTaste ?? 0,
                            trailing: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
