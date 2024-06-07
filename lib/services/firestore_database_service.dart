
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/apartment_details.dart';
import '../models/cluster_item.dart';
import '../models/property_info.dart';

class FirestoreDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreDatabaseService._privateConstructor();

  static final FirestoreDatabaseService _instance =
  FirestoreDatabaseService._privateConstructor();

  factory FirestoreDatabaseService() {
    return _instance;
  }

  Future<void> addOrUpdateProperty(String propertyId, Map<String, dynamic> data, String propertyType) async {
    await _firestore
        .collection('properties')
        .doc(propertyType)
        .collection('listings')
        .doc(propertyId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> deleteProperty(String propertyType, String propertyId) async {
    await _firestore
        .collection('properties')
        .doc(propertyType)
        .collection('listings')
        .doc(propertyId)
        .delete();
  }

  Future<PropertyInfo?> getPropertyById(String propertyType, String propertyId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore
          .collection('properties')
          .doc(propertyType)
          .collection('listings')
          .doc(propertyId)
          .get();
      if (docSnapshot.exists) {
        return PropertyInfo.fromJson(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting property: $e');
      return null;
    }
  }

  Future<List<PropertyInfo>> fetchAllProperties() async {
    List<PropertyInfo> allProperties = [];
    try {
      QuerySnapshot propertyTypesSnapshot = await _firestore.collection('properties').get();
      for (var doc in propertyTypesSnapshot.docs) {
        QuerySnapshot listingsSnapshot = await doc.reference.collection('listings').get();
        List<PropertyInfo> properties = listingsSnapshot.docs.map((doc) {
          return PropertyInfo.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
        allProperties.addAll(properties);
      }
      return allProperties;
    } catch (e) {
      print('Error fetching properties: $e');
      return [];
    }
  }

  Future<List<PropertyInfo>> fetchPropertiesByType(String propertyType) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('properties')
          .doc(propertyType)
          .collection('listings')
          .get();
      List<PropertyInfo> properties = querySnapshot.docs.map((doc) {
        return PropertyInfo.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return properties;
    } catch (e) {
      print('Error fetching properties: $e');
      return [];
    }
  }

  Future<void> addApartmentDetails(Apartment_Details apartmentDetails) async {
    try {
      Map<String, dynamic> apartmentDetailsMap = apartmentDetails.toMap()..remove('propertyId');
      DocumentReference docRef = await _firestore.collection('apartmentdetails').add(apartmentDetailsMap);
      print('Apartment details added with ID: ${docRef.id}');
      await docRef.update({'propertyId': docRef.id});
    } catch (e) {
      print('Error adding apartment details: $e');
      throw e;
    }
  }

  Stream<QuerySnapshot> getPropertiesStreamByType(String propertyType) {
    return _firestore.collection('properties')
        .doc(propertyType)
        .collection('listings')
        .snapshots();
  }

  Future<List<PropertyInfo>> queryPropertiesByPriceRange(String propertyType, double minPrice, double maxPrice) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('properties')
        .doc(propertyType)
        .collection('listings')
        .where('price', isGreaterThanOrEqualTo: minPrice)
        .where('price', isLessThanOrEqualTo: maxPrice)
        .get();
    return querySnapshot.docs.map((doc) => PropertyInfo.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Apartment_Details>> retrieveApartmentsByCity(String city) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('apartmentdetails')
        .where('city', isEqualTo: city)
        .orderBy('pincode')
        .orderBy('district')
        .orderBy('state')
        .get();
    return querySnapshot.docs
        .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Apartment_Details>> retrieveApartmentsByDistrict(String district) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('apartmentdetails')
        .where('district', isEqualTo: district)
        .orderBy('pincode')
        .orderBy('city')
        .orderBy('state')
        .get();
    return querySnapshot.docs
        .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Apartment_Details>> retrieveApartmentsByPincode(String pincode) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('apartmentdetails')
        .where('pincode', isEqualTo: pincode)
        .orderBy('city')
        .orderBy('district')
        .orderBy('state')
        .get();
    return querySnapshot.docs
        .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Apartment_Details>> retrieveApartmentsByState(String state) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('apartmentdetails')
        .where('state', isEqualTo: state)
        .orderBy('pincode')
        .orderBy('city')
        .orderBy('district')
        .get();
    return querySnapshot.docs
        .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> markPropertyForDeletion(String propertyType, String propertyId, String requestedBy) async {
    await _firestore.collection('properties')
        .doc(propertyType)
        .collection('listings')
        .doc(propertyId)
        .update({
      'pendingDeletion': true,
      'deletionRequestedBy': requestedBy,
      'deletionRequestedAt': FieldValue.serverTimestamp()
    });
  }

  Future<void> requestPropertyDeletion(String propertyType, String propertyId, String userId) async {
    await markPropertyForDeletion(propertyType, propertyId, userId);
    print('Deletion requested for property $propertyId by user $userId');
  }

  Future<void> approvePropertyDeletion(String propertyType, String propertyId) async {
    await _firestore.collection('properties')
        .doc(propertyType)
        .collection('listings')
        .doc(propertyId)
        .update({
      'pendingDeletion': false,
      'approvedForDeletion': true,
      'deletionApprovedAt': FieldValue.serverTimestamp()
    });
  }

  Future<List<ClusterItem>> getClusterItems() async {
    QuerySnapshot snapshot = await _firestore.collection('properties').get();
    return snapshot.docs.map((doc) => ClusterItem.fromFirestore(doc)).toList();
  }
}