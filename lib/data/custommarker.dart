import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GoogleMaps; // Import Google Maps with a prefix
//import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../property_details_display_page.dart'; // Import for Flutter Map

class CustomMarker {
  final String propertyId;
  final LatLng position;
  final BitmapDescriptor? googleMapIcon;
  final dynamic flutterMapMarker; // Use dynamic type for marker
  final VoidCallback? onTap;

  CustomMarker({
    required this.propertyId,
    required this.position,
    this.googleMapIcon,
    this.flutterMapMarker,
    this.onTap,
  });
}

// Define a function to handle marker tap events
void _onMarkerTap(BuildContext context, String propertyId) {
  // Navigate to the PropertyDetailsDisplayPage when the marker is tapped
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PropertyDetailsDisplayPage(propertyId: propertyId),
    ),
  );
}

// Create a custom marker instance
CustomMarker createCustomMarker(BuildContext context) {
  final customMarker = CustomMarker(
    propertyId: '1',
    position: const LatLng(17.070222, 78.196167),
    googleMapIcon: BitmapDescriptor.defaultMarker, // Google Maps icon
    flutterMapMarker: GoogleMaps.Marker( // Use the prefixed Marker class
      markerId: const GoogleMaps.MarkerId('1'),
      position: const LatLng(17.070222, 78.196167), // Flutter Map marker
      icon: GoogleMaps.BitmapDescriptor.defaultMarkerWithHue(GoogleMaps.BitmapDescriptor.hueAzure),
      onTap: () {
        // Handle marker tap event
        _onMarkerTap(context, '1'); // Call the _onMarkerTap function with context and propertyId
      },
    ),
  );

  return customMarker;
}
