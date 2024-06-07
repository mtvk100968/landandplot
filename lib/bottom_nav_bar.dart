import 'package:flutter/material.dart';
import 'package:landandplot/proeprty_videos_list.dart';
import 'package:landandplot/profile_page.dart';
import 'package:landandplot/screens/login_screen.dart';
import 'package:landandplot/services/places_service.dart';
import 'custom_drawer.dart';
import 'favourites_page.dart';
import 'home_screen.dart';

// void main() {
//   // Assuming you obtain the userId from your authentication system
//   String userId = getCurrentUserId(); // Implement this method to get the userId
//
//   runApp(MaterialApp(
//     home: BottomNavBar(
//       userId: userId,
//       placesService: PlacesService('AIzaSyCXMU535-5XIMSMET7hHIe3a921bJu9ebM'),
//     ),
//   ));
// }

class BottomNavBar extends StatefulWidget {
  final String userId; // Add this property
  final PlacesService placesService; // Add this property

  const BottomNavBar({
    Key? key,
    required this.userId,
    required this.placesService,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [];

  get userId => null;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      HomeScreen(userId: '',),
      ProfilePage(),
      FavoritesPage(userId: widget.userId),
      PropertyVideosList(),
      LoginScreen(),
    ];
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  // void _onItemTapped(int index) {
  //   if (_selectedIndex != index) {
  //     setState(() {
  //       _selectedIndex = index;
  //     });
  //     // Only navigate if the selected index is different to avoid unnecessary navigation
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => _widgetOptions[index]),
  //     );
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    // Define the widget options in a list. Replace these with your actual widgets.
    final List<Widget> _widgetOptions = <Widget>[
      HomeScreen(userId: '',),
      ProfilePage(),
      FavoritesPage(userId: widget.userId),
      PropertyVideosList(),
      LoginScreen(), // Here's your video list page
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0, // Remove elevation by setting it to 0.0
        iconTheme: IconThemeData(color: Colors.black, size: 40.0),
        // Change icon color to black and adjust size
        backgroundColor: Colors.white, // Set the background color to white
        titleSpacing: 0.0, // Adjust the spacing here as needed
        title: Text(
          'RENTLOAPP',
          style: TextStyle(
            color: Colors.blue, // Set the text color to black
            fontSize: 30, // Adjust the font size as needed
            fontWeight: FontWeight.w800, // Make the text bold
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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

String getCurrentUserId() {
  // Implement this method to get the userId from your authentication system
  // For example, you can use Firebase Authentication to get the current user's ID
  return 'user123'; // Placeholder for demonstration
}