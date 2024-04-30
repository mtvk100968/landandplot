// agriculture_land_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AgricultureLandDetails {
  final String propertyId;
  final double pricePerAcre;
  final double totalAcres;
  final double price;
  final String village;
  final String colony;
  final String tmc;
  final String city;
  final String district;
  final String state;
  final double pincode;

// ...other fields

  AgricultureLandDetails({
    required this.propertyId,
    required this.pricePerAcre,
    required this.totalAcres,
    required this.price,
    required this.village,
    required this.colony,
    required this.tmc,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
    // ...other fields
  });

  Map<String, dynamic> toMap() {
    return {
      'propertyId': propertyId,
      'pricePerAcre': pricePerAcre,
      'totalAcres': totalAcres,
      'price': price,
      'village': village,
      'colony': colony,
      'tmc': tmc,
      'city': city,
      'district': district,
      'state': state,
      'pincode': pincode,
      // ...other fields
    };
  }

  factory AgricultureLandDetails.fromMap(Map<String, dynamic> map) {
    return AgricultureLandDetails(
      propertyId: map['propertyId'],
      pricePerAcre: map['pricePerAcre'],
      totalAcres: map['totalAcres'],
      price: map['price'],
      village: map['village'],
      colony: map['colony'],
      tmc: map['tmc'],
      city: map['city'],
      district: map['district'],
      state: map['state'],
      pincode: map['pincode'],
      // ...other fields
    );
  }

  // Define the generatePropertyId method within the class
  String generatePropertyId(String stateCode, String districtCode, String tmcCode, int count) {
    String formattedCount = count.toString().padLeft(10, '0');
    return '$stateCode$districtCode$tmcCode$formattedCount';
  }



  // Future<void> saveToFirestore() async {
  //   // Reference a new collection specifically for agriculture land details
  //   CollectionReference agricultureLandDetailsCollection = FirebaseFirestore.instance.collection('agriculturelanddetails');
  //
  //   try {
  //     // Firestore generates a unique ID for each new document
  //     DocumentReference newDocRef = agricultureLandDetailsCollection.doc();
  //
  //     // Use your custom propertyId format (make sure it's unique for each property)
  //     String propertyId = 'AGLAND' + DateTime.now().millisecondsSinceEpoch.toString();
  //
  //     Map<String, dynamic> agricultureLandDetailsMap = toMap();
  //     agricultureLandDetailsMap['propertyId'] = propertyId; // Use the unique propertyId
  //     agricultureLandDetailsMap['propertyType'] = 'AgricultureLandDetails';
  //
  //     // Set the data in the new document
  //     await newDocRef.set(agricultureLandDetailsMap);
  //     print("Agriculture land property successfully added to Firestore with ID: ${newDocRef.id}");
  //   } catch (e) {
  //     print("Failed to add agriculture land property: $e");
  //   }
  // }

  Future<void> saveToFirestore() async {
    // Get a reference to the 'agriculturelanddetails' collection
    CollectionReference agricultureLandDetailsCollection =
    FirebaseFirestore.instance.collection('agriculturelanddetails');

    try {
      // Generate a new document ID or use an existing one
      String documentId = propertyId.isNotEmpty ? propertyId :
      agricultureLandDetailsCollection.doc().id;

      // Save the details map to the Firestore document
      await agricultureLandDetailsCollection
          .doc(documentId)
          .set(this.toMap());

      print("Agriculture land property successfully added to Firestore with ID: $documentId");
    } catch (e) {
      print("Failed to add agriculture land property: $e");
      throw e; // Rethrow the exception to handle it in the UI
    }
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AgricultureLandDetails>> retrievePropertiesByCity(String city) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('agriculturelanddetails')
      .where('city', isEqualTo: city)
      .get();

  return querySnapshot.docs
      .map((doc) => AgricultureLandDetails.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
  }

  Future<List<AgricultureLandDetails>> retrievePropertiesByTMC(String tmc) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('agriculturelanddetails')
      .where('tmc', isEqualTo: tmc)
      .get();

  return querySnapshot.docs
      .map((doc) => AgricultureLandDetails.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
  }

  Future<List<AgricultureLandDetails>> retrievePropertiesByPincode(String pincode) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('agriculturelanddetails')
      .where('pincode', isEqualTo: pincode)
      .get();

  return querySnapshot.docs
      .map((doc) => AgricultureLandDetails.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
  }
}
