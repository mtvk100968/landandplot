
// open_plot_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class OpenPlotDetails {
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

  OpenPlotDetails({
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

  factory OpenPlotDetails.fromMap(Map<String, dynamic> map) {
    return OpenPlotDetails(
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
    // Implementation should ensure that count is always incremented to maintain uniqueness
    String formattedCount = count.toString().padLeft(10, '0');
    return '$stateCode$districtCode$tmcCode$formattedCount';
  }

  Future<void> saveToFirestore() async {
    CollectionReference openPlotCollection = FirebaseFirestore.instance.collection('openplotdetails');

    // Consider a better approach to generate a unique propertyId
    String propertyId = 'OPENP' + DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference docRef = openPlotCollection.doc(propertyId);
    await docRef.set(this.toMap());
    print("Open plot details added with ID: $propertyId");
  }

  static Future<List<OpenPlotDetails>> retrievePropertiesByCity(String city) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('openplotdetails')
        .where('city', isEqualTo: city)
        .get();

    return querySnapshot.docs
        .map((doc) => OpenPlotDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<OpenPlotDetails>> retrievePropertiesByTMC(String tmc) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('openplotdetails')
        .where('tmc', isEqualTo: tmc)
        .get();

    return querySnapshot.docs
        .map((doc) => OpenPlotDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<OpenPlotDetails>> retrievePropertiesByPincode(String pincode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('openplotdetails')
        .where('pincode', isEqualTo: pincode)
        .get();

    return querySnapshot.docs
        .map((doc) => OpenPlotDetails.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
