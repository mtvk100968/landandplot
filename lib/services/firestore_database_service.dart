// firestore_database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:landandplot/models/property_address.dart';

import '../models/agriculture_land_details.dart';
import '../models/apartment_details.dart';
import '../property_custom_icon.dart'; // Your PropertyAddress model

class FirestoreDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PropertyAddress?> getPropertyById(String propertyId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('properties').doc(propertyId).get();
      if (docSnapshot.exists) {
        // Assuming your PropertyAddress model has a fromJson constructor
        return PropertyAddress.fromJson(
            docSnapshot.data() as Map<String, dynamic>);
      }
      return null; // Property not found
    } catch (e) {
      print('Error getting property: $e'); // Replace with proper error handling
      return null;
    }
  }

  // Stream<List<Property>> getProperties() {
  //   return _firestore.collection('properties').snapshots().map(
  //         (snapshot) => snapshot.docs
  //         .map((doc) => Property.fromFirestore(doc))
  //         .toList(),
  //   );
  // }

  // Define the method to fetch properties from Firestore
  Future<List<PropertyAddress>> fetchProperties() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('properties').get();
      List<PropertyAddress> properties = querySnapshot.docs.map((doc) {
        return PropertyAddress.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return properties;
    } catch (e) {
      print('Error fetching properties: $e');
      return [];
    }
  }

  Future<void> addAgricultureLandDetails(
      AgricultureLandDetails landDetails) async {
    try {
      // Remove the 'propertyId' from the map if Firestore is generating the ID
      Map<String, dynamic> landDetailsMap = landDetails.toMap()
        ..remove('propertyId');

      DocumentReference docRef = await _firestore
          .collection('agriculturelanddetails')
          .add(landDetailsMap);
      print('Agriculture land details added with ID: ${docRef.id}');
      // Optionally, update the document with the generated ID if needed
      await docRef.update({'propertyId': docRef.id});
    } catch (e) {
      print('Error adding agriculture land details: $e');
      throw e; // You may want to throw the error to handle it in the calling function
    }
  }

  // Function to write data to Firestore
  Future<void> addOrUpdateProperty(
      String propertyId, Map<String, dynamic> propertyData) async {
    await _firestore.collection('properties').doc(propertyId).set(propertyData);
  }

  // Function to delete a property from Firestore
  Future<void> deleteProperty(String propertyId) async {
    await _firestore.collection('properties').doc(propertyId).delete();
  }

  // Function to listen to a Firestore stream for real-time updates
  Stream<QuerySnapshot> getPropertiesStream() {
    return _firestore.collection('properties').snapshots();
  }

  // Query functions for specific collections or documents
  // Add more query functions as needed, for example:
  Future<List<PropertyAddress>> queryPropertiesByPriceRange(
      double minPrice, double maxPrice) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('properties')
        .where('price', isGreaterThanOrEqualTo: minPrice)
        .where('price', isLessThanOrEqualTo: maxPrice)
        .get();
    return querySnapshot.docs
        .map((doc) =>
            PropertyAddress.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Apartment_Details>> retrieveApartmentsByCity(String city) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('apartmentdetails')
        .where('city', isEqualTo: city)
        .get();

    return querySnapshot.docs
        .map((doc) =>
            Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Apartment_Details>> retrieveApartmentsByDistrict(
      String district) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('apartmentdetails')
        .where('district', isEqualTo: district)
        .get();

    return querySnapshot.docs
        .map((doc) =>
            Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Apartment_Details>> retrieveApartmentsByPincode(
      String pincode) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('apartmentdetails')
        .where('pincode', isEqualTo: pincode)
        .get();

    return querySnapshot.docs
        .map((doc) =>
            Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
