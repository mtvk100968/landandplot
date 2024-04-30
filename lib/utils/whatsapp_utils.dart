// whatsapp_utils.dart
import 'package:url_launcher/url_launcher.dart';

class WhatsAppUtils {
  static Future<void> sendWhatsAppMessage(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber'); // Ensure the phone number is in full international format without the '+' sign
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      // Handle the case where WhatsApp is not available
      // You might want to show an error message or take other appropriate action
    }
  }
}

