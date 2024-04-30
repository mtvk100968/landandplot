import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MapService {
  // A GoogleMapController to control the map
  late GoogleMapController _mapController;

  // A Set to keep all the markers
  Map<MarkerId, Marker> _markers = {};  // Changed to a map
// This should be a callback function that gets called when markers need to be updated.
  Function(Map<MarkerId, Marker>)? onMarkersUpdated;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void initialize(GoogleMapController controller) async {
    _mapController = controller;
    List<Marker> markers = await fetchAndDisplayMarkers();
    _updateMarkers(Map<MarkerId, Marker>.fromEntries(
        markers.map((m) => MapEntry(m.markerId, m))
    ));
  }
  // Fetch markers from Firestore and add them to the map
// Fetch markers from Firestore and add them to the map
//   Future<void> fetchMarkers() async {
//     CollectionReference markersCollection = FirebaseFirestore.instance.collection('properties');
//     QuerySnapshot querySnapshot = await markersCollection.get();
//
//     var newMarkers = <MarkerId, Marker>{};
//     for (var doc in querySnapshot.docs) {
//       var data = doc.data() as Map<String, dynamic>;
//       var markerId = MarkerId(doc.id);
//       newMarkers[markerId] = Marker(
//         markerId: markerId,
//         position: LatLng(data['position']['lat'], data['position']['lng']),
//         infoWindow: InfoWindow(
//           title: 'Property ${data['propertyId']}',
//           snippet: 'Price: ${data['price']}',
//         ),
//         icon: BitmapDescriptor.defaultMarker, // Customize your marker icon as needed
//       );
//     }
//     _updateMarkers(newMarkers);
//   }
//
//   Future<void> displayPropertiesOnMap() async {
//     final properties = await fetchPropertiesFromFirestore();
//
//     // Loop through the properties and create a marker for each
//     for (final property in properties) {
//       final markerId = MarkerId(property['propertyId']);
//       final position = LatLng(property['position']['lat'], property['position']['lng']);
//       final marker = Marker(
//         markerId: markerId,
//         position: position,
//         infoWindow: InfoWindow(title: property['propertyId'], snippet: 'Price: ${property['price']}'),
//         icon: await getCustomIcon(property['iconPath']), // Ensure you have a method to handle icon conversion
//       );
//
//       markers.add(marker);
//     }
//
//     // Update your map controller or state to display the new markers
//     updateMapMarkers(markers);
//   }

  // Function to fetch markers from Firestore and add them to the map
  Future<List<Marker>> fetchAndDisplayMarkers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('properties').get();
      List<Marker> markers = [];

      for (var doc in querySnapshot.docs) {
        double lat = doc.get('lat');
        double lng = doc.get('lng');
        String iconPath = doc.get('iconPath'); // Make sure this path is correct for your assets
        String price = doc.get('price');
        String userId = doc.get('userId');

        BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5),
            iconPath // Assuming you have the icon asset at this path
        );

        Marker marker = Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(lat, lng),
          icon: icon,
          infoWindow: InfoWindow(
              title: 'Property $price',
              snippet: 'User: $userId'
          ),
        );

        markers.add(marker);
      }

      return markers;
    } catch (e) {
      print('Error fetching markers: $e');
      return [];
    }
  }


  // Function to convert icon path to BitmapDescriptor
  // Example method to convert icon path to BitmapDescriptor
  Future<BitmapDescriptor> getCustomIcon(String iconPath) async {
    // If your icons are stored as assets, you could do something like this:
    return BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      iconPath,
    );
    // Adjust the size as necessary or add other logic for network images etc.
  }


  // // Function to update markers on the map
  // void _updateMarkers(Map<MarkerId, Marker> newMarkers) {
  //   setState(() {
  //     _markers = newMarkers;
  //   });
  //   // If using GoogleMapController, you may need to set the markers directly or force a widget rebuild
  // }

  Future<List<Map<String, dynamic>>> fetchPropertiesFromFirestore() async {
    CollectionReference propertiesCollection = FirebaseFirestore.instance.collection('properties');
    QuerySnapshot querySnapshot = await propertiesCollection.get();

    // Map each document to a Map<String, dynamic> and return a list
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }


  void moveToLocation(LatLng location, double zoom) {
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(location, zoom));
  }

  // Modified addMarker function that includes user ID
  Future<void> addMarker(Marker marker, String userId) async {
    if (_validateUserId(userId)) {
      _markers[marker.markerId] = marker;
      await addMarkerToFirestore(marker, userId);
    } else {
      print("Invalid user ID");
    }
  }

  bool _validateUserId(String userId) {
    return userId.isNotEmpty;
  }
  Future<void> addMarkerToFirestore(Marker marker, String userId) async {
    try {
      final markerData = {
        'latitude': marker.position.latitude,
        'longitude': marker.position.longitude,
        'userId': userId,
      };

    CollectionReference markersCollection = FirebaseFirestore.instance.collection('markers');

    await markersCollection.add(markerData);
    print('Marker added to Firestore');
  } catch (e) {
  print('Error adding marker to Firestore: $e');
  // More sophisticated error handling can be implemented here
  }
}


  // Function to handle marker taps
  void onMarkerTapped(String markerId) {
    var marker = _markers[MarkerId(markerId)];
    if (marker != null) {
      _mapController.animateCamera(CameraUpdate.newLatLng(marker.position));
    } else {
      print("Marker not found");
    }
  }


  // Function to update markers on the map
  // Update the map markers set and refresh the map view
  void _updateMarkers(Map<MarkerId, Marker> newMarkers) {
    // Call the callback with the new markers.
    onMarkersUpdated?.call(newMarkers);
  }

  // Function to remove a marker from the map
  void removeMarker(String markerId) {
    _markers.remove(MarkerId(markerId));
  }


  // Function to clear all markers from the map
  void clearMarkers() {
    _markers.clear();
    // You could trigger a state update here if needed
  }

  // Getter for the markers
  Map<MarkerId, Marker> get markers => _markers;
}
