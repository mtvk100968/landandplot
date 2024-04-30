// commercial_plot_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommercialPlotDetails {
  final String propertyId;
  final double pricePerSqy;
  final double totalYards;
  final double price;
  final String village;
  final String colony;
  final String tmc;
  final String city;
  final String district;
  final String state;
  final double pincode;
  final double latitude; // Added field
  final double longitude; // Added field
// ...other fields

  CommercialPlotDetails({
    required this.propertyId,
    required this.pricePerSqy,
    required this.totalYards,
    required this.price,
    required this.village,
    required this.colony,
    required this.tmc,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
    required this.latitude, // Initialize in constructor
    required this.longitude, // Initialize in constructor
    // ...other fields
  });

  Map<String, dynamic> toMap() {
    return {
      'propertyId': propertyId,
      'pricePerSqy': pricePerSqy,
      'totalYards': totalYards,
      'price': price,
      'village': village,
      'colony': colony,
      'tmc': tmc,
      'city': city,
      'district': district,
      'state': state,
      'pincode': pincode,
      'latitude': latitude, // Add to map
      'longitude': longitude, // Add to map
      // ...other fields
    };
  }

  factory CommercialPlotDetails.fromMap(Map<String, dynamic> map) {
    return CommercialPlotDetails(
      propertyId: map['propertyId'],
      pricePerSqy: map['pricePerSqy'],
      totalYards: map['totalYards'],
      price: map['price'],
      village: map['village'],
      colony: map['colony'],
      tmc: map['tmc'],
      city: map['city'],
      district: map['district'],
      state: map['state'],
      pincode: map['pincode'],
      latitude: map['latitude'],
      longitude: map['longitude'],

      // ...other fields
    );
  }

  // Assuming you have a method that is called when the user selects a location on the map

// Generate a property ID based on certain codes and a counter
  static String generatePropertyId(String stateCode, String districtCode, String tmcCode, int count) {
    String formattedCount = count.toString().padLeft(10, '0');
    return '$stateCode$districtCode$tmcCode$formattedCount';
  }

  // Save this CommercialPlotDetails instance to Firestore
  Future<void> saveToFirestore() async {
    try {
      CollectionReference commercialPlotCollection = FirebaseFirestore.instance.collection('commercialplotdetails');
      String propertyId = 'COMME' + DateTime.now().millisecondsSinceEpoch.toString();
      DocumentReference docRef = commercialPlotCollection.doc(propertyId);
      await docRef.set(this.toMap());
      print("Commercial plot details added with ID: $propertyId");
    } catch (e) {
      print("Failed to add commercial plot: $e");
    }
  }

  // Retrieve commercial plots by city
  static Future<List<CommercialPlotDetails>> retrievePropertiesByCity(String city) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('commercialplotdetails')
        .where('city', isEqualTo: city)
        .get();

    return querySnapshot.docs
        .map((doc) => CommercialPlotDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Retrieve commercial plots by TMC code
  static Future<List<CommercialPlotDetails>> retrievePropertiesByTMC(String tmc) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('commercialplotdetails')
        .where('tmc', isEqualTo: tmc)
        .get();

    return querySnapshot.docs
        .map((doc) => CommercialPlotDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Retrieve commercial plots by pincode
  static Future<List<CommercialPlotDetails>> retrievePropersByPincode(String pincode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('commercialplotdetails')
        .where('pincode', isEqualTo: pincode)
        .get();

    return querySnapshot.docs
        .map((doc) => CommercialPlotDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
