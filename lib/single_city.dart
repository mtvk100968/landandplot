// single_city.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class SingleCity extends StatefulWidget {

  final Map cityData;
  const SingleCity({Key? key, required this.cityData}) : super(key: key);

  @override
  State<SingleCity> createState() => _SingleCityState();
}

class _SingleCityState extends State<SingleCity> {
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _markers.clear();

    // Request location permission
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, now try to get the current location.
      final currentPosition = await _getCurrentLocation();
      if (currentPosition != null) {
        setState(() {
          final marker = Marker(
            markerId: MarkerId(widget.cityData['id']),
            position: LatLng(widget.cityData['lat'], widget.cityData['lng']),
            infoWindow: InfoWindow(
              title: widget.cityData['name'],
              snippet: widget.cityData['address'],
            ),
          );
          _markers[widget.cityData['name']] = marker;

          // Launch directions from the user's current location to the destination
          _launchMapFromCurrentLocation(currentPosition, widget.cityData);
        });
      } else {
        // Handle the case where the current location couldn't be determined.
        print("Current location not available.");
      }
    } else {
      // Handle permission denied.
      print("Location permission denied.");
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      print("Error getting current location: $e");
      return null;
    }
  }

  void _launchMapFromCurrentLocation(
      Position? currentPosition, Map cityData) {
    if (currentPosition != null) {
      final lat = currentPosition.latitude;
      final lng = currentPosition.longitude;
      if (lat != null && lng != null) {
        MapsLauncher.launchCoordinates(lat, lng);
      } else {
        print("Latitude or longitude is null.");
      }
    } else {
      print("Current position is null.");
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, now try to get the current location.
      final currentPosition = await _getCurrentLocation();
      // Rest of your code...
      print("Location permission granted.");

    } else {
      // Handle permission denied.
      print("Location permission denied.");
    }
  }

  launchMap(double? lat, double? lng) {
    if (lat != null && lng != null) {
      MapsLauncher.launchCoordinates(lat, lng);
    } else {
      // Handle the case where lat or lng is null (e.g., show an error message).
      print("Latitude or longitude is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About ${widget.cityData['name']}')),
      body: Column(
        children: [
          Card(
            elevation: 5,
            child: Column(
              children: [
                Image.network(
                  widget.cityData['image'],
                  height: 200,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.cityData['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        launchMap(widget.cityData['lat'], widget.cityData['lng']);
                      },
                      child: const Text("Direction"),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.cityData['lat'], widget.cityData['lng']),
                zoom: 12,
              ),
              markers: _markers.values.toSet(),
            ),
          )
        ],
      ),
    );
  }
}


