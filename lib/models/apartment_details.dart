// apartment_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Apartment_Details {
  final String propertyId;
  final double propertyName;
  final double pricePerSft;
  final double totalArea;
  final double carpetArea;
  final double price;
  final double bedRooms;
  final double bathRooms;
  final double balConies;
  final String village;
  final String colony;
  final String tmc;
  final String city;
  final String district;
  final String state;
  final double pincode;

// ...other fields

  Apartment_Details({
    required this.propertyId,
    required this.propertyName,
    required this.pricePerSft,
    required this.totalArea,
    required this.carpetArea,
    required this.price,
    required this.bedRooms,
    required this.bathRooms,
    required this.balConies,
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
      'propertyName': propertyName,
      'pricePerSft': pricePerSft,
      'totalArea': totalArea,
      'carpetArea': carpetArea,
      'price': price,
      'bedRooms': bedRooms,
      'bathRooms': bathRooms,
      'balConies': balConies,
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

  factory Apartment_Details.fromMap(Map<String, dynamic> map) {
    return Apartment_Details(
      propertyId: map['propertyId'],
      propertyName: map['propertyName'],
      pricePerSft: map['pricePerSft'],
      totalArea: map['totalArea'],
      carpetArea: map['carpetArea'],
      price: map['price'],
      bedRooms: map['bedRooms'],
      bathRooms: map['bathRooms'],
      balConies: map['balConies'],
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

  Future<void> saveToFirestore() async {
    CollectionReference apartmentCollection = FirebaseFirestore.instance.collection('apartmentdetails');

    try {
      String propertyId = 'APART' + DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> apartmentMap = toMap();
      apartmentMap['propertyId'] = propertyId; // Use the unique propertyId
      apartmentMap['propertyType'] = 'ApartmentDetails';

      DocumentReference docRef = apartmentCollection.doc(propertyId); // Get the DocumentReference
      await docRef.set(apartmentMap); // Set the data in Firestore
      print("Apartment property successfully added to Firestore with ID: $propertyId");
    } catch (e) {
      print("Failed to add apartment property: $e");
    }
  }

  // Generate a property ID based on specific criteria
  String generatePropertyId(String prefix, int count) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return '$prefix$timestamp$count'.padLeft(10, '0');
  }

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
