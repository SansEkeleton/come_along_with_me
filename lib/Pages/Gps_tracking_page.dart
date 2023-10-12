import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({
    Key? key,
    required Null Function(Map<String, dynamic> message) onSendLocation,
  }) : super(key: key);

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? santoDomingoLocation;
  LatLng? santiagoLocation;

  String locationText = '';
  String distanceText = '';
  bool showPolyline = false;
  bool isLocationEnabled = false;

  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  List<LatLng> directionCoordinates = [
    LatLng(18.4796, -69.8908),
    LatLng(19.4517000, -70.6970300),
  ];

  List<LatLng> movingCoordinates = [
    LatLng(18.4796, -69.8908),
  ];

  late StreamSubscription<int> timerSubscription;
  int updateInterval = 5000;

  bool isButtonSoundEnabled = true;

  Future<String?> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null; // Return null if the user is not authenticated
  }

  Future<void> saveLocationAndUser(LatLng location, String userId) async {
    final firestoreInstance = FirebaseFirestore.instance;

    try {
      await firestoreInstance.collection('panicLocations').add({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Location and user data saved to Firestore.');
    } catch (e) {
      print('Error saving location and user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    updateLocationText();
    updateDistanceText();
    startMovingPolyline();
  }

  void updateLocationText() {
    locationText = 'Ubicación actual: Santo Domingo';
  }

  void updateDistanceText() {
    distanceText = 'Destino Final: Santiago';
  }

  void onLocationButtonPressed() {
    if (isLocationEnabled) {
      santoDomingoLocation = LatLng(18.4796, -69.8908);
      santiagoLocation = LatLng(19.4517000, -70.6970300);

      setState(() {
        showPolyline = true;
      });
    } else {
      // Display an in-app notification when the location is not enabled.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "No tienes acceso a esta función, comunícate con un usuario"),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  void onSendLocationButtonPressed() {
    // Implement your logic for sending location (if needed).
  }

  Future<void> playAlertSound() async {
    try {
      await assetsAudioPlayer.open(
        Audio(
            'assets/onlymp3.to - Danger Alarm Sound Effect-rUkzZTGE6jI-192k-1695664567.mp3'),
        autoStart: true,
      );
    } catch (e) {
      print('Error playing alert sound: $e');
    }
  }

  void onReceiveLocationButtonPressed() async {
    setState(() {
      isLocationEnabled = true;
    });
  }

  void onPanicButtonPressed() async {
    if (isButtonSoundEnabled) {
      playAlertSound();
    }

    final userId = await getCurrentUserId(); // Get the current user's UID

    if (userId != null) {
      LatLng currentLocation =
          LatLng(18.4796, -69.8908); // Replace with actual location access

      await saveLocationAndUser(currentLocation, userId);
    } else {
      print('User is not authenticated.'); // Handle this as needed
    }
  }

  void startMovingPolyline() {
    timerSubscription = Stream.periodic(
      Duration(milliseconds: updateInterval),
      (iteration) => iteration,
    ).listen((_) {
      if (movingCoordinates.isNotEmpty) {
        final List<LatLng> updatedCoordinates = movingCoordinates.map((coord) {
          return LatLng(
            coord.latitude + 0.01,
            coord.longitude + 0.01,
          );
        }).toList();

        setState(() {
          movingCoordinates = updatedCoordinates;
        });
      }
    });
  }

  @override
  void dispose() {
    timerSubscription.cancel();
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tracking",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  18.7357, -70.1627), // Centered on the Dominican Republic
              zoom: 6.0,
            ),
            polylines: {
              if (showPolyline)
                Polyline(
                  polylineId: PolylineId("route"),
                  points: directionCoordinates,
                  color: Colors.blue,
                  width: 6,
                ),
              Polyline(
                polylineId: PolylineId("movingRoute"),
                points: movingCoordinates,
                color: Colors.green,
                width: 6,
              ),
            },
            markers: {
              if (santoDomingoLocation != null)
                Marker(
                  markerId: const MarkerId("santoDomingo"),
                  position: santoDomingoLocation!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen,
                  ),
                ),
              if (santiagoLocation != null)
                Marker(
                  markerId: const MarkerId("santiago"),
                  position: santiagoLocation!,
                ),
            },
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
          ),
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: ElevatedButton(
              onPressed: onPanicButtonPressed,
              child: Icon(
                Icons.notifications,
                size: 24.0,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(16.0),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: onLocationButtonPressed,
              child: Text("Obtener Ubicación"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onReceiveLocationButtonPressed,
              child: Text("Recibir Ubicación"),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
