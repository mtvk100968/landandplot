//property_address.dart
import 'dart:ffi' hide Size;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cluster_item.dart';
import 'map_property_address.dart';

class PropertyAddress {
  final String propertyId;
  final String? propertyType; // Nullable propertyType
  final double latitude;
  final double longitude;
  final String iconPath;
  final String price;
  final String userId;

  PropertyAddress({
    required this.propertyId,
    required this.propertyType, // Made it nullable
    required this.latitude,
    required this.longitude,
    required this.iconPath,
    required this.price,
    required this.userId,
  });

  // factory PropertyAddress.fromSnapshot(DocumentSnapshot snapshot) {
  //   try {
  //     var data = snapshot.data() as Map<String, dynamic>;
  //     print("Data received: $data"); // Debugging statement
  //
  //     // Initialize position variables
  //     double latitude;
  //     double longitude;
  //
  //     // Check if 'position' is a GeoPoint and extract latitude and longitude accordingly
  //     var position = data['position'];
  //     if (position is GeoPoint) {
  //       latitude = position.latitude;
  //       longitude = position.longitude;
  //     } else if (position is Map<String, dynamic>) {
  //       latitude = position['lat'];
  //       longitude = position['lng'];
  //     } else {
  //       throw Exception("Position field is not a recognized type");
  //     }
  //
  //     // Extract propertyType with null check
  //     String? propertyType = data['propertyType'];
  //
  //     return PropertyAddress(
  //       propertyId: snapshot.id,
  //       propertyType: propertyType,
  //       latitude: latitude,
  //       longitude: longitude,
  //       iconPath: data['iconPath'] ?? 'assets/icons/gps.png',
  //       price: data['price'].toString(),
  //       userId: data['userId'],
  //     );
  //   } catch (e) {
  //     print('Error processing data: $e');
  //     rethrow;
  //   }
  // }

  // factory PropertyAddress.fromSnapshot(DocumentSnapshot snapshot) {
  //   try {
  //     var data = snapshot.data() as Map<String, dynamic>;
  //     print("Data received: $data");
  //
  //     // Directly get latitude and longitude from the Firestore fields
  //     double latitude = data['latitude'] ?? 0.0;
  //     double longitude = data['longitude'] ?? 0.0;
  //
  //     // Continue with the rest of the data extraction
  //     String? propertyType = data['propertyType'];
  //
  //     return PropertyAddress(
  //       propertyId: snapshot.id,
  //       propertyType: propertyType,
  //       latitude: latitude,
  //       longitude: longitude,
  //       iconPath: data['iconPath'] ?? 'assets/icons/gps.png',
  //       price: data['price'].toString(),
  //       userId: data['userId'],
  //     );
  //   } catch (e) {
  //     print('Error processing data: $e');
  //     rethrow;
  //   }
  // }


  factory PropertyAddress.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return PropertyAddress(
      propertyId: snapshot.id,
      propertyType: data['propertyType'],
      latitude: data['latitude'] ?? 0.0, // Use default value if not set
      longitude: data['longitude'] ?? 0.0, // Use default value if not set
      iconPath: data['iconPath'] ?? 'assets/icons/gps.png',
      price: data['price'].toString(),
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propertyId': propertyId,
      'propertyType': propertyType,
      'latitude': latitude,
      'longitude': longitude,
      'iconPath': iconPath,
      'price': price,
      'userId': userId,
    };
  }

  // Other methods remain unchanged...

  Future<Marker> toMarker() async {
    // When creating a Marker, use the latitude and longitude fields
    return Marker(
      markerId: MarkerId(propertyId),
      position: LatLng(latitude, longitude), // Use the lat and lng directly
      icon: await getIcon(),
      infoWindow: InfoWindow(
        title: propertyId,
        snippet: 'Price: $price',
      ),
    );
  }

  // factory PropertyAddress.fromSnapshot(DocumentSnapshot snapshot) {
  //   var data = snapshot.data() as Map<String, dynamic>;
  //   double latitude;
  //   double longitude;
  //
  //   // Check for GeoPoint or separate latitude and longitude fields
  //   if (data['position'] is GeoPoint) {
  //     GeoPoint position = data['position'];
  //     latitude = position.latitude;
  //     longitude = position.longitude;
  //   } else if (data['latitude'] != null && data['longitude'] != null) {
  //     latitude = data['latitude'];
  //     longitude = data['longitude'];
  //   } else {
  //     // Throw an exception if neither format is found
  //     throw Exception('Location data is missing or in an incorrect format.');
  //   }
  //
  //   return PropertyAddress(
  //     propertyId: snapshot.id,
  //     propertyType: data['propertyType'],
  //     latitude: latitude,
  //     longitude: longitude,
  //     iconPath: data['iconPath'] ?? 'assets/icons/gps.png',
  //     price: data['price'].toString(),
  //     userId: data['userId'],
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'propertyId': propertyId,
  //     'propertyType': propertyType,
  //     'latitude': latitude,
  //     'longitude': longitude,
  //     'iconPath': iconPath,
  //     'price': price,
  //     'userId': userId,
  //   };
  // }

  // Convert this PropertyAddress to a Marker
  // Future<Marker> toMarker() async {
  //   return Marker(
  //     markerId: MarkerId(propertyId),
  //     position: LatLng(latitude, longitude),
  //     icon: await getIcon(),
  //     infoWindow: InfoWindow(
  //       title: propertyId,
  //       snippet: 'Price: $price',
  //     ),
  //   );
  // }

  void fetchProperties() async {
    FirebaseFirestore.instance
        .collection('properties')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        try {
          var property = PropertyAddress.fromSnapshot(doc);
          print("Loaded property: ${property.propertyId}");
        } catch (e) {
          print("Failed to load property: $e");
        }
      }
    });
  }



  Map<String, dynamic> toFirestoreMap() {
    return {
      'propertyId': propertyId,
      'position': GeoPoint(latitude, longitude),
      'iconPath':
          iconPath, // No need to call getIconPath() if you're storing the path as a string
      'price': price,
      'userId': userId,
    };
  }

  static PropertyAddress fromFirestore(DocumentSnapshot doc) {
    try {
      var data = doc.data() as Map<String, dynamic>; // Ensure the cast is safe
      if (data == null) {
        throw Exception('Document data is null');
      }
      print("Document Data: $data"); // Debug output

      GeoPoint position = data['position'];
      if (position == null) {
        throw Exception('Position data is missing or null');
      }

      return PropertyAddress(
        propertyId: doc.id,
        propertyType: '',
        latitude: position.latitude,
        longitude: position.longitude,
        iconPath: data['iconPath'] ?? 'default_icon_path', // Provide a fallback
        price: data['price'] ?? 'N/A', // Fallback if price is not provided
        userId:
            data['userId'] ?? 'unknown_user', // Fallback for missing user ID
      );
    } catch (e) {
      print('Error processing document ${doc.id}: $e');
      rethrow; // Optionally rethrow to handle the error upstream
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'position': GeoPoint(latitude, longitude),
      'iconPath': iconPath,
      // No need to call getIconPath() if you're storing the path as a string
      'price': price,
      'userId': userId,
    };
  }

  String getIconPath(BitmapDescriptor icon) {
    // Here you would return the path or URL for your icon
    return 'path_to_icon_image';
  }

  Future<BitmapDescriptor> getIcon() async {
    if (iconPath.isEmpty || iconPath == 'default_icon_path') {
      return BitmapDescriptor.defaultMarker;
    }

    // For demonstration, let's return the default marker
    return BitmapDescriptor.defaultMarker;
  }

// Placeholder for the downloadImage method, replace with your actual implementation
  Future<Uint8List> downloadImage(String imagePath) async {
    // Your implementation to download image data goes here
    // For demonstration, let's return an empty list
    return Uint8List(0);
  }

  factory PropertyAddress.fromJson(Map<String, dynamic> json) {
    return PropertyAddress(
      propertyId: json['propertyId'],
      propertyType: json['propertyType'],
      latitude: json['position']['lat'],
      longitude: json['position']['lng'],
      iconPath: json['iconPath'] ?? 'assets/icons/gps.png',
      price: json['price'],
      userId: json['userId'],
    );
  }



  Future<List<Marker>> createMarkersFromAddresses(
      List<PropertyAddress> addresses) async {
    return await Future.wait(
        addresses.map((address) => address.toMarker()).toList());
  }

  ClusterItem convertPropertyAddressToClusterItem(PropertyAddress property) {
    // Fetch the icon asynchronously
    return ClusterItem(
      id: property.propertyId,
      latitude: property.latitude,
      longitude: property.longitude,
      iconPath: property.iconPath, // Pass the icon path to ClusterItem
      userId: property.userId,
      price: property.price,
// Pass other properties as needed
      // Add other properties as needed
    );
  }

  // Conversion function from PropertyAddress to MapPropertyAddress
  List<Future<MapPropertyAddress>> convertToMapPropertyAddresses(
      List<PropertyAddress> addresses) {
    return addresses
        .map((property) async => MapPropertyAddress(
              propertyId: property.propertyId,
              position: LatLng(property.latitude, property.longitude),
              icon: await property.getIcon(), // Load the icon dynamically
              price: property.price,
              isCluster: false, // Default or adjust based on your needs
              // Add other parameters as necessary
            ))
        .toList();
  }
}
