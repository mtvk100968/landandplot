import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyMasterCard {
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
  final Map<String, bool> basicAmenities;
  final Map<String, bool> luxuryAmenities;
  final int fans;
  final int geysers;
  final int tvs;
  final int diningTables;
  final int sofaSets;
  final int interComs;
  final int ovens;
  final int waterFilters;
  final int wardrobes;
  final int dishWashers;
  final int washingMachines;

  PropertyMasterCard({
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
    required this.basicAmenities,
    required this.luxuryAmenities,
    required this.fans,
    required this.geysers,
    required this.tvs,
    required this.diningTables,
    required this.sofaSets,
    required this.interComs,
    required this.ovens,
    required this.waterFilters,
    required this.wardrobes,
    required this.dishWashers,
    required this.washingMachines,
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
      'basicAmenities': basicAmenities,
      'luxuryAmenities': luxuryAmenities,
      'fans': fans,
      'geysers': geysers,
      'tvs': tvs,
      'diningTables': diningTables,
      'sofaSets': sofaSets,
      'interComs': interComs,
      'ovens': ovens,
      'waterFilters': waterFilters,
      'wardrobes': wardrobes,
      'dishWashers': dishWashers,
      'washingMachines': washingMachines,
    };
  }

  factory PropertyMasterCard.fromMap(Map<String, dynamic> map) {
    return PropertyMasterCard(
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
      basicAmenities: Map<String, bool>.from(map['basicAmenities']),
      luxuryAmenities: Map<String, bool>.from(map['luxuryAmenities']),
      fans: map['fans'],
      geysers: map['geysers'],
      tvs: map['tvs'],
      diningTables: map['diningTables'],
      sofaSets: map['sofaSets'],
      interComs: map['interComs'],
      ovens: map['ovens'],
      waterFilters: map['waterFilters'],
      wardrobes: map['wardrobes'],
      dishWashers: map['dishWashers'],
      washingMachines: map['washingMachines'],
    );
  }

  Future<void> saveToFirestore() async {
    CollectionReference properties =
    FirebaseFirestore.instance.collection('properties');

    await properties.doc(propertyId).set(toMap());
  }

// ... other methods, such as retrieval methods ...
}
