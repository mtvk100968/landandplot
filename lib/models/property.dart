// property.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Property {
  final String propertyId;
  final String propertyType;
  final double price;
  final LatLng location;

  Property({
    required this.propertyId,
    required this.propertyType,
    required this.price,
    required this.location,
  });

  factory Property.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Property(
      propertyId: doc.id,
      propertyType: data['propertyType'],
      price: data['price'].toDouble(),
      location:
          LatLng(data['location']['latitude'], data['location']['longitude']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'price': price,
      'location': {'lat': location.latitude, 'lng': location.longitude},
    };
  }
}
