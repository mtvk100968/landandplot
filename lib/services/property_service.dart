import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property_address.dart'; // Adjust the path as necessary to import PropertyAddress model

class PropertyService {
  // Method for loading properties from a local JSON file
  Future<List<dynamic>> loadProperties() async {
    String jsonString = await rootBundle.loadString('assets/properties.json');
    return jsonDecode(jsonString);
  }

  // Method for fetching properties from Firestore
  Future<List<PropertyAddress>> fetchPropertyAddressesFromFirestore(String userId) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('properties')
        .where('userId', isEqualTo: userId)
        .get();

    var propertyAddresses = querySnapshot.docs.map((doc) {
      return PropertyAddress.fromFirestore(doc);
    }).toList();

    return propertyAddresses;
  }
}
