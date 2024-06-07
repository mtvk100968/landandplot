// property_list.dart
import 'package:flutter/material.dart';
import 'package:landandplot/screens/login_screen.dart';
import 'package:landandplot/single_city.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'landandplot.dart';
import 'custom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class PropertyList extends StatelessWidget {
//   const PropertyList({Key? key}) : super(key: key);

class PropertyList extends StatefulWidget {
  const PropertyList({Key? key}) : super(key: key);

  @override
  _PropertyListState createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {
  int _selectedIndex = 0; // Now defined in this state class

  void _onItemTapped(int index) {
    // Now defined in this state class
    setState(() {
      _selectedIndex = index;
    });
  }

  // void _toggleFavorite(String propertyId) async {
  //   final User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user != null) {
  //     DocumentReference favoritesRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('favorites')
  //         .doc(propertyId);
  //
  //     DocumentSnapshot snapshot = await favoritesRef.get();
  //
  //     if (snapshot.exists) {
  //       // If it's already in favorites, remove it
  //       await favoritesRef.delete();
  //     } else {
  //       // If it's not in favorites, add it
  //       await favoritesRef.set({'propertyId': propertyId});
  //     }
  //
  //     // Update the state to reflect the new favorites list
  //     setState(() {});
  //   }
  // }

  void _toggleFavorite(String propertyId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Prompt the user to log in
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  LoginScreen())); // Replace with your actual login screen
      return;
    }

    CollectionReference favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
    DocumentReference propertyRef = favoritesRef.doc(propertyId);
    DocumentSnapshot propertySnapshot = await propertyRef.get();

    if (propertySnapshot.exists) {
      // If it's already in favorites, remove it
      propertyRef.delete();
    } else {
      // If it's not in favorites, add it
      propertyRef.set({'propertyId': propertyId});
    }

    setState(() {}); // Update the UI
  }

  // Use this method to check if a property is favorited
  Future<bool> _isFavorited(String propertyId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    DocumentSnapshot propertySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(propertyId)
        .get();

    return propertySnapshot.exists;
  }

  final List<Map<String, dynamic>> clityList = const [
    {
      "address": "Jaipur the pink city",
      "id": "jaipur_01",
      "image":
          "https://i.pinimg.com/originals/b7/3a/13/b73a132e165978fa07c6abd2879b47a6.png",
      "lat": 26.922070,
      "lng": 75.778885,
      "name": "Jaipur India",
      "phone": "7014333352",
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
      "phone": "7014333352",
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
      "phone": "7014333352",
      "region": "South Asia"
    }
  ];

  getDetails(Map singleCityData, BuildContext context) {
    print(singleCityData);
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
                      builder: (context) => const LandandPlot()),
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
        itemCount: clityList.length,
        itemBuilder: (context, index) {
          var property = clityList[index];
          return Card(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Add this
              children: [
                Stack(
                  children: [
                    Image.network(
                      property['image'],
                      height: 300,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Positioned(
                      right: 0,
                      child: FutureBuilder(
                        future: _isFavorited(property['id']),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            );
                          }
                          bool isFavorited = snapshot.data ?? false;
                          return IconButton(
                            icon: isFavorited
                                ? Icon(Icons.favorite, color: Colors.red)
                                : Icon(Icons.favorite_border),
                            onPressed: () => _toggleFavorite(property['id']),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Add this
                    children: [
                      Text(
                        clityList[index]['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        clityList[index]['address'],
                        style: const TextStyle(
                          fontSize: 14,
                          color:
                              Colors.grey, // Lighter font color for the address
                        ),
                      ),
                      SizedBox(height: 10), // Spacing between text and buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Add the agent/owner image here
                          CircleAvatar(
                            // Placeholder for agent/owner image
                            backgroundImage:
                                NetworkImage('AGENT_OR_OWNER_IMAGE_URL'),
                            radius: 24,
                          ),
                          // Wrap the buttons in an Expanded widget to ensure they are spaced out
                          Expanded(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end, // Align to end
                              children: [
                                // WhatsApp Button
                                IconButton(
                                  icon: FaIcon(FontAwesomeIcons.whatsapp),
                                  color: Colors.green,
                                  onPressed: () {
                                    // Handle WhatsApp messaging
                                  },
                                ),
                                // Call Button
                                IconButton(
                                  icon: Icon(Icons.call),
                                  color: Colors.blue,
                                  onPressed: () {
                                    // Handle call action
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    getDetails(clityList[index], context);
                  },
                  child: const Text("View Details"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue[700], // Text color
                  ),
                )
              ],
            ),
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
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_label),
              label: 'Videos',
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
