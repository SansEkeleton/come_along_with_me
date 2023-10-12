import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GpsSharing extends StatefulWidget {
  @override
  _GpsSharingState createState() => _GpsSharingState();
}

class _GpsSharingState extends State<GpsSharing> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS Sharing'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(18.4796, -69.8908), // Initial map coordinates
          zoom: 12.0, // Initial zoom level
        ),
      ),
    );
  }
}
