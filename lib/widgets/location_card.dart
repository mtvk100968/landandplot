import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationCard extends StatefulWidget {
  final LatLng initialPosition;
  final double height;
  final double width;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final Function(GoogleMapController) onMapCreated;

  LocationCard({
    required this.initialPosition,
    required this.height,
    required this.width,
    required this.latitudeController,
    required this.longitudeController,
    required this.onMapCreated,
  });

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: widget.height,
        width: widget.width,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.initialPosition,
            zoom: 14.0,
          ),
          onMapCreated: (controller) {
            _controller = controller;
            widget.onMapCreated(controller);
          },
          onTap: (LatLng position) {
            widget.latitudeController.text = position.latitude.toString();
            widget.longitudeController.text = position.longitude.toString();
          },
        ),
      ),
    );
  }
}
