import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:zavod/models/place_detail.dart';
import 'package:zavod/pages/map/widgets/search_field.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  LatLng? currentPosition;

  bool loadingNavigation = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  void getPermissions() {
    _handleLocationPermission(context).then((res) {
      if (res) {
        _getCurrentLocation();
      }
    });
  }

  void _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((position) {
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);

        _generateRandomPoints();
      });
    });
  }

  void _generateRandomPoints() {
    for (int i = 0; i < 7; i++) {
      double lat =
          currentPosition!.latitude + (Random().nextDouble() - 0.5) * 0.1;
      double lng =
          currentPosition!.longitude + (Random().nextDouble() - 0.5) * 0.1;
      markers.add(
        Marker(
          markerId: MarkerId('point$i'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: 'Point $i',
            snippet: 'This is point $i',
          ),
          onTap: () {
            _showPointDetails(LatLng(lat, lng), 'Point $i');
          },
        ),
      );
    }
  }

  void _showPointDetails(LatLng point, String title) async {
    try {
      final placeDetails = await getPlaceDetails(
        point.latitude,
        point.longitude,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(12.0),
            content: Row(
              children: [
                Icon(Icons.location_on_sharp, color: Colors.red),
                SizedBox(width: 10.0),
                Expanded(child: Text(placeDetails.address)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Navigate'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _buildNavigation(point);
                },
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch place details: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _buildNavigation(LatLng destination) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: dotenv.get("API_KEY"),

      request: PolylineRequest(
        origin: PointLatLng(
          currentPosition!.latitude,
          currentPosition!.longitude,
        ),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
        // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        polylines[PolylineId('route')] = Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          points: polylineCoordinates,
          width: 5,
        );
        loadingNavigation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
          currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },

                    myLocationEnabled: true,

                    initialCameraPosition: CameraPosition(
                      target: currentPosition!,
                      zoom: 14,
                    ),
                    markers: markers,

                    polylines: Set<Polyline>.of(polylines.values),
                    onTap:
                        (_) => FocusScope.of(context).requestFocus(FocusNode()),
                  ),

                  Positioned(
                    top: 84.0,
                    left: 0.0,
                    right: 0.0,
                    child: AddressInputField(_searchController, onTap: () {}),
                  ),

                  Positioned(
                    top: 50.0,
                    left: 16.0,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Row(
                        children: [
                          Icon(Icons.arrow_back_ios, size: 16.0),
                          Text(
                            "Home",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  loadingNavigation
                      ? Container(
                        color: Colors.black12,
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : SizedBox(),
                ],
              ),
    );
  }
}

Future<bool> _handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location services are disabled. Please enable the services',
          ),
        ),
      );
    }

    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
      }
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
    }

    return false;
  }
  return true;
}
