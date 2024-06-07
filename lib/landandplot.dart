// landandplot.dart
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http; // Import this package
import 'package:permission_handler/permission_handler.dart';
import 'package:landandplot/place_details_screen.dart';
import 'package:landandplot/profile_page.dart';
import 'package:landandplot/property_details_display_page.dart';
import 'package:landandplot/property_list.dart';
import 'package:landandplot/services/direction_service.dart';
import 'package:landandplot/services/firestore_database_service.dart';
import 'package:landandplot/services/location_service.dart';
import 'package:landandplot/services/map_service.dart';
import 'package:landandplot/services/marker_cluster_service.dart';
import 'package:landandplot/services/property_data_service.dart';
import 'package:landandplot/screens/login_screen.dart';
import 'package:landandplot/proeprty_videos_list.dart';
import 'package:landandplot/services/property_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../custom_drawer.dart';
import 'data/marker_data.dart';
import 'package:fluster/fluster.dart';
import 'favourites_page.dart';
import 'filter_screen.dart';
import 'home_screen.dart';
import 'instances/google_maps_api_client.dart';
import 'models/cluster_item.dart';
import 'models/map_property_address.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:location/location.dart' as loc;
import 'package:geocoding_platform_interface/src/models/location.dart'
    as geo_location;

import 'models/property_info.dart';

late final double latitude;
late final double longitude;

final places = GoogleMapsPlaces(
    apiKey: 'AIzaSyCXMU535-AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc');

enum CustomMapType {
  normal,
  satellite,
  hybrid,
}

CustomMapType _currentMapType = CustomMapType.normal;

class LandandPlot extends StatefulWidget {
  const LandandPlot({Key? key}) : super(key: key);

  @override
  _LandandPlotState createState() => _LandandPlotState();
}

class _LandandPlotState extends State<LandandPlot> {
  int _selectedIndex = 0; // Now defined in this state class

  final TextEditingController _controller = TextEditingController();
  // GoogleMapController? mapController;
  late GoogleMapController _mapController;
  MapType mapType =
      MapType.normal; // Declare mapType and initialize it with a default value
  LatLng?
      selectedLocation; // Add this variable to store the selected location coordinates
  var uuid = const Uuid();
  String tokenForSession = '37465';
  bool mapCreated = false;
  Timer? _debounce; // Declare _debounce here
  FocusNode _focusNode = FocusNode();
  bool _isDropdownVisible = true;
  double _currentZoom = 14.0;
  CameraPosition _initialCameraPosition =
      const CameraPosition(target: LatLng(0, 0));
  late List<PropertyInfo> addresses; // Declare as a class member
  late List<MapPropertyAddress> mapPropertyAddresses = [];
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();
  List<String> _suggestions =
      []; // Define _suggestions as an empty list of strings
  String _selectedPlace = '';
  List<Map<String, dynamic>> listForPlaces = [];
  LatLng currentLocation = const LatLng(17.066886, 78.204222);
  double defaultLatitude = 17.066886; // Example: New York City latitude
  double defaultLongitude = 78.204222; // Example: New York City longitude

  String selectedPlaceName = ''; // Stores the name of the selected place.
  bool isLoading = false;
  bool isMapReady = false;
  bool _isMapVisible = true; // Default value, adjust based on your needs
  bool _isFlusterReady = false;

  Map<int, BitmapDescriptor> preGeneratedClusterIcons = {};
  // Set<Marker> _markers = {};
  Map<MarkerId, Marker> _markers = {};
  late Fluster<ClusterItem> fluster;
  // late Fluster<MapPropertyAddress>? fluster;
  List<ClusterItem> PropertyAddresses =
      []; // Populate this with a list of ClusterItem instances

  late FirestoreDatabaseService _firestoreDatabaseService;
  late LocationService _locationService;
  late DirectionsService _directionsService;
  // late MapService _mapService; // Hypothetical service if you have one
  late MarkerClusterService _markerClusterService;
  late PropertyDataService _propertyDataService;
  // When you have the user ID and want to navigate to FavoritesPage
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

// Inside an async method of your state class
  MarkerId markerId = MarkerId('marker_id_1'); // Example marker ID
  String imagePath = 'assets/icons/gps.png'; // Path to your asset image
  BitmapDescriptor? customIcon; // Declare customIcon at the class level
  late Future<List<PropertyInfo>> propertyList;
  final PropertyService _propertyService =
      PropertyService(); // Declaration of the service
  late GoogleMapsApiClient _apiClient;
  Map<String, dynamic>? placeDetails;

  Future<CameraPosition> _getInitialLocation() async {
    // Use the aliased geolocator class
    geolocator.LocationPermission permission =
        await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // If permissions are granted, proceed to get the location
    geolocator.Position currentLocation =
        await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high);
    return CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 14,
    );
  }

  @override
  void initState() {
    super.initState();

    _firestoreDatabaseService = FirestoreDatabaseService();
    _locationService = LocationService();
    _directionsService = DirectionsService(
        apiKey:
            'AIzaSyCXMU535-5XIMSMET7hHIe3a921bJu9ebM'); // Ensure API key is managed securely
    _markerClusterService = MarkerClusterService(_firestoreDatabaseService);
    _propertyDataService = PropertyDataService();
    _apiClient = GoogleMapsApiClient(
        apiKey:
            'AIzaSyCXMU535-5XIMSMET7hHIe3a921bJu9ebM'); // Consider fetching from secure storage

    _controller.addListener(() {
      onModify(_controller.text);
    });

    initializeMap();
    fetchPropertiesFromFirestore().then((properties) {
      _updateMarkers(properties);
    }).catchError((error) {
      print('Error fetching properties from Firestore: $error');
      // Handle errors appropriately, perhaps showing a user-friendly message or retry option
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      // This might be necessary if you're specifically setting up listeners tied to instance lifecycle
      onModify(_controller.text);
    });
    _apiClient.dispose();
    _controller.dispose();
    _focusNode.dispose(); // Dispose of the FocusNode if it's no longer needed
    _focusScopeNode.dispose(); // Ensure any scoped node is also disposed
    _debounce
        ?.cancel(); // Make sure to cancel any active timers to prevent leaks
    super.dispose();
  }

  Future<void> initializeMap() async {
    // Request location permission and update initial camera position
    await _requestLocationPermission(); // Ensure permissions are requested

    // Request location permission and update initial camera position
    final hasPermission = await _locationService.ensureLocationPermission();
    if (!hasPermission) {
      // Handle the case when permission is not granted
      print('Location permission not granted');
      return;
    }

    try {
      loc.LocationData? currentLocation =
          await _locationService.getCurrentLocation();
      if (currentLocation != null && mounted) {
        setState(() {
          LatLng position =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _initialCameraPosition = CameraPosition(
            target: position,
            zoom: 14.0,
          );
          // Move the map camera to the new position
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition),
          );
        });
      }
    } catch (e) {
      // Handle the error by showing an alert or logging it
      print('Error getting initial location: $e');
    }

    // Initialize map controller and prepare to fetch and display markers
    _controllerCompleter.future.then((controller) {
      if (mounted) {
        setState(() {
          _mapController = controller;
          isMapReady = true;
        });

        // Now that everything is initialized, fetch and display markers
        fetchAndInitializeMarkersAndClusters().then((_) {
          // If _fetchMarkers is still needed and doesn't interfere with Fluster
          // call it here, otherwise remove it.
          _fetchMarkers(); // Ensure this is called once all preparations are done
          setState(() => _isFlusterReady = true); // Mark Fluster as ready
        });
      }
    }).catchError((error) {
      print('Error initializing map controller: $error');
    });
  }

  Future<BitmapDescriptor> createCustomMarkerIcon(String iconPath) async {
    try {
      final ByteData bytes = await rootBundle.load(iconPath);
      final BitmapDescriptor bitmapDescriptor =
          BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
      print('Custom icon loaded successfully: $bitmapDescriptor'); // Debug log
      return bitmapDescriptor;
    } catch (e) {
      print('Failed to load custom icon: $e'); // Error log
      throw Exception(
          'Failed to load custom icon: $e'); // Throw an exception with a message
    }
  }

  Future<void> _fetchMarkers() async {
    final customIcon = await createCustomMarkerIcon('assets/icons/gps.png');
    FirebaseFirestore.instance.collection('properties').snapshots().listen(
      (snapshot) {
        snapshot.docs.forEach((doc) {
          var data = doc.data() as Map<String, dynamic>;
          var position = data['position'] as Map<String, dynamic>;
          if (position.containsKey('lat') && position.containsKey('lng')) {
            double lat = position['lat'];
            double lng = position['lng'];
            MarkerId markerId = MarkerId(doc.id);
            Marker marker = Marker(
              markerId: markerId,
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(title: data['price']),
              icon: customIcon,
            );
            setState(() {
              _markers[markerId] = marker;
            });
          } else {
            print(
                'Error: Document ${doc.id} does not have a valid "position" field.');
          }
        });
      },
      onError: (error) => print('Error listening to snapshot: $error'),
    );
  }

  Future<List<PropertyInfo>> fetchPropertiesFromFirestore() async {
    var propertiesCollection =
        FirebaseFirestore.instance.collection('properties');
    var snapshots = await propertiesCollection.get();
    return snapshots.docs
        .map((doc) => PropertyInfo.fromSnapshot(doc))
        .toList();
  }

  Future<void> _updateMarkers(List<PropertyInfo> properties) async {
    final markers = await convertPropertiesToMarkers(properties);  // Wait for the markers to be ready

    setState(() {
      _markers.clear();
      for (final marker in markers) {
        _markers[marker.markerId] = marker;  // Assuming _markers is a Map<MarkerId, Marker>
      }
    });
  }

  Future<Set<Marker>> convertPropertiesToMarkers(
      List<PropertyInfo> properties) async {
    var markers = <Marker>{};
    for (var property in properties) {
      var icon = await property.getIcon(); // Ensure icon is loaded
      markers.add(Marker(
        markerId: MarkerId(property.propertyId),
        position: LatLng(property.latitude, property.longitude),
        icon: icon, // Use the loaded icon
        infoWindow: InfoWindow(
            title: 'Property ${property.propertyId}',
            snippet: 'Price: ${property.price}'),
      ));
    }
    return markers;
  }

  Future<void> displayPropertiesOnMap() async {
    final properties = await fetchPropertiesFromFirestore();
    final markers = await Future.wait(properties.map((p) => p.toMarker()));

    setState(() {
      _markers.clear();
      markers.forEach((marker) {
        _markers[MarkerId(marker.markerId.value)] = marker;
      });
    });
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    print("Madhu Enter _requestLocationPermission method enter");
    if (status.isDenied) {
      print("Madhu Enter _requestLocationPermission method enter into if");
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.locationWhenInUse,
      ].request();
      print(statuses[Permission
          .locationWhenInUse]); // Prints the result of the request (PermissionStatus.granted or PermissionStatus.denied, etc.)
    }
    if (status.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this app.
      openAppSettings();
    }
  }

  void moveToLocation(String placeId) async {
    try {
      // Fetch the new location using the consolidated API client method
      LatLng newLocation = await _apiClient.fetchPlaceCoordinates(placeId);
      print("moveToLocation MapController is ready.:$newLocation");

      if (_mapController != null) {
        // Move the map camera to the new location with a zoom level of 14.0
        _mapController
            .animateCamera(CameraUpdate.newLatLngZoom(newLocation, 14.0));
      } else {
        print("MapController is not ready yet.");
      }
    } catch (e) {
      print("Error moving to the location: $e");
    }
  }

  // CLUSTERS // CLUSTERS // CLUSTERS

  Future<void> fetchAndInitializeMarkersAndClusters(
      [LatLng? searchedLocation]) async {
    // Determine the source of property addresses based on whether a searched location is provided
    print("Initializing Fluster:");

    List<PropertyInfo> propertyAddresses;
    if (searchedLocation != null) {
      // Fetch or filter property addresses near the searched location
      propertyAddresses = await fetchPropertyAddressesNearLocation(
          searchedLocation: searchedLocation);
    } else {
      // Fetch property addresses from Firestore
      propertyAddresses =
          await _propertyService.fetchPropertyInfoesFromFirestore(userId);
    }

    // Convert PropertyAddress objects to ClusterItem objects
    List<ClusterItem> clusterItems = propertyAddresses.map((address) {
      return ClusterItem(
        propertyId: address.propertyId,
        iconPath: '',
        latitude: address.latitude,
        longitude: address.longitude,
        userId: '',
        price: 0.0
        , propertyType: '',
        // Set other required fields based on your ClusterItem class
      );
    }).toList();

    // Initialize clusters with the ClusterItem objects
    await initFluster(clusterItems);

    // Optionally, reinitialize clusters with new markers if your application uses clustering
    await _updateClusterMarkers(); // Update cluster markers based on new data

    // If a searched location is provided, update the map camera to focus on that location
    if (searchedLocation != null && _mapController != null) {
      await _mapController
          .animateCamera(CameraUpdate.newLatLngZoom(searchedLocation, 15));
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    print("Madhu = _onMapCreated called");

    // Check if the widget is still mounted.
    if (!mounted) return;

    // Set the map controller.
    setState(() {
      _mapController = controller;
    });

    // Fetch your cluster items from Firestore or some local data source.
    List<ClusterItem> clusterItems = await getClusterItems();

    // Initialize Fluster with the cluster items.
    await initFluster(clusterItems);
    _updateClusterMarkers();

    // Mark the map as ready, if you have a flag for that.
    setState(() {
      isMapReady = true; // Only set this if you're tracking map readiness.
    });

    print("Madhu Map is ready and markers are set.");
  }

// Assuming this method is within your _LandandPlotState
//   Future<List<ClusterItem>> getClusterItems() async {
//     List<ClusterItem> items = [];
//     var querySnapshot =
//         await FirebaseFirestore.instance.collection('properties').get();
//
//     for (var doc in querySnapshot.docs) {
//       var data = doc.data() as Map<String, dynamic>;
//
//       var position =
//           data['position'] is GeoPoint ? data['position'] as GeoPoint : null;
//       if (position != null) {
//         // Convert GeoPoint to latitude and longitude
//         items.add(ClusterItem(
//           latitude: position.latitude,
//           longitude: position.longitude,
//           id: '',
//           iconPath: '',
//           userId: '',
//           // ... other properties
//         ));
//       }
//     }
//     return items;
//   }

  Future<List<ClusterItem>> getClusterItems() async {
    List<ClusterItem> items = [];
    var querySnapshot = await FirebaseFirestore.instance.collection('properties').get();

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      // Extract latitude and longitude directly.
      double? latitude = data['latitude'];
      double? longitude = data['longitude'];
      double? price = data['price'];  // Ensure price is defined and correctly typed

      // Ensure both latitude and longitude are not null before adding to cluster items.
      if (latitude != null && longitude != null && price != null) {
        items.add(ClusterItem(
          latitude: latitude,
          longitude: longitude,
          propertyId: doc.id,
          iconPath: data['iconPath'] ?? 'assets/icons/gps.png',  // Use default icon if none provided
          userId: data['userId'] ?? '',  // Use empty string if userId is not provided
          price: price,  // Correctly typed price
          propertyType: data['propertyType'] ?? '',  // Ensure propertyType is provided or defaulted
        ));
      }
    }

    return items;
  }

  Future<void> initFluster(List<ClusterItem> clusterItems) async {
    fluster = Fluster<ClusterItem>(
      minZoom: 0,
      maxZoom: 21,
      radius: 150, // radius of the clusters
      extent: 2048,
      nodeSize: 64,
      points: clusterItems, // pass your list of ClusterItem objects here
      createCluster:
          (BaseCluster? cluster, double? longitude, double? latitude) {
        if (cluster == null || longitude == null || latitude == null) {
          throw Exception('Cluster, longitude, or latitude is null');
        }
        return ClusterItem(
          latitude: latitude,
          longitude: longitude,
          propertyId: 'cluster_${cluster.id}',
          isCluster: true,
          clusterId: cluster.id,
          pointsSize: cluster.pointsSize,
          // other properties as necessary...
          childMarkerId: '',
          price: 0.0,
          userId: '',
          iconPath: '',
          propertyType: '',
        );
      },
    );
    // Now that Fluster is initialized, you can update your markers
    await _updateClusterMarkers();
  }

  Future<void> _updateClusterMarkers() async {
    print("Entering _updateClusterMarkers");
    if (mapController == null || fluster == null) {
      print("MapController or Fluster is not initialized.");
      return;
    }

    final double zoom = await mapController!.getZoomLevel();
    final bounds = await mapController!.getVisibleRegion();
    final bbox = [
      bounds.southwest.longitude,
      bounds.southwest.latitude,
      bounds.northeast.longitude,
      bounds.northeast.latitude,
    ];

    // Define a zoom threshold for fetching individual properties
    const int zoomThreshold = 14;

    Map<MarkerId, Marker> newMarkers = {};

    if (zoom > zoomThreshold) {
      // Zoom level is high enough to fetch individual properties
      var properties = await fetchPropertiesFromFirestore();
      for (var property in properties) {
        final markerId = MarkerId(property.propertyId.toString());
        newMarkers[markerId] = Marker(
          markerId: markerId,
          position: LatLng(property.latitude, property.longitude),
          icon: BitmapDescriptor.defaultMarker, // Customize as needed
          onTap: () => print("Tapped property ${property.propertyId}"),
        );
      }
    } else {
      // Use clusters at lower zoom levels
      final clusters = fluster!.clusters(bbox, zoom.toInt());
      print("Clusters count at zoom level $zoom: ${clusters.length}");

      for (var cluster in clusters) {
        final markerId = MarkerId(cluster.propertyId.toString());

        if (cluster.isCluster) {
          // Handling cluster marker
          BitmapDescriptor icon =
              await _createCustomClusterIcon(cluster.pointsSize);
          newMarkers[markerId] = Marker(
            markerId: markerId,
            position: LatLng(cluster.latitude, cluster.longitude),
            icon: icon,
            onTap: () {
              double newZoom = (zoom < 19) ? zoom + 2 : 19;
              mapController!.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(cluster.latitude, cluster.longitude), newZoom));
            },
          );
        } else {
          // Handling individual marker
          newMarkers[markerId] = Marker(
            markerId: markerId,
            position: LatLng(cluster.latitude, cluster.longitude),
            icon: BitmapDescriptor
                .defaultMarker, // Use default marker for individuals
            onTap: () => print("Tapped on individual marker ${cluster.propertyId}"),
          );
        }
      }
    }

    setState(() {
      _markers = newMarkers;
      print("Updated markers count: ${_markers.length}");
    });
  }

  Future<void> preloadClusterIcons(List<int> clusterSizes) async {
    for (var size in clusterSizes) {
      // Generate and store the custom icon for each cluster size
      preGeneratedClusterIcons[size] = await _createCustomClusterIcon(size);
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> _createCustomClusterIcon(int clusterSize,
      {int iconSize = 100}) async {
    // Original size
    final double originalSize =
        70.0; // The original diameter of the icon as double
    // Double the size of the icon for a larger circle
    final double size = originalSize *
        2; // The new diameter of the icon will be twice the original
    // Define the outer radius with some padding for the shade
    final double padding = 10.0; // the padding for the shade as double
    final double outerRadius = (size / 2) + padding; // Calculate as double

    // Define the paint for the transparent shade
    final Paint shadePaint = Paint()
      ..color = Colors.blue.withAlpha(
          100) // Set the color with alpha for transparency, e.g., 100 out of 255
      ..style = PaintingStyle.stroke // Draw only the outline of the circle
      ..strokeWidth = padding.toDouble(); // The thickness of the shade

    // Create a PictureRecorder to record the canvas operations
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Draw the larger circle for the transparent round shade
    canvas.drawCircle(
      Offset(size / 2, size / 2), // Center of the canvas
      outerRadius, // Radius including the padding
      shadePaint, // Paint defined for the shade
    );
    final Paint paint = Paint()..color = Colors.green;

    // Now draw the main circle on top of the shade
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2, // The radius of the main circle
      paint, // The paint for the main circle
    );

    // Define the TextPainter
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: clusterSize.toString(),
        style: TextStyle(
          fontSize: size / 3, // Choose the font size
          color: Colors.white, // Choose the text color
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

// Layout the TextPainter to calculate the size of the text
    textPainter.layout();

// Calculate the center position
    final double textX = (size - textPainter.width) / 2;
    final double textY = (size - textPainter.height) / 2;

// Now paint the text onto the canvas at the center position
    textPainter.paint(canvas, Offset(textX, textY));

    // If size is a double, round it to the nearest integer
    final int intSize = size.round();
    // Convert the canvas to an image with the integer size
    final ui.Image image =
        await pictureRecorder.endRecording().toImage(intSize, intSize);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    // Make sure byteData is not null before using it
    // If byteData is null, log an error and return a default icon
    if (byteData != null) {
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Convert the image to a BitmapDescriptor
      return BitmapDescriptor.fromBytes(pngBytes);
    } else {
      // Log an error message or handle the error as appropriate for your app
      debugPrint("Madhu Failed to convert the image to byte data.");

      // Return a default icon
      // This could be a pre-defined icon or a BitmapDescriptor.defaultMarker
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<BitmapDescriptor> createCustomIcon(String price) async {
    // Create a PictureRecorder to record the canvas operations
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..color = Colors.green; // The color of the circle
    const double size = 180; // The size of the icon

// Define the size of the rectangle
    const double width = 200; // The width of the rectangle
    const double height = 90; // The height of the rectangle
    const double radius = 30; // The radius of the rounded corners

// Let's say you want the rectangle to be at the center of the canvas
    final Rect rect = Rect.fromCenter(
      center: Offset(size / 2, size / 2), // Center of the canvas
      width: width, // Width of the rectangle
      height: height, // Height of the rectangle
    );

    // Create an RRect from the Rect and the radius for corners
    final RRect roundedRect =
        RRect.fromRectAndRadius(rect, Radius.circular(radius));

// Now draw the rounded rectangle on the canvas
    canvas.drawRRect(roundedRect, paint);

    // Define the text style for your text
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: size / 4, // Adjust as needed
      fontWeight: FontWeight.bold,
    );

    TextSpan textSpan = TextSpan(
      text: price,
      style: textStyle,
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size,
    );

    // Position the text in the center of the canvas
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    // Convert the canvas to an image
    final ui.Image image = await pictureRecorder.endRecording().toImage(
          size.toInt(),
          size.toInt(),
        );
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to get byte data of the image');
    }
    final Uint8List pngBytes = byteData.buffer.asUint8List();

    // Create a BitmapDescriptor from the image byte data
    return BitmapDescriptor.fromBytes(pngBytes);
  }

  Set<Marker> getMarkersForCurrentBounds(double currentZoom) {
    // Assuming you have bbox and currentZoom defined correctly
    List<double> bbox = [-180.0, -85.0, 180.0, 85.0];
    int currentZoom = 12; // Example current zoom level
    return fluster.clusters(bbox, currentZoom).map((cluster) {
      return Marker(
        markerId: MarkerId(cluster.propertyId.toString()),
        position: LatLng(cluster.latitude, cluster.longitude),
        icon: cluster.icon,
        infoWindow: InfoWindow(
          title: cluster.isCluster
              ? '${cluster.pointsSize} properties'
              : cluster.price.toString(),  // Convert price to String
          snippet: cluster.isCluster ? 'Cluster' : 'Property',
        ),
        // Set the onTap function if necessary
      );
    }).toSet();
  }

  // CLUSTERS // CLUSTERS // CLUSTERS CLOSED

  Future<List<MapPropertyAddress>> fetchAndPrepareMarkers(
      {LatLng? nearLocation, double radiusInKm = 10.0}) async {
    print("Madhu = I am in fetchAndPrepareMarkers called");
    // Assume fetchPropertyAddresses() is asynchronous and returns a Future<List<PropertyAddress>>
    var propertyAddresses =
        await _propertyService.fetchPropertyInfoesFromFirestore(userId);
    // Filter property addresses if a nearLocation is provided
    List<PropertyInfo> filteredAddresses = nearLocation != null
        ? propertyAddresses.where((address) {
            // Calculate distance from the address to nearLocation
            double distance = geolocator.Geolocator.distanceBetween(
                  nearLocation.latitude,
                  nearLocation.longitude,
                  address.latitude, // directly using latitude
                  address.longitude, // directly using longitude
                ) /
                1000; // Distance in kilometers
            // Keep the address if within the specified radius
            return distance <= radiusInKm;
          }).toList()
        : propertyAddresses; // Use all addresses if no nearLocation is provided
    // Convert filtered addresses to MapPropertyAddress
    List<MapPropertyAddress> mapPropertyAddresses =
        filteredAddresses.map((address) {
      return MapPropertyAddress(
        propertyId: address.propertyId,
        position: LatLng(address.latitude, address.longitude),
        icon: BitmapDescriptor
            .defaultMarker, // Use default marker if icon is null
        price: '',
        // You may need to adjust other properties accordingly
      );
    }).toList();
    print(
        "Madhu fetchAndPrepareMarkers Filtered Map Property Addresses: $mapPropertyAddresses");
    return mapPropertyAddresses; // Return the prepared list of
  }

  Future<List<PropertyInfo>> fetchPropertyAddressesNearLocation({
    required LatLng searchedLocation,
    double radiusInKm = 5.0,
  }) async {
    List<PropertyInfo> allPropertyAddresses =
        await _propertyService.fetchPropertyInfoesFromFirestore(userId);
    List<PropertyInfo> filteredAddresses =
        allPropertyAddresses.where((address) {
      // Use the aliased geolocator class
      double distance = geolocator.Geolocator.distanceBetween(
            searchedLocation.latitude,
            searchedLocation.longitude,
            address.latitude, // directly using latitude
            address.longitude, // directly using longitude
          ) /
          1000;
      return distance <= radiusInKm;
    }).toList();

    return filteredAddresses;
  }

  List<ClusterItem> convertMapPropertyAddressesToClusterItems(
      List<MapPropertyAddress> addresses) {
    return addresses.map((address) {
      // Assuming MapPropertyAddress has properties like id, position.latitude, position.longitude, and icon
      return ClusterItem(
        propertyId: address.propertyId, // Assuming propertyId is the equivalent of id
        latitude: address.position.latitude,
        longitude: address.position.longitude,
        // icon: address.icon,
        userId: '', iconPath: '',
        price: 0.0,
        propertyType: '', // Default or compute as necessary
      );
    }).toList();
  }

  // Fetching property from Firestore
// end of Firestore accessing of marker to display on Map

  void handleOnTap(String propertyId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PropertyDetailsDisplayPage(propertyId: propertyId),
      ),
    );
    print('Madhu Tapped on property: $propertyId');
  }

  void _onCameraMove(CameraPosition position) {
    // Update the state with the new zoom level
    setState(() {
      _currentZoom = position.zoom;
    });
    print('Madhu Current zoom level: ${position.zoom}');
  }

  void _onCameraIdle() async {
    print("1 Camera is idle");
    if (mapController == null) {
      print("Madhu MapController is not initialized");
      return;
    }
    // Safe to call getZoomLevel as mapController is checked for null
    final double zoomLevel = await mapController!.getZoomLevel();
    final bounds = await mapController!.getVisibleRegion();
    print('Madhu Camera is idle at zoom level: $zoomLevel');
    print('Madhu Visible bounds: ${bounds.southwest} to ${bounds.northeast}');

    // Now that we know mapController is not null, it's safe to call _updateClusterMarkers
    await _updateClusterMarkers(); // Use await to ensure complete execution before proceeding
  }

  Future<LatLng?> getCurrentLocation() async {
    try {
      bool serviceEnabled =
          await geolocator.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      geolocator.LocationPermission permission =
          await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        if (permission == geolocator.LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == geolocator.LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocator.LocationAccuracy.high);

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error fetching location: $e');
      return null;
    }
  }

  GoogleMapController get mapController {
    if (_mapController == null) {
      throw Exception("MapController is not initialized");
    }
    return _mapController;
  }

  Future<String?> fetchPlaceId(String input) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String apiKey =
        'AIzaSyCXMU535-AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc';
    print('I am in fetchPlaceId');

    final response = await http.get(
        Uri.parse('$baseUrl?input=${Uri.encodeComponent(input)}&key=$apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final placeId = jsonResponse['predictions'].isNotEmpty
          ? jsonResponse['predictions'][0]['place_id']
          : null;

      // Print the place_id value to the console.
      print('fetchPlaceId Obtained place_id: $placeId');

      return placeId;
    } else {
      // It's helpful to print the status code if the request failed.
      print(
          'fetchPlaceId Failed to fetch place ID, HTTP status code: ${response.statusCode}');
    }
    return null;
  }

  Future<List<String>> makeSuggestion(
      String input, Function(String) onSelectPlace) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String apiKey =
        'AIzaSyCXMU535-AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc';
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl?input=${Uri.encodeComponent(input)}&key=$apiKey'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Extract the descriptions (place names) from the predictions
        List<String> suggestions = List<String>.from(jsonResponse['predictions']
            .map((prediction) => prediction['description']));

        // For each suggestion, call onSelectPlace with the corresponding placeId
        jsonResponse['predictions'].forEach((prediction) {
          onSelectPlace(prediction['place_id']);
        });

        // Return the list of descriptions (place names)
        return suggestions;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return [];
      }
    } catch (e) {
      print('An error occurred: $e');
      return [];
    }
  }

  void _handleMapTap(LatLng latLng) {
    // Create a unique MarkerId using the latitude and longitude
    MarkerId markerId = MarkerId(latLng.toString());

    // Create a new marker
    Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: InfoWindow(
        title: 'Selected Location',
        snippet: '${latLng.latitude}, ${latLng.longitude}',
      ),
    );

    // Update the state with the new marker
    setState(() {
      //_markers.clear(); // Uncomment if you want to allow only one marker at a time
      _markers[markerId] = marker; // Correct way to add a marker to a Map
    });

    // Optionally, move the camera to the tapped position
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 14.0,
        ),
      ),
    );
  }

  Future<void> _selectPlace(String placeDescription) async {
    print('Madhu = Selecting place in _selectPlace: $placeDescription');
    List<LatLng> locations = await getLocationCoordinates(placeDescription);

    if (locations.isNotEmpty) {
      LatLng location = locations.first;
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(location, 14.0),
      );
      setState(() {
        _markers.clear(); // Clear existing markers if necessary
        MarkerId markerId = MarkerId(
            location.toString()); // Create a unique marker id based on location
        _markers[markerId] = Marker(
          // Correctly add to the Map
          markerId: markerId,
          position: location,
          infoWindow: InfoWindow(title: placeDescription),
        );
        // Clear the suggestions and hide the dropdown
        listForPlaces = [];
        _isDropdownVisible = false;
        _controller.clear(); // Clear the search bar text
        FocusScope.of(context).unfocus(); // Hide the keyboard
      });
    } else {
      // Handle case where no location is found
      print('Madhu No location found for $placeDescription');
      // You can show a snackbar or display an error message to the user
    }
  }

  void openSelectedLocation(LatLng coordinates) {
    print("Attempting to navigate to coordinates: $coordinates");

    if (_mapController != null) {
      final CameraPosition position =
          CameraPosition(target: coordinates, zoom: 14.0);
      _mapController!
          .animateCamera(CameraUpdate.newCameraPosition(position))
          .then((result) {
        print("Camera animation completed.");
      }).catchError((e) {
        print("Failed to animate camera: $e");
      });
    } else {
      print("Map controller is not initialized.");
    }
  }

  List<String> readPlaceIdFromResponse(String responseBody) {
    final response = jsonDecode(responseBody);
    List<String> placeIds = [];
    if (response['predictions'] != null && response['predictions'].isNotEmpty) {
      for (var prediction in response['predictions']) {
        final String placeId = prediction['place_id'];
        placeIds.add(placeId); // Add the placeId to the list
        print('Place ID: $placeId');
      }
    } else {
      print('No predictions found');
    }
    return placeIds; // Return the list of place IDs
  }

  void onModify(String input) {
    print('I am in onModify');
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (input.isEmpty) {
        setState(() {
          listForPlaces = [];
          _isDropdownVisible = false; // Hide the dropdown
        });
      } else {
        try {
          // Show loading or a similar state to indicate progress
          setState(
              () => isLoading = true); // Assuming you have an `isLoading` state
          Iterable<String> suggestions =
              await makeSuggestion(input, onSelectPlace);
          List<Map<String, dynamic>> suggestionsMaps = suggestions
              .map((suggestion) => {"description": suggestion})
              .toList();

          setState(() {
            listForPlaces = suggestionsMaps; // Update the list for the UI
            _isDropdownVisible = true; // Show the dropdown
            isLoading = false; // Hide loading indicator
          });
        } catch (error) {
          // Handle the error (e.g., by showing an error message to the user)
          print('Error fetching suggestions: $error');
          setState(() => isLoading = false);
        }
      }
    });
  }

  void _onMarkerTap(String propertyId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PropertyDetailsDisplayPage(propertyId: propertyId),
      ),
    );
  }

  void _handleTapOutside() {
    // Unfocus any focused input fields
    _focusScopeNode.unfocus();
  }

// WORKING FROM HERE
  void onSelectPlace(String selectedPlace) async {
    print("Selected place ID: $selectedPlace");
    try {
      // Fetch coordinates from the place ID using the GoogleMapsApiClient
      LatLng coordinates =
          await _apiClient.fetchPlaceCoordinates(selectedPlace);
      print(
          'Fetched Coordinates: Latitude: ${coordinates.latitude}, Longitude: ${coordinates.longitude}');

      // Optionally center the map on the selected location
      _mapController
          ?.animateCamera(CameraUpdate.newLatLngZoom(coordinates, 14.0));
      print(
          'Map centered on: Latitude: ${coordinates.latitude}, Longitude: ${coordinates.longitude}');

      // Update the state to include the new marker
      setState(() {
        _markers[MarkerId(selectedPlace)] = Marker(
          markerId: MarkerId(selectedPlace),
          position: coordinates,
          infoWindow:
              InfoWindow(title: "Selected Place"), // Customizable window title
        );
      });
    } catch (e) {
      print("Error fetching coordinates: $e");
    }
  }

  Future<LatLng> fetchCoordinatesFromPlaceId(String placeId) async {
    print('I am in fetchCoordinatesFromPlaceId');
    final String apiKey =
        'AIzaSyCXMU535-AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc';
    final String apiUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${Uri.encodeComponent(placeId)}&fields=geometry&key=$apiKey";
    print('fetchCoordinatesFromPlaceId value placeId: $placeId');
    // print('fetchCoordinatesFromPlaceId value place_id 2: $place_id');

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'OK') {
          final result = jsonResponse['result'];
          final geometry = result['geometry'];
          final location = geometry['location'];
          final latitude = location['lat'] as double;
          final longitude = location['lng']
              as double; // Ensure latitude and longitude are double values
          print(
              'fetchCoordinatesFromPlaceId Latitude: $latitude, fetchCoordinatesFromPlaceId Longitude: $longitude');
          print(
              'fetchCoordinatesFromPlaceId result: $result, geometry: $geometry, location: $location'); // Print latitude and longitude
          print(
              'fetchCoordinatesFromPlaceId API Response Status: ${jsonResponse['status']}');
          print(
              'fetchCoordinatesFromPlaceId HTTP Status Code: ${response.statusCode}');

          return LatLng(latitude, longitude);
        } else {
          // Handle API error response
          final errorMessage =
              jsonResponse['error_message'] ?? 'Unknown error occurred.';
          print('fetchCoordinatesFromPlaceId API Error: $errorMessage');
          throw Exception(
              'fetchCoordinatesFromPlaceId API Error: $errorMessage');
        }
      } else {
        // Handle HTTP error response
        print(
            'fetchCoordinatesFromPlaceId Failed to fetch coordinates, HTTP status code: ${response.statusCode}');
        throw Exception(
            'fetchCoordinatesFromPlaceId Failed to fetch coordinates, HTTP status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or unexpected exceptions
      print('Error in fetchCoordinatesFromPlaceId: $e');
      throw Exception(
          'fetchCoordinatesFromPlaceId Failed to fetch coordinates: $e');
    }
  }

  Future<LatLng> _convertPlaceToCoordinates(String placeId) async {
    print('I am in _convertPlaceToCoordinates');
    // Replace with your actual API endpoint and API key.
    final String apiKey =
        'AIzaSyCXMU535-AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc';
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));
    print('_convertPlaceToCoordinates Response Status: ${response.statusCode}');
    print('_convertPlaceToCoordinates Response Body: ${response.body}');
    print('_convertPlaceToCoordinates Response response: $response');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final location = jsonResponse['result']['geometry']['location'];
      final double lat = location['lat'];
      final double lng = location['lng'];
      print('Latitude: $lat, Longitude: $lng'); // Print latitude and longitude
      return LatLng(lat, lng);
    } else {
      throw Exception(
          '_convertPlaceToCoordinates Failed to fetch coordinates for place ID: $placeId, Status Code: ${response.statusCode}');
    }
  }

  void openGoogleMaps(LatLng coordinates) {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}';
    launch(googleMapsUrl);
  }

  Widget AutocompleteListView(List<String> _suggestions, String _selectedPlace,
      {required List<String> listForPlaces,
      required Function(String) onSelectPlace}) {
    return ListView.builder(
      itemCount: listForPlaces.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(listForPlaces[index]),
          onTap: () {
            onSelectPlace(listForPlaces[
                index]); // Call the onSelectPlace function with the selected place
          },
        );
      },
    );
  }

  void _onItemTapped(int index) {
    print('Bottom nav item tapped: $index'); // Debug: print the tapped index
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userId: '',)),
        );
        break;
      case 1:
        // Navigate to Profile Screen  ProfilePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 2:
        // Navigate to Favorites Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FavoritesPage(userId: userId)),
        );
        break;
      case 3:
        // Navigate to Videos Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PropertyVideosList()),
        );
        break;
      case 4:
        // Navigate to Search Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  Widget build(BuildContext context) {
    Set<Marker> markers = Set.from(listMarkers(_onMarkerTap));
    final List<Widget> _widgetOptions = <Widget>[
      HomeScreen(userId: '',),
      ProfilePage(),
      FavoritesPage(
        userId: userId,
      ),
      PropertyVideosList(),
      LoginScreen()
    ];
    return GestureDetector(
      onTap: () {
        print('Madhu GestureDetector screen1'); // Add this print statement
        // This will dismiss the keyboard and the dropdown when the user taps anywhere outside the dropdown.
        FocusScope.of(context).unfocus();
        setState(() {
          _isDropdownVisible = false;
        });
        print('Madhu GestureDetector screen2'); // Add this print statement

        // Check if _selectedPlace is not null before assigning it to a non-nullable variable
        if (_selectedPlace != null) {
          _convertPlaceToCoordinates(_selectedPlace).then((LatLng coordinates) {
            // Now `coordinates` is available
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetailsScreen(
                  placeId: _selectedPlace,
                  coordinates: coordinates,
                ),
              ),
            );
            _selectedPlace = ''; // Resetting _selectedPlace if needed
          }).catchError((error) {
            print("Error fetching coordinates: $error");
            // Handle error
          });
        }
        _handleMapTap(LatLng(0, 0));
        _handleTapOutside();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black, size: 40.0),
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'LANDANDPLOT',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Use Navigator to push to the PropertyList route
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PropertyList()),
                  );
                },
                child: Text(
                  _isMapVisible ? 'LIST' : 'MAP',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight:
                        _isMapVisible ? FontWeight.bold : FontWeight.normal,
                    fontSize:
                        _isMapVisible ? 20 : 18, // Larger font size for 'LIST'
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            Container(
              // padding: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),

              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  List<String> suggestions = [];

                  // Invoke makeSuggestion to fetch suggestions based on the user input
                  try {
                    suggestions = await makeSuggestion(
                        textEditingValue.text, onSelectPlace);
                  } catch (e) {
                    print('Error fetching suggestions: $e');
                    // Handle error
                  }

                  return suggestions;
                },
                onSelected: (String placeId) async {
                  print('I am in onSelected');
                  print(
                      "Madhu enter onSelected during async operation with placeId: $placeId");
                  try {
                    LatLng coordinates = await fetchCoordinatesFromPlaceId(
                        placeId); // use the correct variable name here
                    openSelectedLocation(coordinates);
                  } catch (e) {
                    print("Madhu Error onSelected during async operation: $e");
                  }
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onEditingComplete) {
                  // Build the input field for the Autocomplete widget
                  // This is where the user types their search query
                  print('I am in fieldViewBuilder');

                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    decoration: InputDecoration(
                      // labelText: 'Search place',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  );
                },
                optionsViewBuilder:
                    (context, Function(String) onPlaceSelected, options) {
                  // Build the dropdown list of autocomplete options
                  // This is where the suggested places are displayed as the user types
                  print('I am in fieldViewBuilder 2');

                  return Material(
                    elevation: 4.0,
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          title: Text(option),
                          onTap: () {
                            print('I am in fieldViewBuilder 3');
                            // When a place is tapped in the dropdown list, trigger the onPlaceSelected callback
                            onPlaceSelected(option);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Inserting a new Container for the filter row right below the search bar
            // Filters row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: Icon(Icons.filter_list, color: Colors.black),
                label: Text(
                  "Filters",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                // In the onPressed for the filter icon button:
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FilterScreen()),
                  );
                },
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    // onMapCreated: (GoogleMapController controller) {
                    //   setState(() {
                    //     _mapController = controller;
                    //   });
                    // },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(17.067091, 78.204393),
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    // markers: _markers,
                    // markers: Set<Marker>.from(_markers.values),  // Convert the map's values to a set
                    // markers: Set<Marker>.of(_markers.values), // Using the markers from the Map
                    markers: _markers.values.toSet(),
                    onTap: _handleMapTap,
                    onCameraMove: _onCameraMove,
                    onCameraIdle: _onCameraIdle,
                  ),
                  if (_isDropdownVisible && listForPlaces.isNotEmpty)
                    AutocompleteListView(
                      _suggestions,
                      _selectedPlace,
                      listForPlaces: listForPlaces
                          .map((place) => place.toString())
                          .toList(),
                      onSelectPlace: (selectedPlace) {
                        print(
                            'Selected place from AutocompleteListView: $selectedPlace');
                        _selectPlace(
                            selectedPlace); // Call your _selectPlace function here
                      },
                    ),
                  if (listForPlaces.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 200,
                        color: Colors.white,
                        child: ListView.builder(
                          itemCount: listForPlaces.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(listForPlaces[index]['description']),
                              onTap: () async {
                                List<LatLng> selectedLocations =
                                    await getLocationCoordinates(
                                        listForPlaces[index]['description']);
                                if (selectedLocations.isNotEmpty) {
                                  LatLng selectedLocation =
                                      selectedLocations.first;
                                  _mapController?.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      selectedLocation,
                                      14.0,
                                    ),
                                  );
                                }
                                _controller.text =
                                    listForPlaces[index]['description'];
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  listForPlaces = [];
                                  selectedLocation = null;
                                  _controller.clear();
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  // ... rest of your code ...
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.map),
                          onPressed: () {
                            setState(() {
                              _currentMapType = CustomMapType.normal;
                              mapType = _getMapType(
                                  _currentMapType); // Call _getMapType here
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.satellite),
                          onPressed: () {
                            setState(() {
                              _currentMapType = CustomMapType.satellite;
                              mapType = _getMapType(
                                  _currentMapType); // Call _getMapType here
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.layers),
                          onPressed: () {
                            setState(() {
                              _currentMapType = CustomMapType.hybrid;
                              mapType = _getMapType(
                                  _currentMapType); // Call _getMapType here
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_label),
              label: 'Videos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.blue[500],
          // Add this
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  MapType _getMapType(CustomMapType mapType) {
    switch (mapType) {
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

  Future<List<LatLng>> getLocationCoordinates(String placeName) async {
    try {
      List<geo_location.Location> locations =
          await locationFromAddress(placeName);
      List<LatLng> latLngList = locations.map((location) {
        if (location.latitude != null && location.longitude != null) {
          return LatLng(location.latitude!, location.longitude!);
        } else {
          throw Exception('Invalid location data');
        }
      }).toList();
      return latLngList;
    } catch (e) {
      print('Madhu Error fetching location coordinates: $e');
      return [];
    }
  }
}
