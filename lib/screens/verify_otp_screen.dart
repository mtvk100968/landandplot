// verify_otp_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String? verificationId; // Accept a nullable String

  VerifyOTPScreen(this.verificationId);

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController _smsCodeController =
      TextEditingController(); // Define the _smsCodeController here

  Future<void> _verifyOTP() async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId ??
            '', // Provide a default empty string if null
        smsCode: _smsCodeController.text,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // TODO: Navigate to a new screen or handle the signed-in user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User signed in with phone number.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during sign in with phone number: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Focus(
              child: TextField(
                controller: _smsCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                ),
                onChanged: (otp) {
                  if (otp.length == 6) {
                    // Remove focus from the text field
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
              ),
              onFocusChange: (hasFocus) {
                // Show or hide the keypad based on focus
                if (hasFocus) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
            ),
            ElevatedButton(
              onPressed: () => _verifyOTP(),
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
