import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressService {

  static final String apiKey = 'AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc';
  static Future<Map<String, dynamic>?> getAddressDetailsFromPincode(String pincode) async {
    final response =
    await http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=$pincode&components=country:IN&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'];
        if (results.isNotEmpty) {
          final addressComponents = results[0]['address_components'];
          String? city;
          String? district;
          String? state;

          for (var component in addressComponents) {
            final types = component['types'];
            if (types.contains('locality')) {
              city = component['long_name'];
            } else if (types.contains('administrative_area_level_2') || types.contains('administrative_area_level_3')) {
              district = component['long_name'];  // Adjust this if needed based on your logs
            } else if (types.contains('administrative_area_level_1')) {
              state = component['long_name'];
            }

            if (city != null && district != null && state != null) {
              break;
            }
          }

          return {'city': city, 'district': district, 'state': state};
        }
      }
      return null;
    } else {
      throw Exception('Failed to fetch address details');
    }
  }
}