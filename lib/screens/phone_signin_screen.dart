// import 'package:flutter/material.dart';
// import 'otp_sending_screen.dart';
//
// class PhoneNumberInputScreen extends StatefulWidget {
//   @override
//   _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
// }
//
// class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
//   final TextEditingController _phoneNumberController =
//       TextEditingController(text: '+91');
//
//   // Function to verify phone number format
//   bool _isPhoneNumberValid(String phoneNumber) {
//     final RegExp phoneNumberRegExp =
//         RegExp(r'^\+91\d{10}$'); // Matches +91 followed by 10 digits
//     final RegExp tenDigitRegExp =
//         RegExp(r'^\d{10}$'); // Matches exactly 10 digits
//
//     return phoneNumberRegExp.hasMatch(phoneNumber) ||
//         tenDigitRegExp.hasMatch(phoneNumber);
//   }
//
//   void _navigateToOTPScreen(BuildContext context) {
//     String enteredPhoneNumber = _phoneNumberController.text;
//
//     // Remove the "+" character for validation
//     enteredPhoneNumber = enteredPhoneNumber.replaceAll("+91", "");
//
//     if (enteredPhoneNumber.length == 10) {
//       // If the user entered exactly 10 digits, use it as is
//       String phoneNumber = "+91" + enteredPhoneNumber;
//
//       if (_isPhoneNumberValid(phoneNumber)) {
//         // Valid phone number format
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => OTPSendingScreen(
//               phoneNumber: phoneNumber,
//             ),
//           ),
//         );
//       } else {
//         // Invalid phone number format
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//                 'Invalid phone number format. Please enter +91 followed by 10 digits or 10 digits without any prefix.'),
//           ),
//         );
//       }
//     } else {
//       // Invalid phone number format
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//               'Invalid phone number format. Please enter 10 digits without any prefix.'),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Phone Number Verification')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             TextField(
//               controller: _phoneNumberController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: 'Enter 10-digit Phone Number (e.g., 1234567890)',
//               ),
//               maxLength: 13, // Limit to 12 characters (including "+91")
//               onChanged: (text) {
//                 // Ensure the phone number remains 10 or 12 digits
//                 if (text.length > 13) {
//                   _phoneNumberController.text = text.substring(0, 13);
//                 }
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => _navigateToOTPScreen(context),
//               child: const Text('Send OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// phone_signin_screen.dart
import 'package:flutter/material.dart';
import 'otp_sending_screen.dart';

class PhoneSigninScreen extends StatefulWidget {
  @override
  _PhoneSigninScreenState createState() => _PhoneSigninScreenState();
  static const routeName = '/phone_signin_screen'; // Ensure this line is present

}

class _PhoneSigninScreenState extends State<PhoneSigninScreen> {
  final TextEditingController _phoneNumberController =
  TextEditingController(text: '+91');

  // Function to verify phone number format
  bool _isPhoneNumberValid(String phoneNumber) {
    final RegExp phoneNumberRegExp =
    RegExp(r'^\+91\d{10}$'); // Matches +91 followed by 10 digits
    final RegExp tenDigitRegExp =
    RegExp(r'^\d{10}$'); // Matches exactly 10 digits

    return phoneNumberRegExp.hasMatch(phoneNumber) ||
        tenDigitRegExp.hasMatch(phoneNumber);
  }

  void _navigateToOTPScreen(BuildContext context) {
    String enteredPhoneNumber = _phoneNumberController.text;

    // Remove the "+" character for validation
    enteredPhoneNumber = enteredPhoneNumber.replaceAll("+91", "");

    if (enteredPhoneNumber.length == 10) {
      // If the user entered exactly 10 digits, use it as is
      String phoneNumber = "+91" + enteredPhoneNumber;

      if (_isPhoneNumberValid(phoneNumber)) {
        // Valid phone number format
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPSendingScreen(
              phoneNumber: phoneNumber,
            ),
          ),
        );
      } else {
        // Invalid phone number format
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Invalid phone number format. Please enter +91 followed by 10 digits or 10 digits without any prefix.'),
          ),
        );
      }
    } else {
      // Invalid phone number format
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Invalid phone number format. Please enter 10 digits without any prefix.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Number Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Enter 10-digit Phone Number (e.g., 1234567890)',
              ),
              maxLength: 13, // Limit to 12 characters (including "+91")
              onChanged: (text) {
                // Ensure the phone number remains 10 or 12 digits
                if (text.length > 13) {
                  _phoneNumberController.text = text.substring(0, 13);
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToOTPScreen(context),
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
