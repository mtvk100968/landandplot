import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/cluster_item.dart';
import 'package:fluster/fluster.dart';
import 'dart:typed_data'; // Ensure this is the correct import

class ClusterService {
  late Fluster<ClusterItem> _fluster;
  late GoogleMapController mapController;

  ClusterService(this.mapController);

  Future<void> initFluster(List<ClusterItem> clusterItems) async {
    _fluster = Fluster<ClusterItem>(
      minZoom: 0,
      maxZoom: 21,
      radius: 150, // radius of the clusters
      extent: 2048,
      nodeSize: 64,
      points: clusterItems, // pass your list of ClusterItem objects here
      createCluster:
          (BaseCluster? cluster, double? longitude, double? latitude) {
        if (cluster == null || longitude == null || latitude == null) {
          throw Exception('Cluster, longitude, or latitude is null');
        }
        return ClusterItem(
          latitude: latitude,
          longitude: longitude,
          propertyId: 'cluster_${cluster.id}',
          isCluster: true,
          clusterId: cluster.id,
          pointsSize: cluster.pointsSize,
          price: 0.0, // Default price for clusters
          icon: BitmapDescriptor.defaultMarker, // Placeholder icon
          userId: '', // Placeholder userId
          propertyType: '',
          iconPath: null, // Placeholder propertyType
        );
      },
    );
    // Now that Fluster is initialized, you can update your markers
    await _updateClusterMarkers();
  }

  Future<void> _updateClusterMarkers() async {
    if (mapController == null || _fluster == null) {
      print("MapController or Fluster is not initialized.");
      return;
    }
    double zoom = await mapController.getZoomLevel();
    LatLngBounds bounds = await mapController.getVisibleRegion();
    var bbox = [
      bounds.southwest.longitude,
      bounds.southwest.latitude,
      bounds.northeast.longitude,
      bounds.northeast.latitude,
    ];

    var newMarkers = <MarkerId, Marker>{};
    var clusters = _fluster.clusters(bbox, zoom.toInt());

    for (var cluster in clusters) {
      var markerId = MarkerId(cluster.propertyId.toString());
      var marker = Marker(
        markerId: markerId,
        position: LatLng(cluster.latitude, cluster.longitude),
        icon: await createCustomIcon(
          cluster.price.toString(),
          cluster.isCluster,
          cluster.pointsSize,
        ),
        onTap: () {
          double newZoom = zoom < 19 ? zoom + 2 : 19;
          mapController.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(cluster.latitude, cluster.longitude), newZoom));
        },
      );
      newMarkers[markerId] = marker;
    }

    // Assuming you have a way to update markers on the map
    // updateMarkersOnMap(newMarkers); // Implement this method as needed
  }

  Future<BitmapDescriptor> createCustomIcon(
      String price, bool isCluster, int clusterSize) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint fillPaint = Paint()
      ..color = isCluster ? Colors.lightGreen : Colors.blue;

    // Main color for clusters and individual markers
    final Paint strokePaint = Paint()
      ..color = Colors.black // Outline color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const double size = 150.0; // Diameter for cluster circles
    const double radius = size / 2; // Radius for the inner circle
    const double pointerHeight = 15.0; // Height of the triangle pointer

    const double rectWidth = 160.0; // Base width for individual markers
    const double rectHeight = 60.0; // Base height for individual markers
    const double outerRadius = radius + 10; // Radius for the outer circle

    double textX, textY; // Variables to hold text positions

    if (isCluster) {
      // Draw the outer circle for aesthetic enhancement
      Offset center = const Offset(
          outerRadius + 5,
          outerRadius +
              5); // Centering the circle with extra space for the outer circle
      canvas.drawCircle(center, radius, fillPaint);

      // Set up the text painter for the cluster size
      TextStyle textStyle = const TextStyle(
        color: Colors.white,
        fontSize: 50, // Font size adjusted for visibility
        fontWeight: FontWeight.bold,
      );
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: clusterSize.toString(), style: textStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      // Layout and paint the text
      textPainter.layout();
      textX = (2 * (outerRadius + 5) - textPainter.width) / 2;
      textY = (2 * (outerRadius + 5) - textPainter.height) / 2;
      textPainter.paint(canvas, Offset(textX, textY));
    } else {
      // Individual marker properties
      const double width = rectWidth; // Width for individual marker
      const double height = rectHeight; // Height for individual marker

      // Calculate the top left point of the rectangle
      double rectTopLeftX = (size - rectWidth) / 2;
      double rectTopLeftY = (size - rectHeight) / 2;

      // Create a path for the rounded rectangle
      Path roundedRectPath = Path()
        ..addRRect(RRect.fromRectAndCorners(
          Rect.fromLTWH(rectTopLeftX, rectTopLeftY, rectWidth, rectHeight),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ));

      // Draw shadow for elevation
      canvas.drawShadow(roundedRectPath, Colors.black, 5.0, true);

      // Draw the rounded rectangle
      canvas.drawPath(roundedRectPath, fillPaint);
      canvas.drawPath(roundedRectPath, strokePaint);

      // Draw the pointer for the popup
      // Draw the pointer triangle
      Path path = Path();
      double baseY = rectTopLeftY +
          rectHeight; // Base Y-coordinate where the rectangle ends
      path.moveTo(
          size / 2,
          baseY +
              pointerHeight); // Start at the tip of the triangle (below the rectangle)
      path.lineTo(size / 2 - pointerHeight / 2,
          baseY); // Left point of the triangle at the bottom of the rectangle
      path.lineTo(size / 2 + pointerHeight / 2,
          baseY); // Right point of the triangle at the bottom of the rectangle
      path.close();

      canvas.drawPath(path, fillPaint); // Fill the triangle
      canvas.drawPath(path, strokePaint); // Outline the triangle

      // Set up the text painter for the price
      TextStyle textStyle = const TextStyle(
        color: Colors.white,
        fontSize: 50, // Font size adjusted for visibility
        fontWeight: FontWeight.bold,
      );
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: price, style: textStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      // Layout and paint the text
      textPainter.layout();
      textX = (size - textPainter.width) / 2;
      textY = rectTopLeftY +
          (rectHeight - textPainter.height) /
              2; // Centering text vertically in the rectangle
      textPainter.paint(canvas, Offset(textX, textY));
    }

    // Convert to image
    final ui.Image image = await pictureRecorder.endRecording().toImage(
        (2 * (outerRadius + 5))
            .toInt(), // Ensure the canvas is large enough to fit the entire outer circle
        (2 * (outerRadius + 5)).toInt());
    final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to get byte data of the image');
    }

    return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  }
}