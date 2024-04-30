// message_utils.dart
import 'package:url_launcher/url_launcher.dart';

class MessageUtils {
  static Future<void> sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (!await canLaunchUrl(smsUri)) {
      // Show a message to the user that SMS is not available
    } else {
      // Proceed with the launch SMS
      await launchUrl(smsUri);
    }
  }
}
