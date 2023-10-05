import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:permission_handler/permission_handler.dart';

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

  LatLng? santoDomingoLocation; // Coordenada de Santo Domingo
  LatLng? santiagoLocation; // Coordenada de Santiago

  String locationText = '';
  String distanceText = '';
  bool showPolyline = false; // Controla si se deben mostrar los polígonos
  bool isLocationEnabled =
      false; // Controla si se habilita la obtención de ubicación

  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  // Define the initial coordinates for the static direction line
  List<LatLng> directionCoordinates = [
    LatLng(18.4796, -69.8908),
    LatLng(19.4517000, -70.6970300),
  ];

  // Define the initial coordinates for the moving polyline
  List<LatLng> movingCoordinates = [
    LatLng(18.4796, -69.8908), // Starting point
  ];

  late StreamSubscription<int> timerSubscription;
  int updateInterval = 5000; // Update every 5 seconds

  bool isButtonSoundEnabled =
      true; // Controla si se debe reproducir el sonido al presionar los botones

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
      // Define las coordenadas de Santo Domingo y Santiago cuando se presiona el botón
      santoDomingoLocation = LatLng(18.4796, -69.8908);
      santiagoLocation = LatLng(19.4517000, -70.6970300);

      // Muestra los polígonos
      setState(() {
        showPolyline = true;
      });
    }
  }

  void onSendLocationButtonPressed() {
    // Aquí puedes implementar la lógica para enviar ubicación.
    // Esto podría involucrar el uso de servicios de ubicación en tiempo real o intercambio de coordenadas.
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
    // Aquí puedes implementar la lógica para recibir ubicación.
    // Esto podría involucrar el uso de servicios de ubicación en tiempo real o intercambio de coordenadas.

    // Habilita la obtención de ubicación después de presionar el botón "Recibir Ubicación"
    setState(() {
      isLocationEnabled = true;
    });
  }

  void onPanicButtonPressed() {
    // Play the alert sound when the Panic button is pressed
    if (isButtonSoundEnabled) {
      playAlertSound();
    }

    // Your logic for the Panic button (if any)
  }

  void startMovingPolyline() {
    timerSubscription = Stream.periodic(
      Duration(milliseconds: updateInterval),
      (iteration) => iteration,
    ).listen((_) {
      // Update the coordinates of the moving polyline
      if (movingCoordinates.isNotEmpty) {
        final List<LatLng> updatedCoordinates = movingCoordinates.map((coord) {
          return LatLng(
            coord.latitude + 0.01, // Update latitude
            coord.longitude + 0.01, // Update longitude
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
              target: santoDomingoLocation ?? LatLng(0, 0),
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
          // Notification button (Panic button)
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
          // Live Location button
          Positioned(
            left: 6.0,
            bottom: 85.0,
            child: ElevatedButton(
              onPressed: () async {
                // Solicita permiso para acceder a la ubicación en vivo
                final status = await Permission.location.request();

                if (status == PermissionStatus.granted) {
                  // El usuario concedió permiso, aquí puedes implementar la lógica para acceder a la ubicación en vivo.
                } else {
                  // El usuario no concedió permiso, puedes mostrar un mensaje de error o realizar alguna otra acción.
                }
              },
              child: Icon(
                Icons.location_on,
                size: 20.0,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10.0),
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
              onPressed: onSendLocationButtonPressed,
              child: Text("Enviar Ubicación"),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 0.5,
                  vertical: 0.5,
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
