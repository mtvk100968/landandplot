// maptype_service.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum CustomMapType {
  normal,
  satellite,
  hybrid,
}
class MapTypeService {
  static MapType getMapType(CustomMapType customMapType) {
    switch (customMapType) {
      case CustomMapType.normal:
        return MapType.normal;
      case CustomMapType.satellite:
        return MapType.satellite;
      case CustomMapType.hybrid:
        return MapType.hybrid;
      default:
        return MapType.normal;
    }
  }

  static Widget buildMapTypeIconButton({
    required CustomMapType mapType,
    required CustomMapType currentMapType,
    required void Function(CustomMapType) onTap,
    required IconData icon,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        onTap(mapType);
      },
      color: currentMapType == mapType ? Colors.blue : Colors.black,
    );
  }
}