//map_property_addresses.dart
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluster/fluster.dart';
// import 'package:landandplot/models/property_address.dart';

class MapPropertyAddress extends Clusterable {
  final String propertyId;
  final LatLng position;
  BitmapDescriptor icon; // BitmapDescriptor for the custom icon
  late final String price; // Price attribute

  MapPropertyAddress({
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

  // Define a factory method to create MapPropertyAddress from a JSON object
  factory MapPropertyAddress.fromJSON(Map<String, dynamic> json) {
    return MapPropertyAddress(
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
    final Paint paint = Paint()..color = Colors.green;
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
// Function to convert PropertyAddress instances to MapPropertyAddress
List<MapPropertyAddress> convertToMapPropertyAddresses(
    List<MapPropertyAddress> propertyAddresses) {
  return propertyAddresses.map((property) {
    return MapPropertyAddress(
      propertyId: property.propertyId,
      position: property.position,
      icon: property.icon ?? BitmapDescriptor.defaultMarker,
      price: '', // Use icon from property or a default
    );
  }).toList();
}

// Define or import your createPropertyAddressList function
// Example function (you should replace this with your actual implementation):
List<MapPropertyAddress> createPropertyAddressList() {
  // Return a list of PropertyAddress instances
  return [
    // MapPropertyAddress(
    //   propertyId: '1',
    //   position: const LatLng(17.070142, 78.196137),
    //   icon: BitmapDescriptor.defaultMarker,
    //   price: '',
    // ),
    // Add more properties...
    // MapPropertyAddress(
    //   propertyId: '2',
    //   position: const LatLng(17.437988, 78.373893),
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '3',
    //   position: const LatLng(17.024201, 78.217112),
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '4',
    //   position: const LatLng(17.072443, 78.166646), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '5',
    //   position: const LatLng(17.073698, 78.151284), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '6',
    //   position: const LatLng(17.073712, 78.151387), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '7',
    //   position: const LatLng(17.071343, 78.142960), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '8',
    //   position: const LatLng(17.071343, 78.142960), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '9',
    //   position: const LatLng(17.071723, 78.144188), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '10',
    //   position: const LatLng(17.163584, 78.377753), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '11',
    //   position: const LatLng(17.069619, 78.196119), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ), //  Add more properties as needed
    // MapPropertyAddress(
    //   propertyId: '12',
    //   position: const LatLng(17.069390, 78.196091), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '13',
    //   position: const LatLng(17.070385, 78.196547), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    // MapPropertyAddress(
    //   propertyId: '14',
    //   position: const LatLng(17.069908, 78.196134), // Example coordinates
    //   icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    // ),
    //   MapPropertyAddress(
    //     propertyId: '15',
    //     position: const LatLng(17.069898, 78.195707), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   MapPropertyAddress(
    //     propertyId: '16',
    //     position: const LatLng(44.656033, -63.600077), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   // 17.438181, 78.374772
    //   MapPropertyAddress(
    //     propertyId: '17',
    //     position: const LatLng(17.438181, 78.374772), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   MapPropertyAddress(
    //     propertyId: '18',
    //     position: const LatLng(17.438755, 78.377583), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   MapPropertyAddress(
    //     propertyId: '19',
    //     position: const LatLng(17.440445, 78.376276), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   MapPropertyAddress(
    //     propertyId: '20',
    //     position: const LatLng(17.439801, 78.378036), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   MapPropertyAddress(
    //     propertyId: '21',
    //     position: const LatLng(17.439811, 78.378501), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   MapPropertyAddress(
    //     propertyId: '22',
    //     position: const LatLng(17.439765, 78.377914), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   MapPropertyAddress(
    //     propertyId: '23',
    //     position: const LatLng(17.439755, 78.378268), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   MapPropertyAddress(
    //     propertyId: '24',
    //     position: const LatLng(17.438996, 78.378651), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    //   MapPropertyAddress(
    //     propertyId: '25',
    //     position: const LatLng(17.436287, 78.376375), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    // MapPropertyAddress(
    //     propertyId: '26',
    //     position: const LatLng(17.432643, 78.377205), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
    // MapPropertyAddress(
    //     propertyId: '27',
    //     position: const LatLng(17.433028, 78.377514), // Example coordinates
    //     icon: BitmapDescriptor.defaultMarker, price: '', // Example coordinates
    //   ),
  ];
}

// Initialize propertyAddresses using createPropertyAddressList
List<MapPropertyAddress> propertyAddresses = createPropertyAddressList();

// Convert PropertyAddress to MapPropertyAddress
List<MapPropertyAddress> mapPropertyAddresses =
    convertToMapPropertyAddresses(propertyAddresses);

//List<MapPropertyAddress> mapPropertyAddresses = convertToMapPropertyAddresses(propertyAddresses);


// List<MapPropertyAddress> mapPropertyAddresses = convertToMapPropertyAddresses(propertyAddresses);


// Inside your widget build method or another appropriate place
// List<MapPropertyAddress> mapPropertyAddresses = convertToMapPropertyAddresses(
//     createPropertyAddressList((propertyId) => handleOnTap(propertyId))
// );
// List<MapPropertyAddress> mapPropertyAddresses = convertToMapPropertyAddresses(createPropertyAddressList(handleOnTap));

// Example usage
// List<MapPropertyAddress> mapPropertyAddresses = convertToMapPropertyAddresses(createPropertyAddressList());