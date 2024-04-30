// property_custom_icon.dart

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'custom_drawer.dart';

class PropertyCustomIcon extends StatefulWidget {
  const PropertyCustomIcon({Key? key}) : super(key: key);

  @override
  _PropertyCustomIconState createState() => _PropertyCustomIconState();
}

class _PropertyCustomIconState extends State<PropertyCustomIcon> {
  GoogleMapController? _controller; // Make it nullable
  final Set<Marker> _markers = {};
  LatLng currentLocation = LatLng(17.066886, 78.204222);
  Future<CameraPosition> _getInitialLocation() async {
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 17,
    );
  }

  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(17.066886, 78.204222), // Provide default coordinates
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((location) {
      setState(() {
        currentLocation = location;
      });
    });

    // Call _getInitialLocation to update _initialCameraPosition
    _getInitialLocation().then((cameraPosition) {
      setState(() {
        _initialCameraPosition = cameraPosition!;
      });
    });
    // Call a function to create markers after fetching property data
    _createMarkers();
  }

  Future<LatLng> getCurrentLocation() async {
    // Ensure the location services are enabled and permission is granted
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('print = Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('print = Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('print = Location permissions are permanently denied');
    }

    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  void _createMarkers() async {
    final properties = await fetchProperties();

    for (final property in properties) {
      final marker = Marker(
        markerId: MarkerId(property.id),
        position: LatLng(property.latitude, property.longitude),
        icon: await createCustomIcon(property.price),
        infoWindow:
            InfoWindow(title: property.name, snippet: '\$${property.price}'),
      );

      setState(() {
        _markers.add(marker);
      });
    }
  }

  Future<BitmapDescriptor> createCustomIcon(String price) async {
    // Create a PictureRecorder to record the canvas operations
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..color = Colors.green; // The color of the circle
    const double size = 180; // The size of the icon

// Define the size of the rectangle
    const double width = 200; // The width of the rectangle
    const double height = 90; // The height of the rectangle
    const double radius = 30; // The radius of the rounded corners

// Let's say you want the rectangle to be at the center of the canvas
    final Rect rect = Rect.fromCenter(
      center: Offset(size / 2, size / 2), // Center of the canvas
      width: width, // Width of the rectangle
      height: height, // Height of the rectangle
    );

    // Create an RRect from the Rect and the radius for corners
    final RRect roundedRect =
        RRect.fromRectAndRadius(rect, Radius.circular(radius));

// Now draw the rounded rectangle on the canvas
    canvas.drawRRect(roundedRect, paint);

    // Define the text style for your text
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: size / 4, // Adjust as needed
      fontWeight: FontWeight.bold,
    );

    TextSpan textSpan = TextSpan(
      text: price,
      style: textStyle,
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size,
    );

    // Position the text in the center of the canvas
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    // textPainter.text = TextSpan(
    //   text: clusterSize.toString(),
    //   style: TextStyle(
    //     fontSize: size / 4, // Adjust the size accordingly
    //     color: Colors.white,
    //     fontWeight: FontWeight.bold,
    //   ),
    // );
// Create a TextSpan and TextPainter to draw the text
//     final textSpan = TextSpan(
//       text: price,
//       style: TextStyle(
//         fontSize: size / 4, // Adjust the size accordingly
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//       ),
//     );

    // final BitmapDescriptor customIcon = await createCustomIcon("25k");
    //
    // final Marker marker = Marker(
    //   markerId: MarkerId('marker_id'),
    //   position: LatLng(lat!, lng!), // Your property's latitude and longitude
    //   icon: customIcon,
    //   infoWindow: InfoWindow(title: 'Property', snippet: '$25k'), // Optional
    // );
    //
    // textPainter.layout();
    // textPainter.paint(canvas, Offset(size / 4, size / 4)); // Adjust the offset if needed
    //
    //
    // // Positioning the text in the center of our custom icon
    // final textOffset = Offset(
    //   (size / 2) - (textPainter.width / 2),
    //   (size / 2) - (textPainter.height / 2),
    // );
    // textPainter.paint(canvas, textOffset);

    // Convert the canvas to an image
    final ui.Image image = await pictureRecorder.endRecording().toImage(
          size.toInt(),
          size.toInt(),
        );
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to get byte data of the image');
    }
    final Uint8List pngBytes = byteData.buffer.asUint8List();

    // Create a BitmapDescriptor from the image byte data
    return BitmapDescriptor.fromBytes(pngBytes);
  }

  Future<List<Property>> fetchProperties() async {
    // Example data, replace with your actual data fetching logic
    return [
      Property(
        id: '1',
        price: '200K',
        latitude: 17.066886,
        longitude: 78.204222,
        name: 'Beautiful Home', // Example name
      ),
      // ... Add more properties as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0, // Remove elevation by setting it to 0.0
        iconTheme: IconThemeData(color: Colors.black, size: 48.0),
        // Change icon color to black and adjust size
        backgroundColor: Colors.white, // Set the background color to white
        title: Text(
          'R',
          style: TextStyle(
            color: Colors.black, // Set the text color to black
            fontSize: 36, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(17.066886, 78.204222),
          zoom: 14.4746,
        ),
        markers: _markers,
      ),
    );
  }
}

// A simple class for property data
class Property {
  final String id;
  final String price;
  final double latitude;
  final double longitude;
  final String name; // Add this line

  Property({
    required this.id,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.name, // Add this line
  });
}
