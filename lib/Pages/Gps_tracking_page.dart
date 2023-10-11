import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gps_sharing.dart';

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
  LatLng? userLocation;
  LatLng? otherUserLocation; // Store other user's location
  String locationText = '';
  String distanceText = '';
  bool showPolyline = false;
  bool isLocationEnabled = false;
  bool showUserMarkers = false;
  bool personButtonEnabled = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _userLocations =
      FirebaseFirestore.instance.collection('user_locations');

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
  bool locationAccessGranted = false;
  bool hasReceivedLocation = false;
  bool hasConsentToShareLocation =
      false; // Track if the other user consents to share location

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

  Future<void> _determineInitialLocation() async {
    Position? position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng initialLatLng = position != null
        ? LatLng(position.latitude, position.longitude)
        : LatLng(18.4796, -69.8908);

    setState(() {
      userLocation = initialLatLng;
    });
  }

  Future<void> onLocationButtonPressed() async {
    final permission.PermissionStatus status =
        await permission.Permission.location.request();

    if (status == permission.PermissionStatus.granted) {
      await _determineInitialLocation();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ubicación actualizada'),
      ));
      _saveUserLocation(userLocation!); // Save the location data
      _showUserRoute(); // Show user's route
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No tienes acceso a esta función'),
      ));
    }
  }

  Future<void> playAlertSound() async {
    try {
      await assetsAudioPlayer.open(
        Audio(
            'assets/onlymp3.to - Danger Alarm Sound Effect-rUkzTGE6jI-192k-1695664567.mp3'),
        autoStart: true,
      );
    } catch (e) {
      print('Error playing alert sound: $e');
    }
  }

  Future<void> _saveUserLocation(LatLng location) async {
    if (location != null) {
      try {
        await _userLocations.add({
          'latitude': location.latitude,
          'longitude': location.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ubicación guardada en Firestore'),
        ));
      } catch (e) {
        print('Error saving user location: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al guardar la ubicación'),
        ));
      }
    }
  }

  Future<void> _showOtherUserLocationDialog() async {
    final consent = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Solicitar ubicación'),
          content: Text('¿Deseas compartir tu ubicación con el otro usuario?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No consent
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Consent
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );

    if (consent == true) {
      // The other user consents to share location
      setState(() {
        showUserMarkers = true;
        hasConsentToShareLocation = true;
      });
    }
  }

  void onReceiveLocationButtonPressed() async {
    setState(() {
      isLocationEnabled = true;
      locationAccessGranted = true;
      hasReceivedLocation = true;
    });
  }

  void onPanicButtonPressed() {
    if (!hasReceivedLocation) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No tienes permiso para esta función'),
      ));
    } else if (isButtonSoundEnabled) {
      playAlertSound();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Panic Button Pressed'),
          content: Text('Your panic action goes here.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Set<Marker> _createUserMarkers() {
    final markers = <Marker>{
      if (userLocation != null)
        Marker(
          markerId: const MarkerId("userLocation"),
          position: userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
    };

    if (otherUserLocation != null && hasConsentToShareLocation) {
      markers.add(
        Marker(
          markerId: const MarkerId("otherUserLocation"),
          position: otherUserLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    return markers;
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

  void _showUserRoute() {
    setState(() {
      showPolyline = true;
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
              target: userLocation ?? LatLng(18.4796, -69.8908),
              zoom: 6.0,
            ),
            polylines: {
              if (showPolyline)
                Polyline(
                  polylineId: PolylineId("route"),
                  points: [userLocation!, directionCoordinates[0]],
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
            markers: _createUserMarkers(),
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
          ),
          Positioned(
            left: 6.0,
            bottom: 30.0,
            child: ElevatedButton(
              onPressed: onPanicButtonPressed,
              child: Icon(
                Icons.notifications,
                size: 20.0,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(16.0),
              ),
            ),
          ),
          Positioned(
            left: 6.0,
            bottom: 85.0,
            child: ElevatedButton(
              onPressed: onLocationButtonPressed,
              child: Icon(
                Icons.location_on,
                size: 20.0,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(15.0),
              ),
            ),
          ),
          Positioned(
            right: 1.0,
            bottom: 100.0,
            child: ElevatedButton(
              onPressed: () async {
                if (hasReceivedLocation) {
                  final permission.PermissionStatus status =
                      await permission.Permission.location.request();

                  if (status == permission.PermissionStatus.granted) {
                    await _showOtherUserLocationDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('No tienes permiso para esta función'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('No tienes permiso para esta función'),
                  ));
                }
              },
              child: Icon(
                Icons.person_2,
                size: 20.0,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
                onPrimary: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(15.0),
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
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
              ),
              child: Text(
                locationAccessGranted
                    ? 'Ubicación actualizada'
                    : 'Obtener Ubicación',
              ),
            ),
            ElevatedButton(
              onPressed: onReceiveLocationButtonPressed,
              child: Text(
                hasReceivedLocation
                    ? 'Haz recibido la ubicación'
                    : 'Recibir Ubicación',
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
