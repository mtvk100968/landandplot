// gated_community_apt_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class GatedCommunityAptDetails {
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

  GatedCommunityAptDetails({
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

  factory GatedCommunityAptDetails.fromMap(Map<String, dynamic> map) {
    return GatedCommunityAptDetails(
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

  static String generatePropertyId(String stateCode, String districtCode, String tmcCode, int count) {
    String formattedCount = count.toString().padLeft(10, '0');
    return '$stateCode$districtCode$tmcCode$formattedCount';
  }

  Future<void> saveToFirestore() async {
    CollectionReference gatedAptCollection = FirebaseFirestore.instance.collection('gatedcommunityaptdetails');

    String propertyId = 'GCAPT' + DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference docRef = gatedAptCollection.doc(propertyId);
    await docRef.set(this.toMap());
    print("Gated community apartment details added with ID: $propertyId");
  }

  static Future<List<GatedCommunityAptDetails>> retrievePropertiesByCity(String city) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gatedcommunityaptdetails')
        .where('city', isEqualTo: city)
        .get();

    return querySnapshot.docs
        .map((doc) => GatedCommunityAptDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<GatedCommunityAptDetails>> retrievePropertiesByTMC(String tmc) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gatedcommunityaptdetails')
        .where('tmc', isEqualTo: tmc)
        .get();

    return querySnapshot.docs
        .map((doc) => GatedCommunityAptDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<GatedCommunityAptDetails>> retrievePropertiesByPincode(String pincode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gatedcommunityaptdetails')
        .where('pincode', isEqualTo: pincode)
        .get();

    return querySnapshot.docs
        .map((doc) => GatedCommunityAptDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
