import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/property_address.dart';
import 'firestore_database_service.dart';

class MarkerClusterService {
  // Assuming this service is passed to the constructor
  final FirestoreDatabaseService _firestoreDatabaseService;
  final double someClusterThreshold = 12.0;
  Set<Marker> _markers = <Marker>{};
  Set<Marker> _clusteredMarkers = <Marker>{};
  double _currentZoom = 15.0;
  Map<int, BitmapDescriptor> _clusterIcons = {};

  MarkerClusterService(this._firestoreDatabaseService);

  void setMarkers(Set<Marker> markers) {
    _markers = markers;
    _updateClusters();
  }

  void onCameraMove(CameraPosition position) {
    _currentZoom = position.zoom;
    _updateClusters();
  }

  Set<Marker> getCurrentClusters() {
    if (_currentZoom > someClusterThreshold) {
      return _markers;
    } else {
      // Async method cannot be called here directly since `getCurrentClusters` is synchronous
      // You need to handle this logic elsewhere, perhaps triggering a state update after async call
      return _clusteredMarkers; // Placeholder for the real clusters
    }
  }

  void updateClusters() {
    _updateClusters();
  }

  // This is a placeholder. Replace with actual logic to generate an icon.
  Future<BitmapDescriptor> generateIcon(int clusterSize) async {
    // You can use BitmapDescriptor.fromAssetImage or other methods provided by google_maps_flutter to generate icons
    // Example:
    return BitmapDescriptor.defaultMarker;
  }

  Set<Marker> _convertFirestoreDataToMarkers(
      List<PropertyAddress> firestoreData) {
    Set<Marker> markers = {};
    for (var property in firestoreData) {
      markers.add(
        Marker(
          markerId: MarkerId(property.propertyId),
          position: LatLng(
              property.latitude,
              property
                  .longitude), // Use latitude and longitude to create LatLng
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            // title: property.title, // Uncomment and use this if 'title' is a field in your PropertyAddress
            snippet:
                'ID: ${property.propertyId}', // Example snippet with property ID
          ),
        ),
      );
    }
    return markers;
  }

  Future<BitmapDescriptor> _createCustomClusterIcon(int clusterSize) async {
    if (_clusterIcons.containsKey(clusterSize)) {
      return _clusterIcons[clusterSize]!;
    }
    // Generate custom icon and store it
    BitmapDescriptor icon =
        await generateIcon(clusterSize); // Implement this method
    _clusterIcons[clusterSize] = icon;
    return icon;
  }

  void _updateClusters() {
    // Replace with real clustering logic
    _clusteredMarkers.addAll(_markers);
  }

  Set<Marker> get clusteredMarkers => _clusteredMarkers;

  Future<void> loadMarkersFromFirestore() async {
    var firestoreData = await _firestoreDatabaseService.fetchProperties();
    Set<Marker> markers =
        _convertFirestoreDataToMarkers(firestoreData); // Implement this method
    setMarkers(markers);
    updateClusters();
  }
}

//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:landandplot/models/property_address.dart';
//
// import '../models/agriculture_land_details.dart';
// import '../models/apartment_details.dart'; // Your PropertyAddress model
//
// class FirestoreDatabaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<PropertyAddress?> getPropertyById(String propertyId) async {
//     try {
//       DocumentSnapshot docSnapshot = await _firestore.collection('properties').doc(propertyId).get();
//       if (docSnapshot.exists) {
//         // Assuming your PropertyAddress model has a fromJson constructor
//         return PropertyAddress.fromJson(docSnapshot.data() as Map<String, dynamic>);
//       }
//       return null; // Property not found
//     } catch (e) {
//       print('Error getting property: $e'); // Replace with proper error handling
//       return null;
//     }
//   }
//
//   // Define the method to fetch properties from Firestore
//   Future<List<PropertyAddress>> fetchProperties() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore.collection('properties').get();
//       List<PropertyAddress> properties = querySnapshot.docs.map((doc) {
//         return PropertyAddress.fromJson(doc.data() as Map<String, dynamic>);
//       }).toList();
//       return properties;
//     } catch (e) {
//       print('Error fetching properties: $e');
//       return [];
//     }
//   }
//
//   Future<void> addAgricultureLandDetails(AgricultureLandDetails landDetails) async {
//     try {
//       // Remove the 'propertyId' from the map if Firestore is generating the ID
//       Map<String, dynamic> landDetailsMap = landDetails.toMap()..remove('propertyId');
//
//       DocumentReference docRef = await _firestore.collection('agriculturelanddetails').add(landDetailsMap);
//       print('Agriculture land details added with ID: ${docRef.id}');
//       // Optionally, update the document with the generated ID if needed
//       await docRef.update({'propertyId': docRef.id});
//     } catch (e) {
//       print('Error adding agriculture land details: $e');
//       throw e; // You may want to throw the error to handle it in the calling function
//     }
//   }
//
//   // Function to write data to Firestore
//   Future<void> addOrUpdateProperty(String propertyId, Map<String, dynamic> propertyData) async {
//     await _firestore.collection('properties').doc(propertyId).set(propertyData);
//   }
//
//   // Function to delete a property from Firestore
//   Future<void> deleteProperty(String propertyId) async {
//     await _firestore.collection('properties').doc(propertyId).delete();
//   }
//
//   // Function to listen to a Firestore stream for real-time updates
//   Stream<QuerySnapshot> getPropertiesStream() {
//     return _firestore.collection('properties').snapshots();
//   }
//
//   // Query functions for specific collections or documents
//   // Add more query functions as needed, for example:
//   Future<List<PropertyAddress>> queryPropertiesByPriceRange(double minPrice, double maxPrice) async {
//     QuerySnapshot querySnapshot = await _firestore
//         .collection('properties')
//         .where('price', isGreaterThanOrEqualTo: minPrice)
//         .where('price', isLessThanOrEqualTo: maxPrice)
//         .get();
//     return querySnapshot.docs.map((doc) => PropertyAddress.fromJson(doc.data() as Map<String, dynamic>)).toList();
//   }
//
//   Future<List<Apartment_Details>> retrieveApartmentsByCity(String city) async {
//     QuerySnapshot querySnapshot = await _firestore
//         .collection('apartmentdetails')
//         .where('city', isEqualTo: city)
//         .get();
//
//     return querySnapshot.docs
//         .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
//         .toList();
//   }
//
//   Future<List<Apartment_Details>> retrieveApartmentsByDistrict(String district) async {
//     QuerySnapshot querySnapshot = await _firestore
//         .collection('apartmentdetails')
//         .where('district', isEqualTo: district)
//         .get();
//
//     return querySnapshot.docs
//         .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
//         .toList();
//   }
//
//   Future<List<Apartment_Details>> retrieveApartmentsByPincode(String pincode) async {
//     QuerySnapshot querySnapshot = await _firestore
//         .collection('apartmentdetails')
//         .where('pincode', isEqualTo: pincode)
//         .get();
//
//     return querySnapshot.docs
//         .map((doc) => Apartment_Details.fromMap(doc.data() as Map<String, dynamic>))
//         .toList();
//   }
// }
