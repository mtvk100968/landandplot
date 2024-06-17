import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationCard extends StatefulWidget {
  final double height;
  final double width;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;

  const LocationCard({
    Key? key,
    required this.height,
    required this.width,
    required this.latitudeController,
    required this.longitudeController,
  }) : super(key: key);

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  LatLng _initialPosition =
      LatLng(37.7749, -122.4194); // Default initial position
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, do not continue
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, do not continue
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, do not continue
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the current position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _loadingLocation = false;
    });

    // Update the map position
    if (_mapController != null) {
      _mapController.moveCamera(CameraUpdate.newLatLng(_initialPosition));
    }

    // Update the text controllers
    widget.latitudeController.text = position.latitude.toString();
    widget.longitudeController.text = position.longitude.toString();

    // Add a marker at the current position
    _onMapTapped(_initialPosition);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _markers.clear(); // Clears any existing markers
      _markers.add(Marker(
        markerId: MarkerId("selectedLocation"),
        position: position,
      ));

      // Update the text controllers
      widget.latitudeController.text = position.latitude.toString();
      widget.longitudeController.text = position.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadingLocation
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: widget.height,
            width: widget.width,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onMapTapped,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 16,
              ),
              markers: _markers, // Use the updated set of markers
              myLocationEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: true,
            ),
          );
  }
}
