// call_utils.dart
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class CallUtils {
  static Future<void> makeCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (Platform.isAndroid && !await canLaunchUrl(phoneUri)) {
      // Show a message to the user that calling is not available
    } else {
      // Proceed with the launch call
      await launchUrl(phoneUri);
    }
  }
}
