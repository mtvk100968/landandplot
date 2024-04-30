// commercialPlotDetails = {
// 'area': _totalAreaInYardsController.text,
// 'carpetArea': _aptCarpetAreaController.text,
// 'price': _aptPriceController.text,
// 'village': _villagenameController.text,
// 'colony': _colonyController.text,
// 'tmc': _tmcController.text,
// 'city': _cityController.text,
// 'district': _districtController.text,
// 'state': _stateController.text,
// 'pincode': _pincodeController.text,


// commercial_plot_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class GatedCommunityPlotDetails {
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

  GatedCommunityPlotDetails({
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

  factory GatedCommunityPlotDetails.fromMap(Map<String, dynamic> map) {
    return GatedCommunityPlotDetails(
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
    CollectionReference gatedPlotCollection = FirebaseFirestore.instance.collection('gatedcommunityplotdetails');

    String propertyId = 'GCPLOT' + DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference docRef = gatedPlotCollection.doc(propertyId);
    await docRef.set(this.toMap());
    print("Gated community plot details added with ID: $propertyId");
  }

  static Future<List<GatedCommunityPlotDetails>> retrievePropertiesByCity(String city) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gatedcommunityplotdetails')
        .where('city', isEqualTo: city)
        .get();

    return querySnapshot.docs
        .map((doc) => GatedCommunityPlotDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<GatedCommunityPlotDetails>> retrievePropertiesByTMC(String tmc) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gatedcommunityplotdetails')
        .where('tmc', isEqualTo: tmc)
        .get();

    return querySnapshot.docs
        .map((doc) => GatedCommunityPlotDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<GatedCommunityPlotDetails>> retrievePropertiesByPincode(String pincode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gatedcommunityplotdetails')
        .where('pincode', isEqualTo: pincode)
        .get();

    return querySnapshot.docs
        .map((doc) => GatedCommunityPlotDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
