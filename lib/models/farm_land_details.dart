// farm_land_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FarmLandDetails {
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

// ...other fields

  FarmLandDetails({
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
// ...other fields
    };
  }

  factory FarmLandDetails.fromMap(Map<String, dynamic> map) {
    return FarmLandDetails(
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
// ...other fields
    );
  }

  static String generatePropertyId(String stateCode, String districtCode, String tmcCode, int count) {
    String formattedCount = count.toString().padLeft(10, '0');
    return '$stateCode$districtCode$tmcCode$formattedCount';
  }

  Future<void> saveToFirestore() async {
    CollectionReference farmLandCollection = FirebaseFirestore.instance.collection('farmlanddetails');

    String propertyId = 'FALAND' + DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference docRef = farmLandCollection.doc(propertyId);
    await docRef.set(this.toMap());
    print("Farm land details added with ID: $propertyId");
  }

  static Future<List<FarmLandDetails>> retrievePropertiesByCity(String city) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('farmlanddetails')
        .where('city', isEqualTo: city)
        .get();

    return querySnapshot.docs
        .map((doc) => FarmLandDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<FarmLandDetails>> retrievePropertiesByTMC(String tmc) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('farmlanddetails')
        .where('tmc', isEqualTo: tmc)
        .get();

    return querySnapshot.docs
        .map((doc) => FarmLandDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<FarmLandDetails>> retrievePropertiesByPincode(String pincode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('farmlanddetails')
        .where('pincode', isEqualTo: pincode)
        .get();

    return querySnapshot.docs
        .map((doc) => FarmLandDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
