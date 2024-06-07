
import 'package:twilio_flutter/twilio_flutter.dart';

Future<void> sendSms(String toNumber, String message) async {
  final twilioFlutter = TwilioFlutter(
    accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
    authToken: 'YOUR_TWILIO_AUTH_TOKEN',
    twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
  );

  await twilioFlutter.sendSMS(
    toNumber: toNumber,
    messageBody: message,
  ).catchError((error) {
    print('Failed to send SMS: $error');
  });
}
