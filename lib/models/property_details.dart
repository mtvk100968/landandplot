import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyDetails {
  final String propertyId;
  final List<String> imageUrls; // Add this field
  final double totalArea;
  final double carpetArea;
  final double rent;
  final String title;
  final String address;
  final String propertyType;
  final String bedrooms;
  final String bathrooms;

  PropertyDetails({
    required this.propertyId,
    required this.imageUrls, // Add this field
    required this.totalArea,
    required this.carpetArea,
    required this.rent,
    required this.title,
    required this.address,
    required this.propertyType,
    required this.bedrooms,
    required this.bathrooms,
  });

  factory PropertyDetails.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PropertyDetails(
      propertyId: doc.id,
      imageUrls: List<String>.from(data['imageUrls'] ?? []), // Add this line
      totalArea: (data['totalArea'] ?? 0.0).toDouble(),
      carpetArea: (data['carpetArea'] ?? 0.0).toDouble(),
      rent: (data['rent'] ?? 0.0).toDouble(),
      title: data['title'] ?? '',
      address: data['address'] ?? '',
      propertyType: data['propertyType'] ?? '',
      bedrooms: data['bedrooms'] ?? '',
      bathrooms: data['bathrooms'] ?? '',
    );
  }

  static Future<Map<String, PropertyDetails>> fetchPropertyDetailsMap() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('properties').get();
    Map<String, PropertyDetails> propertyDetailsMap = {};
    for (var doc in querySnapshot.docs) {
      propertyDetailsMap[doc.id] = PropertyDetails.fromFirestore(doc);
    }
    return propertyDetailsMap;
  }
}