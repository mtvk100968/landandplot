// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class PropertyPrice {
//   final int year;
//   final double price;
//
//   PropertyPrice(this.year, this.price);
//
//   // Method to fetch property prices from Firestore
//   static Future<List<PropertyPrice>> fetchPropertyPrices() async {
//     // Fetch data from Firestore and convert to PropertyPrice list
//     // Example Firestore structure: collection 'propertyPrices' with documents having 'year' and 'price' fields
//     List<PropertyPrice> prices = [];
//     final snapshot = await FirebaseFirestore.instance.collection('propertyPrices').get();
//     for (var doc in snapshot.docs) {
//       prices.add(PropertyPrice(doc['year'], doc['price']));
//     }
//     return prices;
//   }
// }

class PropertyPrice {
  final int year;
  final double price;

  PropertyPrice({
    required this.year,
    required this.price,
  });

  factory PropertyPrice.fromMap(Map<String, dynamic> map) {
    return PropertyPrice(
      year: map['year'],
      price: map['price'],
    );
  }
}
