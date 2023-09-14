import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage(
      {Key? key,
      required Null Function(Map<String, dynamic> message) onSendLocation})
      : super(key: key);

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

  @override
  void initState() {
    super.initState();
    updateLocationText();
    updateDistanceText();
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

  void onReceiveLocationButtonPressed() {
    // Aquí puedes implementar la lógica para recibir ubicación.
    // Esto podría involucrar el uso de servicios de ubicación en tiempo real o intercambio de coordenadas.

    // Habilita la obtención de ubicación después de presionar el botón "Recibir Ubicación"
    setState(() {
      isLocationEnabled = true;
    });
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
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: santoDomingoLocation ?? LatLng(0, 0),
                  zoom: 6.0,
                ),
                polylines: {
                  if (showPolyline)
                    Polyline(
                      polylineId: PolylineId("route"), // ID de polilínea
                      points: [
                        santoDomingoLocation ?? LatLng(0, 0),
                        santiagoLocation ?? LatLng(0, 0),
                      ],
                      color: Colors.blue,
                      width: 6,
                    ),
                },
                markers: {
                  if (santoDomingoLocation != null)
                    Marker(
                      markerId: const MarkerId("santoDomingo"),
                      position: santoDomingoLocation!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    locationText,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    distanceText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                primary: Colors.blue, // Color de fondo del botón
                onPrimary: Colors.white, // Color del texto del botón
                padding: EdgeInsets.symmetric(
                    horizontal: 5, vertical: 5), // Ajusta el tamaño del botón
              ),
            ),
            ElevatedButton(
              onPressed: onSendLocationButtonPressed,
              child: Text("Enviar Ubicación"),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Color de fondo del botón
                onPrimary: Colors.white, // Color del texto del botón
                padding: EdgeInsets.symmetric(
                    horizontal: 0.5,
                    vertical: 0.5), // Ajusta el tamaño del botón
              ),
            ),
            ElevatedButton(
              onPressed: onReceiveLocationButtonPressed,
              child: Text("Recibir Ubicación"),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Color de fondo del botón
                onPrimary: Colors.white, // Color del texto del botón
                padding: EdgeInsets.symmetric(
                    horizontal: 5, vertical: 5), // Ajusta el tamaño del botón
              ),
            ),
          ],
        ),
      ),
    );
  }
}
