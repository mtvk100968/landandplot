// apartment_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Apartment_Details {
  final String propertyId;
  final double mobileNo;
  final String propertyName;
  final double rentPerMonth;
  final double totalArea;
  final double carpetArea;
  final double advanceRent;
  final double bedRooms;
  final double bathRooms;
  final double balConies;
  final String houseNo;
  final String colony;
  final String tmc;
  final String city;
  final String district;
  final String state;
  final double pincode;

// ...other fields

  Apartment_Details({
    required this.propertyId,
    required this.mobileNo,
    required this.propertyName,
    required this.rentPerMonth,
    required this.totalArea,
    required this.carpetArea,
    required this.advanceRent,
    required this.bedRooms,
    required this.bathRooms,
    required this.balConies,
    required this.houseNo,
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
      'mobileNo': mobileNo,
      'propertyName': propertyName,
      'rentPerMonth': rentPerMonth,
      'totalArea': totalArea,
      'carpetArea': carpetArea,
      'advanceRent': advanceRent,
      'bedRooms': bedRooms,
      'bathRooms': bathRooms,
      'balConies': balConies,
      'houseNo': houseNo,
      'colony': colony,
      'tmc': tmc,
      'city': city,
      'district': district,
      'state': state,
      'pincode': pincode,
      // ...other fields
    };
  }

  factory Apartment_Details.fromMap(Map<String, dynamic> map) {
    return Apartment_Details(
      propertyId: map['propertyId'],
      mobileNo: map['mobileNo'],
      propertyName: map['propertyName'],
      rentPerMonth: map['rentPerMonth'],
      totalArea: map['totalArea'],
      carpetArea: map['carpetArea'],
      advanceRent: map['advanceRent'],
      bedRooms: map['bedRooms'],
      bathRooms: map['bathRooms'],
      balConies: map['balConies'],
      houseNo: map['houseNo'],
      colony: map['colony'],
      tmc: map['tmc'],
      city: map['city'],
      district: map['district'],
      state: map['state'],
      pincode: map['pincode'],
      // ...other fields
    );
  }

  String generatePropertyId(String stateCode, String districtCode, String tmcCode, int count) {
    String formattedCount = count.toString().padLeft(10, '0');
    return '$stateCode$districtCode$tmcCode$formattedCount';
  }

  Future<void> saveToFirestore() async {
    // Get a reference to the 'agriculturelanddetails' collection
    CollectionReference agricultureLandDetailsCollection =
    FirebaseFirestore.instance.collection('apartmentdetails');

    try {
      // Generate a new document ID or use an existing one
      String documentId = propertyId.isNotEmpty ? propertyId :
      agricultureLandDetailsCollection.doc().id;

      // Save the details map to the Firestore document
      await agricultureLandDetailsCollection
          .doc(documentId)
          .set(this.toMap());// Set the data in Firestore
      print("Apartment property successfully added to Firestore with ID: $propertyId");
    } catch (e) {
      print("Failed to add apartment property: $e");
    }
  }

  // Generate a property ID based on specific criteria
  // String generatePropertyId(String prefix, int count) {
  //   String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //   return '$prefix$timestamp$count'.padLeft(10, '0');
  // }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Retrieve ApartmentDetails by pincode
  Future<List<Apartment_Details>> retrievePropertiesByPincode(double pincode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('apartmentdetails')
        .where('pincode', isEqualTo: pincode)
        .get();

    return querySnapshot.docs
        .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Retrieve ApartmentDetails by TMC
  Future<List<Apartment_Details>> retrievePropertiesByTMC(String tmc) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('apartmentdetails')
        .where('tmc', isEqualTo: tmc)
        .get();

    return querySnapshot.docs
        .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Retrieve ApartmentDetails by city
  Future<List<Apartment_Details>> retrievePropertiesByCity(String city) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('apartmentdetails')
        .where('city', isEqualTo: city)
        .get();

    return querySnapshot.docs
        .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}