// Define the Clusterable interface
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:landandplot/models/property_address.dart';

// // Define the Clusterable interface
// abstract class Clusterable {
//   double get latitude;
//   double get longitude;
//   String get id;
//   BitmapDescriptor get icon;
//   bool get isCluster;
//   int get clusterId;
//   int get pointsSize;
//   String get childMarkerId;
//   String get price;
//   String get userId;
//
// // Define other necessary methods and properties here
// }
//
// // Implement the Clusterable interface in ClusterItem class
// class ClusterItem implements Clusterable {
//   @override
//   final double latitude;
//
//   @override
//   final double longitude;
//
//   @override
//   final String id;
//
//   @override
//   final BitmapDescriptor icon;
//
//   @override
//   final bool isCluster;
//
//   @override
//   final int clusterId;
//
//   @override
//   final int pointsSize;
//
//   @override
//   final String childMarkerId;
//
//   @override
//   final String price;
//
//   @override
//   String _userId; // Make sure to remove 'late' if you are initializing it through the constructor
//
//   ClusterItem({
//     required this.latitude,
//     required this.longitude,
//     required this.id,
//     required this.icon,
//     this.isCluster = false,
//     this.clusterId = 0,
//     this.pointsSize = 0,
//     this.childMarkerId = '',
//     this.price = '',
//     required String userId,
//   }) : _userId = userId;
//
//   // Getter implementation for userId
//   @override
//   String get userId => _userId;
//
//   // Setter implementation for userId
//   @override
//   set userId(String value) {
//     _userId = value;
//   }
//
//   factory ClusterItem.fromSnapshot(DocumentSnapshot snapshot) {
//     final data = snapshot.data() as Map<String, dynamic>;
//     return ClusterItem(
//       id: snapshot.id,
//       latitude: data['latitude'] ?? 0.0,
//       longitude: data['longitude'] ?? 0.0,
//       icon: BitmapDescriptor.defaultMarker, // You'll need to convert an image to BitmapDescriptor if you have a custom icon
//       isCluster: data['isCluster'] ?? false,
//       clusterId: data['clusterId'] ?? 0,
//       pointsSize: data['pointsSize'] ?? 0,
//       childMarkerId: data['childMarkerId'] ?? '',
//       price: data['price'] ?? '',
//       userId: data['userId'] ?? '',
//     );
//   }
//
//   // This is a method that converts PropertyAddress to ClusterItem
// // This would be called when you are building your cluster items for display on the map
//   Future<ClusterItem> convertToClusterItem(PropertyAddress address) async {
//     return ClusterItem(
//       latitude: address.latitude,
//       longitude: address.longitude,
//       id: address.propertyId,
//       icon: await address.getIcon(),
//       isCluster: false,
//       clusterId: 0,
//       pointsSize: 0,
//       childMarkerId: '',
//       price: address.price,
//       userId: address.userId,
//     );
//   }
//
// // Other methods or additional code can be added here as needed
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class ClusterItem {
//   final String id;
//   final double latitude;
//   final double longitude;
//   final BitmapDescriptor icon;
//   final bool isCluster;
//   final int clusterId;
//   final int pointsSize;
//   final String childMarkerId;
//   final String price;
//   late String userId;
//
//   ClusterItem({
//     required this.id,
//     required this.latitude,
//     required this.longitude,
//     required this.icon,
//     this.isCluster = false,
//     this.clusterId = 0,
//     this.pointsSize = 0,
//     this.childMarkerId = '',
//     this.price = '',
//     required this.userId,
//   });
//
//   // Factory constructor to create ClusterItem from Firestore snapshot
//   factory ClusterItem.fromSnapshot(DocumentSnapshot snapshot) {
//     final data = snapshot.data() as Map<String, dynamic>;
//     return ClusterItem(
//       id: snapshot.id,
//       latitude: data['latitude'] ?? 0.0,
//       longitude: data['longitude'] ?? 0.0,
//       // Assuming you have stored the icon URL in Firestore and convert it to BitmapDescriptor
//       icon: BitmapDescriptor.defaultMarker, // Example: You can use Firebase Storage to store icons and retrieve them here
//       isCluster: data['isCluster'] ?? false,
//       clusterId: data['clusterId'] ?? 0,
//       pointsSize: data['pointsSize'] ?? 0,
//       childMarkerId: data['childMarkerId'] ?? '',
//       price: data['price'] ?? '',
//       userId: data['userId'] ?? '',
//     );
//   }
// }
//

class ClusterItem implements Clusterable {
  final double latitude;
  final double longitude;
  final String id;
  final String iconPath; // Add iconPath variable
  late String _userId; // Define _userId
  late String _price;
  late String _markerId;
  late int _clusterId;
  late bool _isCluster;
  late int _pointsSize;
  late String _childMarkerId;

  ClusterItem({
    required this.latitude,
    required this.longitude,
    required this.id,
    required this.iconPath,
    required String userId, // Add userId parameter
    String? price,
    int? clusterId,
    bool? isCluster,
    int? pointsSize,
    String? childMarkerId,
    String? markerId,
  })  : _userId = userId,
        _clusterId = clusterId ?? 0,
        _isCluster = isCluster ?? false,
        _pointsSize = pointsSize ?? 0,
        _childMarkerId = childMarkerId ?? '',
        _price = price ?? '',
        _markerId = markerId ?? '';

  // Implement the remaining getters
  @override
  String get userId => _userId;

  @override
  String get markerId => _markerId;

  @override
  String get price => _price;

  @override
  BitmapDescriptor get icon => BitmapDescriptor.defaultMarker;

  @override
  bool get isCluster => _isCluster;

  @override
  int get clusterId => _clusterId;

  @override
  int get pointsSize => _pointsSize;

  @override
  String get childMarkerId => _childMarkerId;

  // Implement the setters
  @override
  set clusterId(int? value) {
    _clusterId = value ?? 0;
  }

  @override
  set isCluster(bool? value) {
    _isCluster = value ?? false;
  }

  @override
  set pointsSize(int? value) {
    _pointsSize = value ?? 0;
  }

  @override
  set childMarkerId(String? value) {
    _childMarkerId = value ?? '';
  }

  @override
  set price(String? value) {
    _price = value ?? '';
  }

  @override
  set userId(String? value) {
    _userId = value ?? '';
  }

  @override
  set latitude(double? value) {
    // Implement setter if needed
  }

  @override
  set longitude(double? value) {
    // Implement setter if needed
  }

  @override
  set markerId(String? value) {
    _markerId = value ?? '';
  }

  // Factory constructor for creating ClusterItem from snapshot
  factory ClusterItem.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ClusterItem(
      id: snapshot.id,
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      userId: data['userId'] ?? '',
      price: data['price'] ?? 0.0,
      iconPath: data['iconPath'] ??
          'default_icon_path', // Assign a default icon path if not provided
    );
  }

  // Method to convert PropertyAddress to ClusterItem
  factory ClusterItem.convertPropertyAddressToClusterItem(
      PropertyAddress property) {
    return ClusterItem(
      id: property.propertyId,
      iconPath: property.iconPath,
      latitude: property.latitude,
      longitude: property.longitude,
      price: property.price,
      userId: property.userId,
    );
  }
}
