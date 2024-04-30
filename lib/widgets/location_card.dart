// location_card.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationCard extends StatelessWidget {
  final LatLng initialPosition;
  final double height;
  final double width;
  final Function(GoogleMapController) onMapCreated;

  const LocationCard({
    Key? key,
    required this.initialPosition,
    required this.height,
    required this.width,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        height: height,
        width: width,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 12,
          ),
          onMapCreated: onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          // Add more properties as per your requirement
        ),
      ),
    );
  }
}
