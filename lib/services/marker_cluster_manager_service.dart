// services/marker_cluster_manager_service.dart

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/services.dart';
import '../models/cluster_item.dart';
import 'map_service.dart';
import 'package:flutter/rendering.dart';

class MarkerClusterManagerService {
  late Fluster<ClusterItem> fluster;
  late GoogleMapController _mapController;
  late final MapService _mapService;
  Map<MarkerId, Marker> _markers = {};
  StreamController<Map<MarkerId, Marker>> _markersController =
  StreamController.broadcast();
  Stream<Map<MarkerId, Marker>> get markersStream => _markersController.stream;

  void initializeFluster(List<ClusterItem> clusterItems) async {
    fluster = Fluster<ClusterItem>(
      minZoom: 0,
      maxZoom: 21,
      radius: 150,
      extent: 2048,
      nodeSize: 64,
      points: clusterItems,
      createCluster: (BaseCluster? cluster, double? longitude, double? latitude) {
        if (cluster == null || longitude == null || latitude == null) {
          throw Exception('Cluster, longitude, or latitude is null');
        }
        return ClusterItem(
          latitude: latitude,
          longitude: longitude,
          propertyId: 'cluster_${cluster.id}',
          isCluster: true,
          clusterId: cluster.id,
          price: 0.0,
          pointsSize: cluster.pointsSize,
          childMarkerId: '',
          propertyType: '',
          userId: '',
          icon: BitmapDescriptor.defaultMarker,
          iconPath: null,
        );
      },
    );
    await _updateClusterMarkers();
  }

  Future<void> _updateClusterMarkers() async {
    if (_mapController == null) {
      print("MapController is not initialized.");
      return;
    }

    final double zoom = await _mapController.getZoomLevel();
    final bounds = await _mapController.getVisibleRegion();
    final bbox = [
      bounds.southwest.longitude,
      bounds.southwest.latitude,
      bounds.northeast.longitude,
      bounds.northeast.latitude,
    ];

    const int zoomThreshold = 14;
    Map<MarkerId, Marker> newMarkers = {};

    if (zoom > zoomThreshold) {
      try {
        var properties = await _mapService.fetchPropertiesFromFirestore();
        for (var property in properties) {
          final markerId = MarkerId(property['propertyId']);
          newMarkers[markerId] = Marker(
            markerId: markerId,
            position: LatLng(property['latitude'], property['longitude']),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () => print("Tapped property ${property['propertyId']}"),
          );
        }
      } catch (e) {
        print("Error fetching properties: $e");
      }
    } else {
      final clusters = fluster.clusters(bbox, zoom.toInt());
      for (var cluster in clusters) {
        final markerId = MarkerId(cluster.propertyId.toString());
        if (cluster.isCluster) {
          BitmapDescriptor icon =
          await _createCustomClusterIcon(cluster.pointsSize);
          newMarkers[markerId] = Marker(
            markerId: markerId,
            position: LatLng(cluster.latitude, cluster.longitude),
            icon: icon,
            onTap: () {
              double newZoom = (zoom < 19) ? zoom + 2 : 19;
              _mapController!.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(cluster.latitude, cluster.longitude), newZoom));
            },
          );
        } else {
          newMarkers[markerId] = Marker(
            markerId: markerId,
            position: LatLng(cluster.latitude, cluster.longitude),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () => print("Tapped on individual marker ${cluster.propertyId}"),
          );
        }
      }
    }

    _markersController.add(newMarkers);
  }

  void dispose() {
    _markersController.close();
  }

  Future<BitmapDescriptor> _createCustomClusterIcon(int clusterSize,
      {int iconSize = 100}) async {
    final double originalSize = 70.0;
    final double size = originalSize * 2;
    final double padding = 10.0;
    final double outerRadius = (size / 2) + padding;

    final Paint shadePaint = Paint()
      ..color = Colors.blue.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = padding.toDouble();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      outerRadius,
      shadePaint,
    );
    final Paint paint = Paint()..color = Colors.blue;

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: clusterSize.toString(),
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final double textX = (size - textPainter.width) / 2;
    final double textY = (size - textPainter.height) / 2;

    textPainter.paint(canvas, Offset(textX, textY));

    final int intSize = size.round();
    final ui.Image image =
    await pictureRecorder.endRecording().toImage(intSize, intSize);
    final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(pngBytes);
    } else {
      debugPrint("Madhu Failed to convert the image to byte data.");
      return BitmapDescriptor.defaultMarker;
    }
  }
}
