import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/property_info.dart';

class PropertyDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch property data from Firestore
  // Function to fetch property data from Firestore
  Future<List<PropertyInfo>> fetchProperties() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('properties').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return PropertyInfo.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Function to convert PropertyAddress objects to Marker objects
  Set<Marker> convertToMarkers(List<PropertyInfo> properties) {
    return properties.map((property) {
      return Marker(
        markerId: MarkerId(property.propertyId),
        position: LatLng(property.latitude,
            property.longitude), // Use latitude and longitude here
        icon: BitmapDescriptor
            .defaultMarker, // This should be replaced with property.getIcon() if using custom icons
        infoWindow: InfoWindow(
          // title: property.price, // Use the price field as the title of the info window
          // Add onTap logic if necessary
        ),
      );
    }).toSet();
  }
}
