import 'dart:async';

import 'package:come_along_with_me/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(18.4796, -69.8908); // Santo Domingo, Dominican Republic
  static const LatLng destination = LatLng(18.7357, -70.1627); // Santiago, Dominican Republic

  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    getPolyPoints();
  }

  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tracking",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: sourceLocation,
            zoom: 7.0,
          ),
          polylines: {
            Polyline(
              polylineId: PolylineId("route"),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 6,
            ),
          },
          markers: {
            Marker(
              markerId: const MarkerId("source"),
              position: sourceLocation,
            ),
            Marker(
              markerId: const MarkerId("destination"),
              position: destination,
            ),
          },
          onMapCreated: (mapController) {
            _controller.complete(mapController);
          },
        ),
      ),
    );
  }
}
