// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:geolocator/geolocator.dart';
// import 'custom_drawer.dart';
//
//
// const kGoogleApiKey = "AIzaSyCXMU535-AIzaSyBzXWJe784Qh5lvTuRgYeab7_zcTcfdhdc";
//
// final GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
// double? lat;
// double? lng;
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   GoogleMapController? _mapController;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//   }
//
//   void _locateUser() async {
//     var position = await _determinePosition();
//     _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 14.0,
//     )));
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled, handle accordingly.
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, handle accordingly.
//         throw Exception('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle accordingly.
//       throw Exception(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }
//
//   // LatLng? lastMapPosition;
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller; // Assign the controller to _mapController
//   }
//
//   Future<void> _moveCameraToPosition(LatLng position) async {
//     if (_mapController == null) {
//       print('Map controller is not initialized');
//       return;
//     }
//     await _mapController!.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: position,
//           zoom: 14.0,
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           elevation: 0.0, // Remove elevation by setting it to 0.0
//           iconTheme: IconThemeData(color: Colors.black, size: 40.0),
//           // Change icon color to black and adjust size
//           backgroundColor: Colors.white, // Set the background color to white
//           titleSpacing: 0.0, // Adjust the spacing here as needed
//           title: Text(
//             'LANDANDPLOT',
//             style: TextStyle(
//               color: Colors.green, // Set the text color to black
//               fontSize: 30, // Adjust the font size as needed
//               fontWeight: FontWeight.w800, // Make the text bold
//             ),
//           ),
//         ),
//         drawer: CustomDrawer(),
//
//         floatingActionButton: FloatingActionButton(
//           onPressed: _locateUser,
//           tooltip: 'Locate Me',
//           child: Icon(Icons.my_location),
//         )
//     );
//   }
//
//   Future<void> _handleSearchPress() async {
//     try {
//       Prediction? p = await PlacesAutocomplete.show(
//         context: context,
//         apiKey: kGoogleApiKey,
//         mode: Mode.overlay, // or Mode.fullscreen
//         language: "en",
//         components: [Component(Component.country, "us")],
//       );
//
//       if (p != null) {
//         await displayPrediction(p);
//       }
//     } catch (e) {
//       // Log the error
//       print("Error occurred while showing PlacesAutocomplete: $e");
//       // You may want to display a dialog or a toast to the user here
//     }
//   }
//
//   Future<void> displayPrediction(Prediction p) async {
//     if (p.placeId == null) {
//       print('No placeId for the prediction');
//       return;
//     }
//
//     try {
//       PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
//
//       if (detail.status == "OK" && detail.result.geometry?.location != null) {
//         lat = detail.result.geometry!.location.lat;
//         lng = detail.result.geometry!.location.lng;
//         double? newLat;
//         double? newLng;
//         if (newLat == null || newLng == null) {
//           print('Error: Retrieved location is null.');
//           return;
//         }
//
//         setState(() {
//           lat = newLat;
//           lng = newLng;
//         });
//
//         // Debug: Print out the coordinates to make sure they are correct
//         print('Navigating to coordinates: $lat, $lng');
//         // Use the lat and lng to do something, like animating the map camera
//
//
//         // Animate the map to the new position
//         _mapController?.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(newLat, newLng),
//               zoom: 15.0,
//             ),
//           ),
//         );
//       } else {
//         // Handle the error, the status is not OK
//         print('Error retrieving place details: ${detail.status}');
//       }
//     } catch (e) {
//       // Handle the exception, this might be due to network issues or authorization errors
//       print('An error occurred while retrieving place details: $e');
//     }
//   }
// }
//
// class CustomMapBarScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Custom Map Bar Screen'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Return to the previous screen
//             // (most likely HomeScreen if that's where you came from)
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Text('This is the Custom Map Bar screen'),
//       ),
//     );
//   }
// }

// home_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:landandplot/profile_page.dart';
import 'package:landandplot/screens/signin_screen.dart';
import 'package:landandplot/single_city.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:landandplot/proeprty_videos_list.dart';
import 'cluster_marker_check.dart';
import 'custom_drawer.dart';
import 'favourites_page.dart';

// class PropertyList extends StatelessWidget {
//   const PropertyList({Key? key}) : super(key: key);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<bool> isHovering;
  int _selectedIndex = 0; // Now defined in this state class
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    // Initialize the hover states to false for each item in the list
    isHovering = List.filled(cityList.length, false);
  }

  final List<Map<String, dynamic>> cityList = const [
    {
      "address": "Jaipur the pink city",
      "id": "jaipur_01",
      "image":
          "https://i.pinimg.com/originals/b7/3a/13/b73a132e165978fa07c6abd2879b47a6.png",
      "lat": 26.922070,
      "lng": 75.778885,
      "name": "Jaipur India",
      "phone": "7014333352",
      "pincode": "302001",
      "region": "South Asia",
      // "subImages": [
      //   // "https://pixabay.com/photos/temple-women-pillar-india-jaipur-3370930/",
      //   "https://pixabay.com/photos/jaipur-rajasthan-india-history-3670085/",
      //   "https://pixabay.com/photos/amber-palace-jaipur-rajasthan-653180/",
      //   "https://pixabay.com/photos/gaitore-ki-chhatriyan-india-jaipur-3244463/",
      //   "https://pixabay.com/photos/jal-mahal-jaipur-sunset-water-4109105/",
      // ],
    },
    {
      "address": "Hyderabad",
      "id": "Hyd_Ikea_03",
      "image":
          "https://c8.alamy.com/comp/P9NWXE/swedish-furniture-giant-ikea-will-open-its-first-store-in-india-on-august-092018-in-the-southern-city-of-hyderabadit-was-scheduled-to-open-on-july-P9NWXE.jpg",
      "lat": 17.43927,
      "lng": 78.37561,
      "name": "Ikea Hyderabad",
      "phone": "9959788005",
      "pincode": "500032",
      "region": "South India"
    },
    {
      "address": "New Delhi capital of india",
      "id": "delhi_02",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/9/96/Delhi_Red_fort.jpg",
      "lat": 28.644800,
      "lng": 77.216721,
      "name": "Delhi City India",
      "phone": "7014333352",
      "pincode": "110001",
      "region": "South Asia"
    },
    {
      "address": "Mumbai City",
      "id": "mumbai_03",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/7/7e/Mumbai_Taj.JPG",
      "lat": 19.076090,
      "lng": 72.877426,
      "name": "Mumbai City India",
      "phone": "400005",
      "region": "South Asia"
    },
    {
      "address": "Udaipur City",
      "id": "udaipur_04",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/6/6f/Evening_view%2C_City_Palace%2C_Udaipur.jpg",
      "lat": 24.571270,
      "lng": 73.691544,
      "name": "Udaipur City India",
      "phone": "313003",
      "region": "South Asia"
    },
    {
      "address": "Jaipur the pink city",
      "id": "jaipur_01",
      "image":
          "https://i.pinimg.com/originals/b7/3a/13/b73a132e165978fa07c6abd2879b47a6.png",
      "lat": 26.922070,
      "lng": 75.778885,
      "name": "Jaipur India",
      "phone": "7014333352",
      "pincode": "302001",
      "region": "South Asia"
    },
    {
      "address": "Hyderabad",
      "id": "Hyd_Ikea_03",
      "image":
          "https://c8.alamy.com/comp/P9NWXE/swedish-furniture-giant-ikea-will-open-its-first-store-in-india-on-august-092018-in-the-southern-city-of-hyderabadit-was-scheduled-to-open-on-july-P9NWXE.jpg",
      "lat": 17.43927,
      "lng": 78.37561,
      "name": "Ikea Hyderabad",
      "phone": "9959788005",
      "pincode": "500032",
      "region": "South India"
    },
    {
      "address": "New Delhi capital of india",
      "id": "delhi_02",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/9/96/Delhi_Red_fort.jpg",
      "lat": 28.644800,
      "lng": 77.216721,
      "name": "Delhi City India",
      "phone": "7014333352",
      "pincode": "110001",
      "region": "South Asia"
    },
    {
      "address": "Mumbai City",
      "id": "mumbai_03",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/7/7e/Mumbai_Taj.JPG",
      "lat": 19.076090,
      "lng": 72.877426,
      "name": "Mumbai City India",
      "phone": "400005",
      "region": "South Asia"
    },
    {
      "address": "Udaipur City",
      "id": "udaipur_04",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/6/6f/Evening_view%2C_City_Palace%2C_Udaipur.jpg",
      "lat": 24.571270,
      "lng": 73.691544,
      "name": "Udaipur City India",
      "phone": "313003",
      "region": "South Asia"
    },
    {
      "address": "Jaipur the pink city",
      "id": "jaipur_01",
      "image":
          "https://i.pinimg.com/originals/b7/3a/13/b73a132e165978fa07c6abd2879b47a6.png",
      "lat": 26.922070,
      "lng": 75.778885,
      "name": "Jaipur India",
      "phone": "7014333352",
      "pincode": "302001",
      "region": "South Asia"
    },
    {
      "address": "Hyderabad",
      "id": "Hyd_Ikea_03",
      "image":
          "https://c8.alamy.com/comp/P9NWXE/swedish-furniture-giant-ikea-will-open-its-first-store-in-india-on-august-092018-in-the-southern-city-of-hyderabadit-was-scheduled-to-open-on-july-P9NWXE.jpg",
      "lat": 17.43927,
      "lng": 78.37561,
      "name": "Ikea Hyderabad",
      "phone": "9959788005",
      "pincode": "500032",
      "region": "South India"
    },
    {
      "address": "New Delhi capital of india",
      "id": "delhi_02",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/9/96/Delhi_Red_fort.jpg",
      "lat": 28.644800,
      "lng": 77.216721,
      "name": "Delhi City India",
      "phone": "7014333352",
      "pincode": "110001",
      "region": "South Asia"
    },
    {
      "address": "Mumbai City",
      "id": "mumbai_03",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/7/7e/Mumbai_Taj.JPG",
      "lat": 19.076090,
      "lng": 72.877426,
      "name": "Mumbai City India",
      "phone": "400005",
      "region": "South Asia"
    },
    {
      "address": "Udaipur City",
      "id": "udaipur_04",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/6/6f/Evening_view%2C_City_Palace%2C_Udaipur.jpg",
      "lat": 24.571270,
      "lng": 73.691544,
      "name": "Udaipur City India",
      "phone": "313003",
      "region": "South Asia"
    }
  ];

  getDetails(Map singleCityData, BuildContext context) {
    print('singleCityData');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleCity(
          cityData: singleCityData,
        ),
      ),
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
          MaterialPageRoute(builder: (context) => HomeScreen()),
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
          MaterialPageRoute(builder: (context) => SigninScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0, // Remove elevation by setting it to 0.0
        iconTheme: IconThemeData(color: Colors.black, size: 40.0),
        // Change icon color to black and adjust size
        backgroundColor: Colors.white, // Set the background color to white
        titleSpacing: 0.0, // Adjust the spacing here as needed
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LANDANDPLOT',
              style: TextStyle(
                color: Colors.green, // Set the text color to black
                fontSize: 30, // Adjust the font size as needed
                fontWeight: FontWeight.w800, // Make the text bold
              ),
            ),
            TextButton(
              onPressed: () {
                // Use Navigator to push to the ClusterMarkerCheck route
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClusterMarkerCheck()),
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
      body: ListView.builder(
        itemCount: cityList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              MouseRegion(
                onHover: (PointerHoverEvent event) {
                  print('Hovering over item: $index');
                  setState(() {
                    isHovering[index] = true;
                  });
                },
                onExit: (PointerExitEvent event) {
                  print('Mouse exited item: $index');
                  setState(() {
                    isHovering[index] = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.identity()
                    ..scale(isHovering[index] ? 1.05 : 1.0),
                  child: GestureDetector(
                    onTap: () => getDetails(cityList[index], context),
                    child: Card(
                      elevation: isHovering[index]
                          ? 10
                          : 2, // Change elevation on hover
                      margin: EdgeInsets.zero,
                      child: CachedNetworkImage(
                        imageUrl: cityList[index]['image'],
                        height: 250,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                //const SizedBox(height: 10),
              ),
            ],
          );
        },
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
          // Add this
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}


// void _onItemTapped(int index) {
//   print('Bottom nav item tapped: $index'); // Debug: print the tapped index
//   setState(() {
//     _selectedIndex = index;
//   });
//   switch (_selectedIndex) {
//     case 0:
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//       break;
//     case 1:
//     // Navigate to Profile Screen  ProfilePage
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => ProfilePage()),
//       );
//       break;
//     case 2:
//     // Navigate to Favorites Screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => FavoritesPage()),
//       );
//       break;
//     case 3:
//     // Navigate to Videos Screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => VideoListPage()),
//       );
//       break;
//     case 4:
//     // Navigate to Search Screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => SigninScreen()),
//       );
//       break;
//   }
// }