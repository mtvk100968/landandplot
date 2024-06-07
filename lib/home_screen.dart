import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:landandplot/property_details_display_page.dart';
import 'package:landandplot/screens/login_screen.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'custom_drawer.dart';
import 'favourites_page.dart';
import 'landandplot.dart';
import 'profile_page.dart';
import 'single_city.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<bool> isHovering;
  int _selectedIndex = 0;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  Location location = Location();
  List<Map<String, dynamic>> cityList = [];
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  String selectedCategory = 'All';
  Map<String, dynamic>? _selectedMarkerDetails;

  @override
  void initState() {
    super.initState();
    isHovering = [];
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final locData = await location.getLocation();
    if (locData.latitude != null && locData.longitude != null) {
      _fetchPropertiesNearby(locData.latitude!, locData.longitude!);
      _updateMapLocation(locData.latitude!, locData.longitude!);
    }
  }

  void _fetchPropertiesNearby(double lat, double lng) async {
    try {
      final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('properties');

      QuerySnapshot querySnapshot = await collectionReference.get();
      List<DocumentSnapshot> documents = querySnapshot.docs;

      setState(() {
        cityList = documents.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          double? docLat = data['latitude'];
          double? docLng = data['longitude'];
          if (docLat != null && docLng != null) {
            double distance = _calculateDistance(lat, lng, docLat, docLng);
            return distance <= 10; // Filter properties within 10km radius
          }
          return false;
        }).map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            "address": data['address'] ?? 'No address provided',
            "id": doc.id,
            "image": data['imageUrl'] ?? 'https://via.placeholder.com/300',
            "lat": data['latitude'],
            "lng": data['longitude'],
            "name": data['propertyType'] ?? 'No name provided',
            "phone": data['phone'] ?? 'No phone number provided',
            "pincode": data['pincode'] ?? 'No pincode provided',
            "region": data['region'] ?? 'No region provided',
            "price": data['price'] ?? 'No price provided',
            "bedrooms": data['bedrooms'] ?? 0,
            "bathrooms": data['bathrooms'] ?? 0,
            "sqft": data['sqft'] ?? 0,
            "daysAgo": data['daysAgo'] ?? 0,
            "subImages": data['subImages'] ?? [],
          };
        }).toList();
        isHovering = List.filled(cityList.length, false);
        _updateMarkers();
      });
    } catch (e) {
      print('Error fetching properties: $e');
    }
  }

  void _updateMarkers() {
    Set<Marker> newMarkers = {};
    for (var property in cityList) {
      final marker = Marker(
        markerId: MarkerId(property['id']),
        position: LatLng(property['lat'], property['lng']),
        infoWindow: InfoWindow(
          title: property['name'],
          snippet: property['address'],
        ),
        onTap: () {
          setState(() {
            _selectedMarkerDetails = property;
          });
        },
      );
      newMarkers.add(marker);
    }
    setState(() {
      _markers = newMarkers;
    });
  }

  void _updateMapLocation(double lat, double lng) {
    _mapController
        ?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14));
  }

  double _calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    double dLat = _degreeToRadian(endLat - startLat);
    double dLng = _degreeToRadian(endLng - startLng);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(startLat)) *
            cos(_degreeToRadian(endLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen(
                userId: '',
              )),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FavoritesPage(userId: userId)),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandandPlot()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  void getDetails(Map<String, dynamic> singleCityData, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleCity(
          cityData: singleCityData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black, size: 40.0),
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const  Text(
              'LANDANDPLOT',
              style: TextStyle(
                color: Colors.green,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LandandPlot()),
                );
              },
              child: Text(
                'MAP',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(20.5937, 78.9629), // Center of India
                    zoom: 5,
                  ),
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    _getCurrentLocation();
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 250,
                    child: ListView.builder(
                      itemCount: cityList.length,
                      itemBuilder: (context, index) {
                        final property = cityList[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(property['image'] ?? ''), // Replace with property image URL
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '\$${property['price'] ?? ''}/mo', // Replace with property price
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '${property['bedrooms']} bds | ${property['bathrooms']} ba | ${property['sqft']} sqft', // Replace with property details
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  property['address'] ?? '', // Replace with property address
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${property['daysAgo']} days ago', // Replace with property date
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (_selectedMarkerDetails != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyDetailsDisplayPage(
                              propertyId: _selectedMarkerDetails!['id'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Stack(
                          children: [
                            _selectedMarkerDetails!['image'] != null
                                ? Image.network(
                              _selectedMarkerDetails!['image'],
                              height: 300.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              height: 300.0,
                              width: double.infinity,
                              color: Colors.grey[300], // Placeholder background color
                              child: Center(
                                child: Text(
                                  'No Image Available',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rent: ₹${_selectedMarkerDetails!['price']}',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Bedrooms: ${_selectedMarkerDetails!['bedrooms']}',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            height: 50,
            color: Colors.blue,
            child: const Center(
              child: Text(
                'Advertisement',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
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
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}