// cluster_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:landandplot/models/property_info.dart';

class ClusterItem implements Clusterable {
  final double latitude;
  final double longitude;
  final String propertyId;
  final BitmapDescriptor icon;
  final double price; // Ensure this is passed in all constructors
  final String propertyType; // Add propertyType field
  late final String _userId;

  late final String _markerId;
  late final int _clusterId;
  late final bool _isCluster;
  late final int _pointsSize;
  late final String _childMarkerId;

  ClusterItem({
    required this.latitude,
    required this.longitude,
    required this.propertyId,
    required this.price, // Initialize price
    required this.propertyType, // Initialize propertyType
    this.icon = BitmapDescriptor.defaultMarker,
    required String userId,
    int? clusterId,
    bool? isCluster,
    int? pointsSize,
    String? childMarkerId,
    String? markerId, required iconPath,
  })  : _userId = userId,
        _markerId = markerId ?? '',
        _clusterId = clusterId ?? 0,
        _isCluster = isCluster ?? false,
        _pointsSize = pointsSize ?? 1,
        _childMarkerId = childMarkerId ?? '';
  // Implement getters and setters as required

  // Implement the remaining getters
  @override
  String get userId => _userId;

  @override
  String get markerId => _markerId;

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
    _pointsSize = value ?? 1;
  }

  @override
  set childMarkerId(String? value) {
    _childMarkerId = value ?? '';
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

  Marker toMarker() => Marker(
    markerId: MarkerId(propertyId),
    position: LatLng(latitude, longitude),
    icon: icon,
    infoWindow: InfoWindow(
        title: userId,
        snippet:
        'Tap for more info'), // Display user ID or another relevant field
    onTap: () {
      // Actions when a marker is tapped
    },
  );

  // Factory constructor for creating ClusterItem from snapshot
  factory ClusterItem.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ClusterItem(
      propertyId: snapshot.id,
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      price: data['price'] ?? 0.0, // Ensure the price property is added
      userId: data['userId'] ?? '',
      propertyType: data['propertyType'] ?? '', // Ensure the propertyType is added
      icon: BitmapDescriptor.defaultMarker,
      iconPath: null,
    );
  }

  static ClusterItem fromPropertyInfo(PropertyInfo property) {
    return ClusterItem(
      propertyId: property.propertyId,
      latitude: property.latitude,
      longitude: property.longitude,
      price: property.price, // Ensure the price property is added
      propertyType: property.propertyType ?? 'unknown', // Ensure the propertyType is added
      userId: property.userId,
      icon: BitmapDescriptor.defaultMarker,
      iconPath: null,
    );
  }

  factory ClusterItem.fromCluster(
      BaseCluster cluster, double latitude, double longitude) {
    return ClusterItem(
      propertyId: 'cluster_${cluster.id}',
      latitude: latitude,
      longitude: longitude,
      price: 0.0, // Default price for clusters can be 0 or an aggregated value
      propertyType: '', // Default propertyType for clusters
      userId: '',
      icon: BitmapDescriptor.defaultMarker,
      isCluster: true,
      clusterId: cluster.id,
      pointsSize: cluster.pointsSize ?? 1,
      iconPath: null,
    );
  }

  // Method to convert PropertyAddress to ClusterItem
  ClusterItem convertPropertyInfoToClusterItem(PropertyInfo property) {
    return ClusterItem(
      propertyId: property.propertyId,
      latitude: property.latitude,
      longitude: property.longitude,
      price: property.price, // Ensure the price property is added
      propertyType: property.propertyType ?? 'unknown', // Ensure the propertyType is added
      icon: BitmapDescriptor.defaultMarker,
      userId: property.userId,
      iconPath: null,
    );
  }

  // Factory constructor for creating ClusterItem from Firestore
  // Factory constructor to create ClusterItem from Firestore
  factory ClusterItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ClusterItem(
      propertyId: doc.id,
      latitude: data['latitude'],
      longitude: data['longitude'],
      price: data['price'], // Ensure the price property is added
      propertyType: data['propertyType'], // Ensure the propertyType is added
      icon: BitmapDescriptor.defaultMarker,
      userId: data['userId'],
      iconPath: null,
    );
  }
}