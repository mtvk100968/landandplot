import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';

  // Add your Google API Key here
  final String _apiKey;

  DirectionsService({required String apiKey}) : _apiKey = apiKey;

  // Function to fetch directions
  Future<Map<String, dynamic>?> fetchDirections({required LatLng origin, required LatLng destination}) async {
    final String requestUrl =
        '$_baseUrl'
        'origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(requestUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e); // Ideally, handle this more gracefully
    }
    return null; // Return null on failure
  }

  // Function to parse and display directions on the map
  // This is a simplified version. You might want to expand it based on your needs.
  Future<Polyline?> getDirectionsPolyline({required LatLng origin, required LatLng destination}) async {
    final directionsData = await fetchDirections(origin: origin, destination: destination);
    if (directionsData == null) {
      return null;
    }

    // Extracting the polyline points from the directions data
    if ((directionsData['routes'] as List).isNotEmpty) {
      final route = directionsData['routes'][0];
      final String encodedPoly = route['overview_polyline']['points'];
      final List<LatLng> polylinePoints = decodePolyline(encodedPoly);

      return Polyline(
        polylineId: PolylineId('directions'),
        color: Colors.blue,
        width: 5,
        points: polylinePoints,
      );
    }
    return null;
  }

  // Function to decode polyline points
  // Polyline points are encoded; this function decodes them into a list of LatLng
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0, byte;

      // Decoding latitude value
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      // Decoding longitude value
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
}
