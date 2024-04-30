// /lib/services/google_maps_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleMapsService {
  final String apiKey;

  GoogleMapsService(this.apiKey);

  Future<Map<String, dynamic>> fetchCoordinatesFromPlaceId(String placeId) async {
    final response = await http.get(
      Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Check if the status is OK before proceeding
      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
        };
      } else {
        throw Exception('Failed to fetch coordinates: ${data['status']}');
      }
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
