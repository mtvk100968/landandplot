// profile_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landandplot/screens/login_screen.dart';
import 'package:landandplot/proeprty_videos_list.dart';
import 'favourites_page.dart';
import 'home_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;

  // When you have the user ID and want to navigate to FavoritesPage
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add this

  void _onItemTapped(int index) {
    print('Bottom nav item tapped: $index'); // Debug: print the tapped index
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => HomeScreen(userId: '',)),
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
              builder: (context) => FavoritesPage(userId: userId)),
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
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Use the GlobalKey here

      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 24, // Font size 24
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 60,
              // You can load the user's profile picture here
              // backgroundImage: AssetImage('assets/profile_image.png'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Full Name',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Email Address',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Edit Name'),
              onTap: () {
                // Handle the action to edit the name
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Edit Email'),
              onTap: () {
                // Handle the action to edit the email
              },
            ),
            // Add more options to edit profile information as needed
          ],
        ),
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

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
