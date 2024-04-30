// // current_marker_properties.dart
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:landandplot/property_details_display_page.dart';
// import 'custom_drawer.dart';
// import 'dart:async';
// import 'data/marker_data.dart';
//
// class CurrentMarkerProperties extends StatefulWidget {
//   final Widget? child; // Declare a child widget as an optional parameter
//
//   CurrentMarkerProperties({Key? key, this.child}) : super(key: key);
//
//   @override
//   _CurrentMarkerPropertiesState createState() =>
//       _CurrentMarkerPropertiesState();
// }
//
// class _CurrentMarkerPropertiesState extends State<CurrentMarkerProperties> {
//   final Completer<GoogleMapController> _controller = Completer();
//   late GoogleMapController _mapController;
//   bool mapCreated = false; // Add this variable to track if the map is created
//   LatLng? selectedLocation;
//   LatLng currentLocation = const LatLng(0, 0);
//   // Initialize with a default value
//   Future<CameraPosition> _getInitialLocation() async {
//     var currentLocation = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     return CameraPosition(
//       target: LatLng(currentLocation.latitude, currentLocation.longitude),
//       zoom: 17,
//     );
//   }
//
//   final Set<Marker> _markers = {};
//   //List<Marker> _marker = [];
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation().then((location) {
//       setState(() {
//         currentLocation = location;
//       });
//     });
//     setState(() {
//       // Add markers by calling listMarkers with the _onMarkerTap function
//       _markers.addAll(listMarkers(_onMarkerTap) as Iterable<Marker>);
//     });
//   }
//
//   // Google Maps *****************
//   void _updateCameraPosition(LatLng location) {
//     if (_mapController != null) {
//       _mapController.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: location, zoom: 17),
//       ));
//     }
//   }
//
//   Future<LatLng> getCurrentLocation() async {
//     // Ensure the location services are enabled and permission is granted
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied');
//     }
//
//     // Fetch the current position
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     return LatLng(position.latitude, position.longitude);
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     if (!mapCreated) { // Check if the map is already created
//       _mapController = controller;
//
//       if (selectedLocation != null) {
//         _updateCameraPosition(selectedLocation!);
//       } else if (currentLocation != const LatLng(0, 0)) {
//         _updateCameraPosition(currentLocation);
//       }
//
//       // Add your markers from _list to the map
//       setState(() {
//         // Add markers by calling listMarkers with the _onMarkerTap function
//         _markers.addAll(listMarkers(_onMarkerTap) as Iterable<Marker>);
//       });
//
//       mapCreated = true; // Set the flag to true to indicate the map is created
//     }
//   }
//
//   void _handleMapTap(LatLng latLng) {
//     // Clearing previous markers if you only need one marker on the map
//     setState(() {
//       //_markers.clear(); // Remove this line if you want to allow multiple markers
//       _markers.add(
//         Marker(
//           // Assigning a new marker id
//           markerId: MarkerId(latLng.toString()),
//           position: latLng,
//           infoWindow: InfoWindow(
//             title: 'Selected Location',
//             snippet: '${latLng.latitude}, ${latLng.longitude}',
//           ),
//         ),
//       );
//     });
//
//     // Optionally, you might want to move the camera to the tapped position
//     _controller.future.then((controller) {
//       controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: latLng,
//             zoom: 17.0,
//           ),
//         ),
//       );
//     });
//   }
//
//   void _onMarkerTap(String propertyId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PropertyDetailsDisplayPage(propertyId: propertyId),
//       ),
//     );
//     print('Tapped on property: $propertyId');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0, // Remove elevation by setting it to 0.0
//         iconTheme: const IconThemeData(color: Colors.black, size: 48.0),
//         // Change icon color to black and adjust size
//         backgroundColor: Colors.white, // Set the background color to white
//         title: const Text(
//           'R',
//           style: TextStyle(
//             color: Colors.black, // Set the text color to black
//             fontSize: 36, // Adjust the font size as needed
//             fontWeight: FontWeight.bold, // Make the text bold
//           ),
//         ),
//       ),
//
//       drawer: CustomDrawer(),
//
//       body: FutureBuilder<LatLng>(
//         future: getCurrentLocation(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child:
//                 CircularProgressIndicator()); // Show loading indicator while waiting for location
//           }
//           if (snapshot.hasError) {
//             return Center(
//                 child: Text("Error: ${snapshot.error}")); // Show error if any
//           }
//
//           // Update initial position to current location
//           final initialCameraPosition = CameraPosition(
//             target: snapshot.data ??
//                 const LatLng(0, 0), // Use current location or default
//             zoom: 17,
//           );
//
//           return GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: initialCameraPosition,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             mapType: MapType.satellite,
//             //mapType: MapType.normal,
//             //mapType: MapType.hybrid, // Set the map type to hybrid
//             markers: _markers,
//             // ... other properties ...
//           );
//         },
//       ),
//     );
//   }
// }
