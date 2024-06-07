// main.dart
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:landandplot/privacy_settings_page.dart';
import 'package:landandplot/property_reg_by_user.dart';
import 'package:landandplot/screens/login_screen.dart';
import 'package:landandplot/screens/signup_screen.dart';
import 'package:landandplot/services/places_service.dart';
import 'package:landandplot/proeprty_videos_list.dart';
import 'package:landandplot/splash_screen.dart';
import 'add_property_by_lap.dart';
import 'bottom_nav_bar.dart';
import 'favourites_page.dart';
import 'google_places_auto_complete.dart';
import 'home_screen.dart';
import 'landandplot.dart';
import 'my_dynamic_screen.dart';
import 'property_list.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize FacebookAuth
  FacebookAuth.instance;

  // Initialize the PlacesService with your API key.
  final String apiKey = 'AIzaSyCXMU535-5XIMSMET7hHIe3a921bJu9ebM';
  final _placesService = PlacesService(apiKey);

  runShaderWarmUp().then((_) {
    // Pass the PlacesService to your application.
    runApp(MyApp(placesService: _placesService));
  });
}

Future<void> runShaderWarmUp() async {
  final ShaderWarmUpPainter painter = ShaderWarmUpPainter();
  final PictureRecorder recorder = PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  final Size size =
      Size(1024, 1024); // Use an appropriate size for offscreen canvas

  painter.paint(canvas, size); // Perform the painting

  final Picture picture = recorder.endRecording();
  await picture.toImage(
      1024, 1024); // Await the image to ensure the shaders are compiled
}


class ShaderWarmUpPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Your shader painting code here
    final Gradient gradient = LinearGradient(
      colors: [Colors.blue, Colors.green],
      stops: [0.0, 1.0],
    );

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRect(rect, paint);

    // Add more drawing code if needed to cover all your shaders
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MyApp extends StatelessWidget {
  final PlacesService placesService;

  const MyApp({Key? key, required this.placesService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId =
        FirebaseAuth.instance.currentUser?.uid ?? ''; // Initialize userId here

    return MaterialApp(
      title: 'Landandplot',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),

      initialRoute: '/splash', // Set to the splash screen's route
      routes: {
        '/splash': (context) => SplashScreen(), // Define splash screen route
        '/': (context) =>
            const HomeScreen(userId: '',), // HomeScreen is now the main screen after splash
        '/addpropertybylap': (context) => AddPropertyByLap(),
        '/loginscreen': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/clustermarkercheck': (context) => LandandPlot(),
        '/placessautocomplete': (context) => GooglePlacesAutoComplete(
              placesService: placesService,
            ), // Remove 'const' here
        '/propertyreg': (context) => PropertyRegByUser(),
        '/bottomnavbar': (context) =>
            BottomNavBar(placesService: placesService, userId: userId),
        '/videolistpage': (context) => PropertyVideosList(),
        '/propertylist': (context) => const PropertyList(),
        '/privacysettingspage': (context) => PrivacySettingsPage(),
        '/favouritespage': (context) => FavoritesPage(userId: userId),
        // '/clustermarkernew': (context) => ClusterMarkerNew(),
        // '/currentmarkerproperties': (context) => CurrentMarkerProperties(),
        // '/clustermapscreen': (context) => ClusterMapScreen(),
        // '/clusterautocomplete': (context) => ClusterAutocomplete(), // Remove 'const' here
      },

      onGenerateRoute: (RouteSettings settings) {
        // Handle any dynamic route generation here
        switch (settings.name) {
          case '/dynamicRoute':
            // Example of a dynamic route
            final args = settings.arguments as MyCustomArguments;
            return MaterialPageRoute(
              builder: (context) => MyDynamicScreen(args: args),
            );
          // Add other case statements for other dynamic routes...
          default:
            // If no cases match, return null which will trigger onUnknownRoute
            return null;
        }
      },

      onUnknownRoute: (RouteSettings settings) {
        // Handle any undefined routes here
        // Return a route to an "UnknownRouteScreen" or similar
        return MaterialPageRoute(
          builder: (context) => UnknownRouteScreen(),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
