//     property_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyDetails {
  final String id;
  final String imageUrl;
  final double totalArea;
  final double carpetArea;
  final double rent;
  final String title;

  final String address;
  final String propertyType;
  final String bedrooms;
  final String bathrooms;


  PropertyDetails({
    required this.id,
    required this.imageUrl,
    required this.totalArea,
    required this.carpetArea,
    required this.rent,
    required this.title,
    required this.address,
    required this.propertyType,
    required this.bedrooms,
    required this.bathrooms,
  });

  static Map<String, PropertyDetails> fetchPropertyDetailsMap() {
    // Your implementation here
    return {
      '1': PropertyDetails(
          id: '1',
          rent: 35000,
          address: ' Jain silpa cyber view\nMain road Gachibowli\n500032',
          propertyType: 'Apartment',
          bedrooms: '2',
          bathrooms: '2',
          totalArea: 1800, imageUrl: '', carpetArea: 1500, title: ''
      ),
      '2': PropertyDetails(
        id: '2',
          rent: 60000,
          address: 'jain silpa cyber view, Main road Gachibowli',
          propertyType: 'Apartment',
          bedrooms: '3',
          bathrooms: '3',
          totalArea: 1800, imageUrl: '', carpetArea: 1600, title: ''
      ),
      '3': PropertyDetails(
        id: '2',
          rent: 75000,
          address: 'jain silpa cyber view, Main road Gachibowli',
          propertyType: 'Duplex',
          bedrooms: '3',
          bathrooms: '3',
          totalArea: 2800, imageUrl: '', carpetArea: 2000, title: ''
      ),
      '4': PropertyDetails(
          id: '4',
          rent: 70000,
          address: 'jain silpa cyber view, Main road Gachibowli',
          propertyType: 'Villa',
          bedrooms: '3',
          bathrooms: '3',
          totalArea: 2500, imageUrl: '', carpetArea: 1800, title: ''
      ),
      // Add more properties as needed
    };
  }


  factory PropertyDetails.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PropertyDetails(
      id: doc.id,
      imageUrl: data['imageUrl'] as String? ?? '',
      totalArea: (data['totalArea'] as num?)?.toDouble() ?? 0.0,
      carpetArea: (data['carpetArea'] as num?)?.toDouble() ?? 0.0,
      rent: (data['rent'] as num?)?.toDouble() ?? 0.0,
      title: data['title'] as String? ?? '',
      address: data['address'] as String? ?? '',
      propertyType: data['propertyType'] as String? ?? '',
      bedrooms: data['bedrooms'].toString(),
      bathrooms: data['bathrooms'].toString(),
    );
  }
}
