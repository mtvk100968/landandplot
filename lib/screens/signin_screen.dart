// signin_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:landandplot/home_screen.dart';
import 'package:landandplot/screens/phone_signin_screen.dart';
import 'package:landandplot/screens/signup_screen.dart';
import '../custom_drawer.dart';
import '../favourites_page.dart';
import '../proeprty_videos_list.dart';
import '../profile_page.dart';
import 'email_signin_screen.dart';
import '../services/facebook_auth_service.dart';
import 'forget_password_screen.dart';
import '../services/google_auth_service.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/login_screen';
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  static const routeName =
      '/login_screen'; // Add this line if not already present
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add this
// After user logs in
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 99), // For spacing
              ElevatedButton(
                onPressed: () async {
                  var authService = GoogleAuthService();
                  User? user = await authService.signInWithGoogle();
                  if (user != null) {
                    // Navigate to the HomePage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    // Handle the case where the user cancelled the sign-in or there was an error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Google sign-in failed or was cancelled')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Customize the button's background color
                  textStyle: TextStyle(
                    fontSize: 18, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                // ... other properties
                child: Text('Login with Google'),
              ),

              SizedBox(height: 18),
              ElevatedButton(
                onPressed: () async {
                  var facebookAuthService = FacebookAuthService();
                  User? user = await facebookAuthService.signInWithFacebook();
                  if (user != null) {
                    // Navigate to the HomePage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    // Handle the case where the user cancelled the sign-in or there was an error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Facebook sign-in failed or was cancelled')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Customize the button's background color
                  textStyle: TextStyle(
                    fontSize: 18, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                // ... other properties
                child: Text('Login with Facebook'),
              ),

              SizedBox(height: 18), // For spacing
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PhoneSigninScreen(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Customize the button's background color
                  textStyle: TextStyle(
                    fontSize: 18, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                child: Text('Phone OTP Login'),
              ),

              SizedBox(height: 20), // For spacing
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),

              SizedBox(height: 20), // For spacing
              ElevatedButton(
                onPressed: () async {
                  // Call the email sign-in screen
                  Navigator.of(context).pushNamed(EmailSigninScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Customize the button's background color
                  textStyle: TextStyle(
                    fontSize: 18, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                child: Text('Log in'),
              ),

              SizedBox(height: 18), // For spacing

              TextButton(
                child: Text('Forgot password?'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8), // Add spacing between the buttons
                  Text('Don\'t have an account? '),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      ); // Add your logic for navigating to the sign-up screen here
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ]),
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
