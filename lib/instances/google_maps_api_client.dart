//google_maps_api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsApiClient {
  final String apiKey;
  final http.Client httpClient;

// Constructor with httpClient initialization.
  GoogleMapsApiClient({required this.apiKey, http.Client? client})
      : httpClient = client ?? http.Client();

  Future<dynamic> _getRequest(Uri url) async {
    final response = await httpClient.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode} - ${response.body}');
    }
  }

  Future<dynamic> _makeRequest(Uri url) async {
    final response = await httpClient.get(url);
    final jsonResponse = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${jsonResponse['error_message']}');
    }

    return jsonResponse;
  }

  // Fetching latitude and longitude based on a place ID or place name.
  Future<LatLng> getCoordinates(String placeId, {bool isPlaceName = false}) async {
    Uri url;
    if (isPlaceName) {
      url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(placeId)}&key=$apiKey',
      );
    } else {
      url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=${Uri.encodeComponent(placeId)}&fields=geometry&key=$apiKey',
      );
    }
    final jsonResponse = await _makeRequest(url);
    if (jsonResponse['status'] == 'OK') {
      final location = isPlaceName
          ? jsonResponse['results'][0]['geometry']['location']
          : jsonResponse['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Failed to fetch coordinates: ${jsonResponse['error_message']}');
    }
  }

// Fetching detailed information about a place.
  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?placeid=${Uri.encodeComponent(placeId)}&key=$apiKey',
    );

    final jsonResponse = await _getRequest(url);
    if (jsonResponse['status'] == 'OK') {
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to fetch place details: ${jsonResponse['error_message']}');
    }
  }

  // Performing a text search on the Google Maps API.
  Future<List<Map<String, dynamic>>> searchPlace(String query) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri
          .encodeComponent(query)}&key=$apiKey',
    );

    final jsonResponse = await _getRequest(url);
    if (jsonResponse['status'] == 'OK') {
      return List<Map<String, dynamic>>.from(jsonResponse['results']);
    } else {
      throw Exception(
          'Failed to search places: ${jsonResponse['error_message']}');
    }
  }

  Future<LatLng> fetchPlaceCoordinates(String placeId, {String fields = 'geometry'}) async {
    final Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&fields=$fields&key=$apiKey',
    );

    final jsonResponse = await _makeRequest(url);

    if (jsonResponse['status'] == 'OK') {
      final location = jsonResponse['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Failed to fetch place coordinates: ${jsonResponse['error_message']}');
    }
  }


  // Dispose method to close the HTTP client.
  void dispose() {
    httpClient.close();
  }
}
