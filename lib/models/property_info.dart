// property_info.dart
import 'dart:ffi' hide Size;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cluster_item.dart';
import 'map_property_addresses.dart';

class PropertyInfo {
  final String propertyId;
  final String? propertyType;
  final double latitude;
  final double longitude;
  final String iconPath;
  final String userId;
  final double price;
  final int count; // Add count property
  final List<String> imageUrls; // Add imageUrls field

  PropertyInfo({
    required this.propertyId,
    this.propertyType,
    required this.latitude,
    required this.longitude,
    required this.iconPath,
    required this.userId,
    required this.price,
    this.count = 0, // Default to 0 if not specified
    this.imageUrls = const [], // Default to an empty list if not specified
  });

  PropertyInfo copyWith({
    String? propertyId,
    String? propertyType,
    double? latitude,
    double? longitude,
    String? iconPath,
    String? userId,
    double? price,
    int? count,
    List<String>? imageUrls,
  }) {
    return PropertyInfo(
      propertyId: propertyId ?? this.propertyId,
      propertyType: propertyType ?? this.propertyType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      iconPath: iconPath ?? this.iconPath,
      userId: userId ?? this.userId,
      price: price ?? this.price,
      count: count ?? this.count,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propertyId': propertyId,
      'propertyType': propertyType,
      'latitude': latitude,
      'longitude': longitude,
      'iconPath': iconPath,
      'price': price,
      'userId': userId,
      'count': count, // Include count in the mapping
      'imageUrls': imageUrls, // Include imageUrls in the mapping
    };
  }

  factory PropertyInfo.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    double parsedPrice = 0.0;
    if (data['price'] != null) {
      parsedPrice = double.tryParse(data['price'].toString()) ?? 0.0;
    }
    return PropertyInfo(
      propertyId: snapshot.id,
      propertyType: data['propertyType'] as String?,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      iconPath: data['iconPath'] ?? '',
      price: parsedPrice,
      userId: data['userId'] as String,
      count: data['count'] ?? 0,
      imageUrls: List<String>.from(
          data['imageUrls'] ?? []), // Parse imageUrls from Firestore
    );
  }

  factory PropertyInfo.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>? ??
        {}; // Safely cast with fallback to empty map

    return PropertyInfo(
      propertyId: doc.id,
      propertyType: data['propertyType'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      iconPath: data['iconPath'],
      userId: data['userId'],
      price: double.tryParse(data['price'].toString()) ??
          0.0, // Handling price as a string from Firestore
      count: int.tryParse(data['count'].toString()) ?? 1,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Future<Marker> toMarker() async {
    print("Creating marker for propertyId: $propertyId, Price: $price");
    return Marker(
      markerId: MarkerId(propertyId),
      position: LatLng(latitude, longitude),
      icon:
      await BitmapDescriptor.fromAssetImage(ImageConfiguration(), iconPath),
      infoWindow: InfoWindow(
        title: propertyType ?? "Unknown Type",
        snippet: 'Price: ₹${price.toStringAsFixed(2)}', // Ensure formatting
      ),
    );
  }

  void fetchProperties() async {
    FirebaseFirestore.instance
        .collection('properties')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        try {
          var property = PropertyInfo.fromSnapshot(doc);
          print("Loaded property: ${property.propertyId}");
        } catch (e) {
          print("Failed to load property: $e");
        }
      }
    });
  }

  Map<String, dynamic> toFirestore() {
    return {
      'propertyId': propertyId,
      'propertyType': propertyType,
      'latitude': latitude,
      'longitude': longitude,
      'iconPath': iconPath,
      'userId': userId,
      'price': price,
      'count': count,
      'imageUrls': imageUrls, // Include imageUrls in the mapping
    };
  }

  static PropertyInfo createFromFirestore(DocumentSnapshot doc) {
    try {
      var data = doc.data() as Map<String, dynamic>; // Ensure the cast is safe
      if (data == null) {
        throw Exception('Document data is null');
      }

      return PropertyInfo(
        propertyId: doc.id,
        propertyType: data['propertyType'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        iconPath: data['iconPath'],
        userId: data['userId'],
        price: double.tryParse(data['price'].toString()) ?? 0.0,
        count: int.tryParse(data['count'].toString()) ?? 1,
        imageUrls: List<String>.from(
            data['imageUrls'] ?? []), // Parse imageUrls from Firestore
      );
    } catch (e) {
      print('Error processing document ${doc.id}: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'position': GeoPoint(latitude, longitude),
      'iconPath': iconPath,
      'price': price,
      'userId': userId,
      'imageUrls': imageUrls, // Include imageUrls in the mapping
    };
  }

  String getIconPath(BitmapDescriptor icon) {
    // Here you would return the path or URL for your icon
    return 'path_to_icon_image';
  }

  Future<BitmapDescriptor> getIcon() async {
    if (iconPath.isEmpty || iconPath == 'default_icon_path') {
      return BitmapDescriptor.defaultMarker;
    }
    return BitmapDescriptor.defaultMarker;
  }

  Future<Uint8List> downloadImage(String imagePath) async {
    // Your implementation to download image data goes here
    return Uint8List(0);
  }

  factory PropertyInfo.fromJson(Map<String, dynamic> json) {
    return PropertyInfo(
      propertyId: json['propertyId'],
      propertyType: json['propertyType'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      iconPath: json['iconPath'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      userId: json['userId'],
      count: json['count'] ?? 0,
      imageUrls: List<String>.from(
          json['imageUrls'] ?? []), // Parse imageUrls from JSON
    );
  }

  Future<List<Marker>> createMarkersFromAddresses(
      List<PropertyInfo> addresses) async {
    return await Future.wait(
        addresses.map((address) => address.toMarker()).toList());
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

  List<Future<MapPropertyInfo>> convertToMapPropertyInfoes(
      List<PropertyInfo> addresses) {
    return addresses.map((property) async {
      final icon = await property.getIcon();
      return MapPropertyInfo(
        propertyId: property.propertyId,
        position: LatLng(property.latitude, property.longitude),
        icon: icon,
        price: property.price.toString(), // Convert double to String
        isCluster: false,
      );
    }).toList();
  }
}
