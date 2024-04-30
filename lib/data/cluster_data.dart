import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarker extends Clusterable {
  final String propertyId;
  final LatLng position;
  // final BitmapDescriptor icon;

  MapMarker({
    required this.propertyId,
    required this.position,
    // required this.icon,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
    markerId: propertyId,
    latitude: position.latitude,
    longitude: position.longitude,
    isCluster: isCluster,
    clusterId: clusterId,
    pointsSize: pointsSize,
    childMarkerId: childMarkerId,
  );

  Marker toMarker() => Marker(
    markerId: MarkerId(propertyId),
    position: LatLng(
      position.latitude,
      position.longitude,
    ),
    //icon: icon,
  );
}