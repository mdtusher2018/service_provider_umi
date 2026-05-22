import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ════════════════════════════════════════════════════════════
//  2. Work Areas Screen (Google Maps + radius)
// ════════════════════════════════════════════════════════════

class WorkAreasScreen extends StatefulWidget {
  @override
  _WorkAreasScreenState createState() => _WorkAreasScreenState();
}

class _WorkAreasScreenState extends State<WorkAreasScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(23.8103, 90.4125); // default (Dhaka)

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    // Get location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current Location Map")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14,
        ),
        myLocationEnabled: true,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: {
          Marker(markerId: MarkerId("current"), position: _currentPosition),
        },
      ),
    );
  }
}
