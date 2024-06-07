import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IconService {
  Future<BitmapDescriptor> createCustomMarkerIcon(String iconPath) async {
    try {
      final ByteData bytes = await rootBundle.load(iconPath);
      final BitmapDescriptor bitmapDescriptor =
      BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
      print('Custom icon loaded successfully: $bitmapDescriptor'); // Debug log
      return bitmapDescriptor;
    } catch (e) {
      print('Failed to load custom icon: $e'); // Error log
      throw Exception(
          'Failed to load custom icon: $e'); // Throw an exception with a message
    }
  }

  Future<BitmapDescriptor> createCustomClusterIcon(int clusterSize,
      {int iconSize = 100}) async {
    // Original size
    final double originalSize =
    70.0; // The original diameter of the icon as double
    // Double the size of the icon for a larger circle
    final double size = originalSize *
        2; // The new diameter of the icon will be twice the original
    // Define the outer radius with some padding for the shade
    final double padding = 10.0; // the padding for the shade as double
    final double outerRadius = (size / 2) + padding; // Calculate as double

    // Define the paint for the transparent shade
    final Paint shadePaint = Paint()
      ..color = Colors.blue.withAlpha(
          100) // Set the color with alpha for transparency, e.g., 100 out of 255
      ..style = PaintingStyle.stroke // Draw only the outline of the circle
      ..strokeWidth = padding.toDouble(); // The thickness of the shade

    // Create a PictureRecorder to record the canvas operations
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Draw the larger circle for the transparent round shade
    canvas.drawCircle(
      Offset(size / 2, size / 2), // Center of the canvas
      outerRadius, // Radius including the padding
      shadePaint, // Paint defined for the shade
    );
    final Paint paint = Paint()..color = Colors.blue;

    // Now draw the main circle on top of the shade
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2, // The radius of the main circle
      paint, // The paint for the main circle
    );

    // Define the TextPainter
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: clusterSize.toString(),
        style: TextStyle(
          fontSize: size / 3, // Choose the font size
          color: Colors.white, // Choose the text color
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

// Layout the TextPainter to calculate the size of the text
    textPainter.layout();

// Calculate the center position
    final double textX = (size - textPainter.width) / 2;
    final double textY = (size - textPainter.height) / 2;

// Now paint the text onto the canvas at the center position
    textPainter.paint(canvas, Offset(textX, textY));

    // If size is a double, round it to the nearest integer
    final int intSize = size.round();
    // Convert the canvas to an image with the integer size
    final ui.Image image =
    await pictureRecorder.endRecording().toImage(intSize, intSize);
    final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    // Make sure byteData is not null before using it
    // If byteData is null, log an error and return a default icon
    if (byteData != null) {
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Convert the image to a BitmapDescriptor
      return BitmapDescriptor.fromBytes(pngBytes);
    } else {
      // Log an error message or handle the error as appropriate for your app
      debugPrint("Madhu Failed to convert the image to byte data.");

      // Return a default icon
      // This could be a pre-defined icon or a BitmapDescriptor.defaultMarker
      return BitmapDescriptor.defaultMarker;
    }
  }
}