// favourites_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landandplot/profile_page.dart';
import 'package:landandplot/screens/signin_screen.dart';
import 'package:landandplot/proeprty_videos_list.dart';
import 'custom_drawer.dart';
import 'home_screen.dart';
import 'models/property_address.dart';

class FavoritesPage extends StatefulWidget {
  final String userId;
  FavoritesPage({Key? key, required this.userId}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<PropertyAddress> _favoriteProperties = []; // Rename this variable
  late Future<List<PropertyAddress>>
      _fetchFavoriteProperties; // Rename this future

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load favorite properties using the userId
    _fetchFavoriteProperties = _fetchPropertyAddresses(widget.userId);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add this

  // When you have the user ID and want to navigate to FavoritesPage
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<List<PropertyAddress>> _fetchPropertyAddresses(String userId) async {
    // Implement your logic to fetch favorite properties based on the userId
    // For example, you might query a database or make a network request
    // Return a List<PropertyAddress> containing the favorite properties
    // This is just a placeholder, replace it with your actual implementation
    return [];
  }

  void _onItemTapped(int index) {
    print('Bottom nav item tapped: $index'); // Debug: print the tapped index
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        // Navigate to Profile Screen  ProfilePage
        Navigator.pushReplacement(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 2:
        // Navigate to Favorites Screen
        Navigator.pushReplacement(
          context as BuildContext,
          MaterialPageRoute(
            builder: (context) => FavoritesPage(userId: userId),
          ),
        );
        break;
      case 3:
        // Navigate to Videos Screen
        Navigator.pushReplacement(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => PropertyVideosList()),
        );
        break;
      case 4:
        // Navigate to Search Screen
        Navigator.pushReplacement(
          context as BuildContext,
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
        title: Text(
          'LANDANDPLOT',
          style: TextStyle(
            color: Colors.green, // Set the text color to black
            fontSize: 30, // Adjust the font size as needed
            fontWeight: FontWeight.w800, // Make the text bold
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: _favoriteProperties.isEmpty
          ? Center(
              child: Text('No favorite properties.'),
            )
          : ListView.builder(
              itemCount: _favoriteProperties.length,
              itemBuilder: (context, index) {
                final property = _favoriteProperties[index];
                return ListTile(
                  title: Text('Property ID: ${property.propertyId}'),
                  subtitle: Text(
                      'Position: LatLng(${property.latitude}, ${property.longitude})'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        // Remove the property from favorites
                        _favoriteProperties.removeAt(index);
                      });
                    },
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
