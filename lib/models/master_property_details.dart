//master_property_details.dart
import 'dart:ffi' hide Size;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cluster_item.dart';
import 'map_property_info.dart';

class MasterPropertyDetails {
  final String propertyId;
  final String? propertyType; // Nullable propertyType
  final double mobileNo;
  final String propertyName;
  final String ownerName;
  final double totalArea;
  final double carpetArea;
  final double rentPerMonth;
  final double advanceRent;
  final double bedRooms;
  final double bathRooms;
  final double balConies;
  final double latitude;
  final double longitude;
  final String iconPath;
  final String userId;
  final String village;
  final String colony;
  final String tmc;
  final String city;
  final String district;
  final String state;
  final double pincode;

  MasterPropertyDetails({
    required this.propertyId,
    required this.propertyType, // Made it nullable
    required this.mobileNo,
    required this.propertyName,
    required this.ownerName,
    required this.rentPerMonth,
    required this.totalArea,
    required this.carpetArea,
    required this.advanceRent,
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
    required this.latitude,
    required this.longitude,
    required this.iconPath,
    required this.userId,
  });
}
