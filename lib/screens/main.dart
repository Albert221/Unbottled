import 'dart:async';

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

    _updatePoints();
  }

  void _updatePoints() {
    _mapCompleter.future.then((controller) async {
      final center = await controller.getLatLng(ScreenCoordinate(
        x: MediaQuery.of(context).size.width ~/ 2,
        y: MediaQuery.of(context).size.height ~/ 2,
      ));

      StoreProvider.of<AppState>(context).dispatch(
        fetchPoints(
          ApiProvider.of(context),
          center.latitude,
          center.longitude,
          10000,
        ),
      );
    });
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
              onCameraIdle: () {
                setState(() => _mapCentering = false);
                _updatePoints();
              },
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
      drawer: _buildDrawer(context),
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
    return StoreConnector<AppState, Point>(
      converter: (store) => store.state.points.firstWhere(
        (point) => point.id == _selectedPointId,
        orElse: () => null,
      ),
      builder: (context, point) => point != null
          ? ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 200),
              child: PointCard(
                photoUrl: point.photo?.url,
                averageTaste: point.averageTaste,
                onTap: () => Navigator.push(
                    context, PointScreen.route(pointID: point.id)),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Drawer(
      child: StoreConnector<AppState, bool>(
        converter: (store) => store.state.auth.authenticated,
        builder: (context, signedIn) => signedIn
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: primary),
                    child: Text(
                      'Albert221',
                      style: TextStyle(color: onPrimary),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add a point'),
                    onTap: () =>
                        Navigator.push(context, AddPointScreen.route()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.stars),
                    title: const Text('My points'),
                    onTap: () =>
                        Navigator.push(context, MyPointsScreen.route()),
                  ),
                  const Spacer(),
                  StoreConnector<AppState, VoidCallback>(
                    converter: (store) => () => store.dispatch(
                          signOut(ApiProvider.of(context)),
                        ),
                    builder: (context, signOut) => ListTile(
                      leading: const Icon(Icons.power_settings_new),
                      title: const Text('Sign out'),
                      onTap: signOut,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  const Spacer(),
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text('Sign in'),
                    onTap: () => Navigator.push(context, SignInScreen.route()),
                  ),
                ],
              ),
      ),
    );
  }
}
