// gated_community_villa_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class GatedCommunityVillaDetails {
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

  GatedCommunityVillaDetails({
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

  factory GatedCommunityVillaDetails.fromMap(Map<String, dynamic> map) {
    return GatedCommunityVillaDetails(
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
    // Implementation should ensure that count is always incremented to maintain uniqueness
    String formattedCount = count.toString().padLeft(10, '0');
    return '$stateCode$districtCode$tmcCode$formattedCount';
  }

  Future<void> saveToFirestore() async {
    CollectionReference villaCollection = FirebaseFirestore.instance.collection('gatedcommunityvilladetails');

    // Consider a better approach to generate a unique propertyId, this is just an example
    String propertyId = 'GCVILLA' + DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference docRef = villaCollection.doc(propertyId);
    await docRef.set(this.toMap());
    print("Gated community villa details added with ID: $propertyId");
  }

  static Future<List<GatedCommunityVillaDetails>> retrievePropertiesByCity(String city) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gatedcommunityvilladetails')
        .where('city', isEqualTo: city)
        .get();

    return querySnapshot.docs
        .map((doc) => GatedCommunityVillaDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<GatedCommunityVillaDetails>> retrievePropertiesByTMC(String tmc) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gatedcommunityvilladetails')
        .where('tmc', isEqualTo: tmc)
        .get();

    return querySnapshot.docs
        .map((doc) => GatedCommunityVillaDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<GatedCommunityVillaDetails>> retrievePropertiesByPincode(String pincode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gatedcommunityvilladetails')
        .where('pincode', isEqualTo: pincode)
        .get();

    return querySnapshot.docs
        .map((doc) => GatedCommunityVillaDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
