import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animationTop;
  late Animation<Offset> _animationBottom;
  late Animation<Offset> _animationLeft;
  late Animation<Offset> _animationRight;
  late Animation<Offset> _animation;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   // Animation controller for floating markers
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: Duration(seconds: 2), // Adjust the duration as needed
  //   );
  //
  //   _animation = Tween<Offset>(
  //     begin: Offset(0.0, 1.0),
  //     end: Offset.zero,
  //   ).animate(
  //     CurvedAnimation(
  //       parent: _controller,
  //       curve: Curves.easeInOut,
  //     ),
  //   );
  //
  //   // Start the animation
  //   _controller.forward();
  //
  //   // Set a timer to go to the next screen after some time
  //   Timer(Duration(seconds: 5), () {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (_) => HomeScreen())); // Replace with your main screen
  //   });
  // }

  @override
  void initState() {
    super.initState();

    // Animation controller for floating markers
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );

    _animationTop = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _animationBottom = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _animationLeft = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _animationRight = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _controller.forward();

    // Set a timer to go to the next screen after some time
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => HomeScreen(userId: '',))); // Replace with your main screen
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Wrap markers with SlideTransition to animate them
            Stack(
              children: [
                SlideTransition(
                  position: _animationTop,
                  child: MarkerIcon(color: Colors.green),
                ),
                SlideTransition(
                  position: _animationBottom,
                  child: MarkerIcon(color: Colors.red),
                ),
                SlideTransition(
                  position: _animationLeft,
                  child: MarkerIcon(color: Colors.blue),
                ),
                SlideTransition(
                  position: _animationRight,
                  child: MarkerIcon(color: Colors.yellow),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Loading...",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A custom widget to mimic markers
class MarkerIcon extends StatelessWidget {
  final Color? color;
  final String? letter;

  const MarkerIcon({Key? key, this.color, this.letter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 50,
      width: 50,
      child: Center(
        child: Text(
          letter ?? "",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
// @override
// Widget build(BuildContext context) {
//   return Container(
//     margin: EdgeInsets.all(8.0),
//     decoration: BoxDecoration(
//       color: color ?? Colors.transparent,
//       borderRadius: BorderRadius.circular(12),
//     ),
//     height: 50,
//     width: 50,
//     child: Center(
//       child: Text(
//         letter ?? "",
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     ),
//   );
// }
