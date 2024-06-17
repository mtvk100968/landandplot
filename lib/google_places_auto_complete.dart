// google_places_auto_complete.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:landandplot/property_details_display_page.dart';
import 'package:landandplot/services/places_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../custom_drawer.dart';
import 'data/marker_data.dart';
import 'models/map_property_info.dart';

enum CustomMapType {
  normal,
  satellite,
  hybrid,
}

CustomMapType _currentMapType = CustomMapType.normal;

class GooglePlacesAutoComplete extends StatefulWidget {
  final PlacesService placesService; // Add this property

  const GooglePlacesAutoComplete({Key? key, required this.placesService})
      : super(key: key);
  @override
  _GooglePlacesAutoCompleteState createState() =>
      _GooglePlacesAutoCompleteState();
}

class _GooglePlacesAutoCompleteState extends State<GooglePlacesAutoComplete> {
  final TextEditingController _controller = TextEditingController();
  GoogleMapController? mapController;
  // Import marker data part 1 line 1
  Set<Marker> _markers = {};
  LatLng?
      selectedLocation; // Add this variable to store the selected location coordinates
  var uuid = Uuid();
  String tokenForSession = '37465';
  List<dynamic> listForPlaces = [];
  bool mapCreated = false;
  LatLng? currentLocation; // Make currentLocation nullable
  late GoogleMapController _mapController;
  Timer? _debounce; // Declare _debounce here
  FocusNode _focusNode = FocusNode();
  bool _isDropdownVisible = true;
// Define a default zoom level for your map.
  static const double DEFAULT_ZOOM_LEVEL = 14.0;

  static const double DEFAULT_LATITUDE =
      28.6139; // Default latitude for New Delhi
  static const double DEFAULT_LONGITUDE =
      77.2090; // Default longitude for New Delhi

  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(
        DEFAULT_LATITUDE, DEFAULT_LONGITUDE), // Provide default coordinates
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();

    // Assuming you have a method to fetch the current location or a default position
    _getInitialLocation().then((initialPosition) {
      if (initialPosition != null) {
        // Set the initial camera position to the fetched position
        _initialCameraPosition = CameraPosition(
          target: initialPosition, // This should be a LatLng object
          zoom:
              DEFAULT_ZOOM_LEVEL, // Define this constant with your desired default zoom level
        );

        // Now we update the map controller to the initial position
        mapController?.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition));
      }

      // Fetch initial markers, for example, from a network request or local data
      _fetchInitialMarkers().then((fetchedMarkers) {
        if (fetchedMarkers != null) {
          // If you're using a clustering library, initialize it with the fetched markers
          _initializeClustering(fetchedMarkers);

          // Add markers to the state
          setState(() {
            _markers.addAll(fetchedMarkers);
          });

          // Update clusters after setting markers
          _updateClusterMarkers();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // Dispose of the FocusNode
    super.dispose();
    _debounce?.cancel();
  }

  void _initMap() async {
    // Set some initial properties for the map
    _initialCameraPosition = CameraPosition(
      target: LatLng(DEFAULT_LATITUDE,
          DEFAULT_LONGITUDE), // These could be defined elsewhere
      zoom: 10,
    );

    // Fetch markers or points of interest to display on the map
    await _fetchMarkers();

    // Set up any listeners or additional configurations for the map
  }

  Future<List<Marker>> _fetchMarkers() async {
    // This is a placeholder for your fetching logic.
    // For example, you might make an HTTP request to your backend to retrieve locations
    // and then convert them into a list of Marker objects.
    List<Marker> markers = [];

    // Example fetch from a server
    var response = await http.get(Uri.parse('your_endpoint_here'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      for (var item in data) {
        LatLng position = LatLng(item['latitude'], item['longitude']);
        markers.add(
          Marker(
            markerId: MarkerId(item['id'].toString()),
            position: position,
            infoWindow:
                InfoWindow(title: item['title'], snippet: item['description']),
            // Additional Marker properties
          ),
        );
      }
    } else {
      // Handle error or empty data
      print('Failed to fetch markers.');
    }

    return markers;
  }

  Future<void> initializeMapWithCurrentLocation() async {
    try {
      // Get the current position with high accuracy.
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Convert the Position to a LatLng object.
      LatLng initialPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);

      // Check if mapController is initialized
      if (mapController != null) {
        // Set the initial camera position and animate the camera to this position.
        CameraPosition _initialCameraPosition = CameraPosition(
          target: initialPosition,
          zoom:
              DEFAULT_ZOOM_LEVEL, // Ensure DEFAULT_ZOOM_LEVEL is defined somewhere
        );
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        );

        // Fetch and update markers after ensuring mapController is ready.
        List<Marker> markers =
            await _getMarkersFromServer(); // Make sure this method is implemented and returns a list of markers
        // Initialize clustering with the markers if needed.
        await _initializeClustering(
            markers); // Ensure this method is correctly implemented
        // Update the map to show the clusters.
        _updateClusterMarkers(); // Make sure this updates the UI correctly
      } else {
        print('MapController is not initialized');
      }
    } catch (e) {
      // Handle any errors here
      print('Error initializing map with current location: $e');
    }
  }

  Future<List<Marker>> _fetchInitialMarkers() async {
    try {
      // Fetch markers somehow, e.g., from a network request
      List<Marker> markers = await _getMarkersFromServer();
      return markers;
    } catch (e) {
      // Handle the error by logging and rethrowing or returning an empty list
      print('Error fetching markers: $e');
      throw e; // or return <Marker>[];
    }
  }

  Future<List<Marker>> _getMarkersFromServer() async {
    var url = Uri.parse('YOUR_BACKEND_ENDPOINT');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // Assuming data is a list of markers in your expected format
      List<Marker> markers = [];
      for (var item in data) {
        var marker = Marker(
          markerId: MarkerId(item['id'].toString()),
          position: LatLng(item['latitude'], item['longitude']),
          infoWindow:
              InfoWindow(title: item['title'], snippet: item['snippet']),
          // Optionally handle onTap, icon and other properties
        );
        markers.add(marker);
      }
      return markers;
    } else {
      throw Exception('Failed to load markers');
    }
  }

  // // Assume this method is part of a MapController or similar class that handles map logic.
  // Future<void> _updateMarkers() async {
  //   final propertyAddresses = await getPropertyAddresses(); // Fetch data from a repository or API.
  //   final mapPropertyAddresses = convertToMapPropertyAddresses(propertyAddresses);
  //
  //   // Initialize your clustering service with mapPropertyAddresses.
  //   final clusteringService = ClusteringService(mapPropertyAddresses);
  //   final clusters = clusteringService.getClusters();
  //
  //   // Convert clusters to markers.
  //   final markers = clusters.map((cluster) {
  //     if (cluster.isCluster) {
  //       // Create a cluster marker.
  //       return cluster.toClusterMarker();
  //     } else {
  //       // Convert the MapPropertyAddress to a marker.
  //       return cluster.toMarker();
  //     }
  //   }).toList();
  //
  //   // Now, you have a list of markers ready to be displayed on the map.
  //   setState(() {
  //     _markers = markers.toSet();
  //   });
  // }

  Future<void> _initializeClustering(List<Marker> markers) async {
    // Implementation to initialize clustering with the fetched markers.
    // This will depend on the clustering library you're using.
  }

  void _updateClusterMarkers() {
    // Implementation to update cluster markers.
    // This typically involves recalculating clusters based on the current map zoom level and viewport.
  }

  Future<LatLng> _getInitialLocation() async {
    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Set the initial camera position with the current location
    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );

    return LatLng(position.latitude, position.longitude);
  }

  Future<LatLng?> getCurrentLocation() async {
    try {
      // Ensure the location services are enabled and permission is granted
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Fetch the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error fetching location: $e');
      // Handle the error here or return a default location
      return null; // or return a specific default location, e.g., LatLng(0, 0)
    }
  }

  void makeSuggestion(String input) async {
    // Google autocomplete is working and using land apikey
    String googlePlacesApiKey =
        'AIzaSyCXMU535-5XIMSMET7hHIe3a921bJu9ebM'; // Replace with your API key
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    // Create the URL with query parameters
    String requestUrl =
        '$groundURL?input=${Uri.encodeComponent(input)}&key=$googlePlacesApiKey';
    print('Request URL: $requestUrl'); // Debug print

    try {
      var responseResult = await http.get(Uri.parse(requestUrl));
      print('Response Status: ${responseResult.statusCode}'); // Debug print
      print('Response Body: ${responseResult.body}'); // Debug print
      if (responseResult.statusCode == 200) {
        // Handle the successful response here
        setState(() {
          listForPlaces = jsonDecode(responseResult.body)['predictions'];
        });
      } else {
        throw Exception('Showing data failed, Try again');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void onModify(String input) {
    if (tokenForSession == null) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (input.isEmpty) {
        setState(() {
          listForPlaces = [];
          _isDropdownVisible = false; // Hide the dropdown
        });
      } else {
        makeSuggestion(input);
      }
    });
  }

  void _updateCameraPosition(LatLng location) {
    if (_mapController != null) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 17),
      ));
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    // Fetch the current device location
    LatLng? currentLocation = await getCurrentLocation();

    if (currentLocation != null) {
      // Use the current location as the initial camera position
      CameraPosition _initialCameraPosition = CameraPosition(
        target: currentLocation,
        zoom: 17,
      );
      // Import marker data part 3 of 3 lines
      setState(() {
        // Add markers by calling listMarkers with the _onMarkerTap function
        _markers.addAll(listMarkers(_onMarkerTap));
      });

      // Move the camera to the initial position
      _mapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition));
    } else {
      // Handle the case where current location couldn't be determined
      print("Unable to determine current location");
    }
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

  Future<void> _selectPlace(String placeDescription) async {
    LatLng? location = await getLocationCoordinates(placeDescription);
    if (location != null) {
      setState(() {
        // Clear existing markers if you only want to show the selected location
        _markers.clear();

        // Add a new marker part 4 of 7 lines
        _markers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: location,
            infoWindow: InfoWindow(title: placeDescription),
          ),
        );

        // Update the camera position to the selected location
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(location, 16.0),
        );
      });
    }
  }

  Future<void> _updateCurrentLocation() async {
    print('Updating current location...');

    try {
      final Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation = LatLng(
          currentPosition.latitude,
          currentPosition.longitude,
        );

        // Check if currentLocation is not null
        _initialCameraPosition = CameraPosition(
          target:
              currentLocation!, // Use the '!' operator to assert that the value is non-null
          zoom: 15,
        );
      });
    } catch (e) {
      print('Error fetching current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = Set.from(listMarkers(_onMarkerTap));
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0, // Remove elevation by setting it to 0.0
        iconTheme: IconThemeData(color: Colors.black, size: 40.0),
        // Change icon color to black and adjust size
        backgroundColor: Colors.white, // Set the background color to white
        titleSpacing: 0.0, // Adjust the spacing here as needed
        title: Text(
          'LANDANDPLOT',
          style: TextStyle(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Search places with name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      30.0), // Adjust the radius as needed
                ),
                // You can also customize the focused border and error border if needed
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                      color: Colors.black87), // Customize the border color
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color:
                          Colors.red), // Customize the border color for errors
                ),
              ),
              onChanged: (input) {
                // Handle text field changes here
                onModify(input);
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _initialCameraPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  //mapType: _getMapType(_currentMapType),
                  mapType: MapType.satellite,
                  //mapType: MapType.normal,
                  //mapType: MapType.hybrid, // Set the map type to hybrid
                  markers: _markers,
                  // Other properties...   },
                ),
                if (listForPlaces.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 200, // Adjust the height as needed
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: listForPlaces.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(listForPlaces[index]['description']),
                            onTap: () async {
                              // Store the selected location coordinates
                              selectedLocation = await getLocationCoordinates(
                                  listForPlaces[index]['description']);
                              // Update the camera position to focus on the selected location
                              if (selectedLocation != null) {
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    selectedLocation!,
                                    16.0, // Adjust the zoom level as needed
                                  ),
                                );
                              }
                              // Update the search bar text with the selected location name
                              _controller.text =
                                  listForPlaces[index]['description'];
                              // Hide the keyboard
                              FocusScope.of(context).unfocus();
                              // Clear the list of places after a selection is made
                              // Hide the white dropdown by resetting selectedLocation to null
                              setState(() {
                                listForPlaces = [];
                                selectedLocation = null;
                                _controller
                                    .clear(); // Clears the search bar text
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
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.satellite),
                        onPressed: () {
                          setState(() {
                            _currentMapType = CustomMapType.satellite;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.layers),
                        onPressed: () {
                          setState(() {
                            _currentMapType = CustomMapType.hybrid;
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

  Future<LatLng?> getLocationCoordinates(String placeName) async {
    try {
      List<Location> locations = await locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print('Error fetching location coordinates: $e');
    }
    return null;
  }
}
