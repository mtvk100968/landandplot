import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:landandplot/screens/verify_otp_screen.dart';

class OTPSendingScreen extends StatefulWidget {
  final String phoneNumber;

  OTPSendingScreen({required this.phoneNumber});

  @override
  _OTPSendingScreenState createState() => _OTPSendingScreenState();
}

class _OTPSendingScreenState extends State<OTPSendingScreen> {
  final TextEditingController _otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;
  String enteredOTP = ""; // Declare and initialize enteredOTP

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        // Verification completed automatically
        // You can navigate to the next screen here
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
        print(e.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      timeout: const Duration(seconds: 60), // Timeout for code auto-retrieval
      forceResendingToken: null, // Pass null to disable auto-retrieval
    );
  }

  Future<void> _sendOTP(BuildContext context, String phoneNumber) async {
    final url = 'https://asia-south1-landandplot.cloudfunctions.net/api';

    try {
      // Send OTP request to your Firebase Cloud Function
      await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phoneNumber': phoneNumber,
        }),
      );

      // Use Firebase phone authentication to send OTP and handle verification
      //await _verifyOTPWithFirebase(context, phoneNumber);
    } catch (e) {
      // Handle any errors here
      print(e.toString());
    }
  }

  Future<void> _verifyOTP(BuildContext context, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // OTP verification successful, navigate to the HomeScreen
      _navigateToHomeScreen(context);
    } catch (e) {
      // Handle OTP verification failure
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP verification failed. Please try again.'),
        ),
      );
    }
  }

  // Future<void> _verifyOTPWithFirebase(BuildContext context, String phoneNumber) async {
  //   try {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) {
  //         // This callback is called when the verification is completed automatically (e.g., on Android devices)
  //         // You can auto-verify the user here if needed.
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print('Failed to send OTP: ${e.message}');
  //         // Handle verification failure
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         // Save the verification ID for later use
  //         String smsCode = ''; // The OTP entered by the user
  //
  //         // Navigate to the OTP verification screen
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => VerifyOTPScreen(
  //               phoneNumber: phoneNumber,
  //               verificationId: verificationId,
  //               smsCode: smsCode,
  //             ),
  //           ),
  //         );
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         // This callback is called when the auto-retrieval timeout occurs.
  //         // You can handle it as needed.
  //       },
  //       timeout: Duration(minutes: 1), // Adjust the timeout duration as needed
  //       forceResendingToken: null, // Set this to null initially
  //     );
  //   } catch (e) {
  //     print('Failed to initiate OTP verification: ${e.toString()}');
  //     // Handle any errors here
  //   }
  // }

  void _navigateToHomeScreen(BuildContext context) {
    // Implement the navigation logic to your HomeScreen here
  }

  void _resendOTP() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'OTP has been sent to ${widget.phoneNumber}.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            // Use PinCodeTextField for OTP input
            PinCodeTextField(
              appContext: context,
              length: 6, // Length of OTP
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  enteredOTP = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () => _verifyOTP(context, enteredOTP),
            //   child: Text('Verify OTP'),
            // ),
            ElevatedButton(
              onPressed: () => _verifyOTP(context,
                  _otpController.text), // Pass context as the first argument
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
