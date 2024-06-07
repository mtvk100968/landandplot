import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/property_info.dart'; // Adjust the path as necessary to import PropertyInfo model
import '../services/storage_service.dart';

class PropertyService {
  final StorageService _storageService = StorageService();

  // Method for loading properties from a local JSON file
  Future<List<dynamic>> loadProperties() async {
    String jsonString = await rootBundle.loadString('assets/properties.json');
    return jsonDecode(jsonString);
  }

  // Method for fetching properties from Firestore
  Future<List<PropertyInfo>> fetchPropertyInfoesFromFirestore(String userId) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('properties')
        .where('userId', isEqualTo: userId)
        .get();

    var propertyInfoes = querySnapshot.docs.map((doc) {
      return PropertyInfo.fromSnapshot(doc); // Use fromSnapshot here
    }).toList();

    return propertyInfoes;
  }

  Future<List<String>> addPropertyWithImages(PropertyInfo property, List<XFile> images) async {
    List<String> imageUrls = [];
    for (XFile image in images) {
      String? imageUrl = await StorageService.uploadImage(image.path, property.propertyId);
      imageUrls.add(imageUrl!);
    }
    property = PropertyInfo(
      propertyId: property.propertyId,
      propertyType: property.propertyType,
      latitude: property.latitude,
      longitude: property.longitude,
      iconPath: property.iconPath,
      userId: property.userId,
      price: property.price,
      count: property.count,
      imageUrls: imageUrls, // Add imageUrls to property
    );
    await FirebaseFirestore.instance.collection('properties').doc(property.propertyId).set(property.toMap());
    return imageUrls; // Return the list of image URLs
  }
}