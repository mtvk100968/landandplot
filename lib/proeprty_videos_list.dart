// proeprty_videos_list.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landandplot/profile_page.dart';
import 'package:landandplot/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_drawer.dart';
import 'favourites_page.dart';
import 'home_screen.dart';
import 'models/video_property.dart';
import 'package:video_player/video_player.dart';

class PropertyVideosList extends StatefulWidget {
  @override
  _PropertyVideosListState createState() => _PropertyVideosListState();
}

class _PropertyVideosListState extends State<PropertyVideosList> {
  // Remove the unnecessary constructor and videoUrl declaration
  VideoPlayerController? _controller;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add this
// When you have the user ID and want to navigate to FavoritesPage
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('YOUR_VIDEO_URL_HERE')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    // Dispose video player controller to free up resources
    _controller?.dispose();
    super.dispose();
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
    // String videoUrl = widget.videoUrl;
    // You can use the `video_player` package to play videos
    // https://pub.dev/packages/video_player
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
      // Implementing a ListView to display videos
      body: ListView.builder(
        itemCount: mockVideoProperties.length, // Count of video properties
        itemBuilder: (BuildContext context, int index) {
          final video = mockVideoProperties[index];
          return ListTile(
            leading: Image.network(video.thumbnailUrl),
            title: Text(video.title),
            subtitle: Text("${video.propertyType}, ${video.areaName}"),
            onTap: () => _launchURL(video.videoUrl),
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
