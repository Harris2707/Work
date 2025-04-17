import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(13.0827, 80.2707); // Chennai

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Map"), backgroundColor: Colors.teal),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('home'),
            position: _center,
            infoWindow: const InfoWindow(title: 'Chennai'),
          ),
        },
      ),
    );
  }
}


/* 
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0


In android/app/src/main/AndroidManifest.xml, inside the <application> tag, add:

<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY"/>
Replace YOUR_API_KEY with your actual Google Maps API key.
*/