//map_property_addresses.dart
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluster/fluster.dart';

class MapPropertyInfo extends Clusterable {
  final String propertyId;
  final LatLng position;
  BitmapDescriptor icon; // BitmapDescriptor for the custom icon
  late final String price; // Price attribute

  MapPropertyInfo({
    required this.propertyId,
    required this.position,
    required this.icon,
    required this.price,
    bool isCluster = false,
    int clusterId = 0,
    int pointsSize = 0,
    String childMarkerId = '',
  }) : super(
    latitude: position.latitude,
    longitude: position.longitude,
    isCluster: isCluster,
    clusterId: clusterId,
    pointsSize: pointsSize,
    childMarkerId: childMarkerId,
  );

  // Define a factory method to create MapPropertyInfo from a JSON object
  factory MapPropertyInfo.fromJSON(Map<String, dynamic> json) {
    return MapPropertyInfo(
      propertyId: json['propertyId'],
      position:
      LatLng(json['position']['latitude'], json['position']['longitude']),
      // You may need to adjust the parsing logic based on your JSON structure
      icon: BitmapDescriptor.defaultMarker,
      price: json['price'],
    );
  }

  Future<void> createCustomIcon() async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double size = 150.0; // Size of the icon

    // Define the size and style of the rectangle
    final Paint paint = Paint()..color = Colors.blue;
    final Rect rect = Rect.fromLTWH(0, 0, size, size);
    final RRect rRect =
    RRect.fromRectAndRadius(rect, Radius.circular(20)); // Rounded corners

    canvas.drawRRect(rRect, paint); // Draw the rounded rectangle

    // Add text (price) over the rectangle
    TextSpan span = TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 30),
      text: price,
    );
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
        canvas,
        Offset(
            (size - tp.width) / 2, (size - tp.height) / 2)); // Center the text

    // Convert canvas to image and create BitmapDescriptor
    final ui.Image image =
    await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    this.icon = BitmapDescriptor.fromBytes(pngBytes); // Update the icon
  }

  Marker toMarker() => Marker(
    markerId: MarkerId(propertyId),
    position: position,
    icon: icon, // Use the updated icon
  );
}

// The rest of your code for fetching and converting property addresses remains the same
// Function to convert PropertyAddress instances to MapPropertyInfo
List<MapPropertyInfo> convertToMapPropertyInfoes(
    List<MapPropertyInfo> propertyAddresses) {
  return propertyAddresses.map((property) {
    return MapPropertyInfo(
      propertyId: property.propertyId,
      position: property.position,
      icon: property.icon ?? BitmapDescriptor.defaultMarker,
      price: '', // Use icon from property or a default
    );
  }).toList();
}

// Define or import your createPropertyAddressList function
// Example function (you should replace this with your actual implementation):
List<MapPropertyInfo> createPropertyInfoList() {
  // Return a list of PropertyAddress instances
  return [];
}

// Initialize propertyAddresses using createPropertyAddressList
List<MapPropertyInfo> propertyAddresses = createPropertyInfoList();

// Convert PropertyAddress to MapPropertyInfo
List<MapPropertyInfo> MapPropertyInfoes =
convertToMapPropertyInfoes(propertyAddresses);

//List<MapPropertyInfo> MapPropertyInfoes = convertToMapPropertyInfoes(propertyAddresses);

// List<MapPropertyInfo> MapPropertyInfoes = convertToMapPropertyInfoes(propertyAddresses);

// Inside your widget build method or another appropriate place
// List<MapPropertyInfo> MapPropertyInfoes = convertToMapPropertyInfoes(
//     createPropertyAddressList((propertyId) => handleOnTap(propertyId))
// );
// List<MapPropertyInfo> MapPropertyInfoes = convertToMapPropertyInfoes(createPropertyAddressList(handleOnTap));

// Example usage
// List<MapPropertyInfo> MapPropertyInfoes = convertToMapPropertyInfoes(createPropertyAddressList());