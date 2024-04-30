import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class PlaceDetailsScreen extends StatelessWidget {
  final String placeId;
  final LatLng coordinates;

  const PlaceDetailsScreen({
    Key? key,
    required this.placeId,
    required this.coordinates,
  }) : super(key: key);

  Future<String> fetchPlaceDetails(String placeId) async {
    // Simulate a network request to fetch place details
    await Future.delayed(const Duration(seconds: 2));
    // Mocked detailed description. Replace this with actual API call and parsing logic.
    return "This is a detailed description of the place with ID $placeId. The place has coordinates: ${coordinates.latitude}, ${coordinates.longitude}.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Place ID: $placeId', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Coordinates: ${coordinates.latitude}, ${coordinates.longitude}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<String>(
                future: fetchPlaceDetails(placeId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                  } else {
                    // Assuming the data is the detailed description
                    return SingleChildScrollView(
                      child: Text('Details: ${snapshot.data}', style: const TextStyle(fontSize: 16)),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}