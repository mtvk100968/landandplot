import 'package:sendgrid_mailer/sendgrid_mailer.dart';

Future<void> sendEmail(String toEmail, String subject, String message) async {
  final mailer = Mailer('YOUR_SENDGRID_API_KEY');
  final toAddress = Address(toEmail);
  final fromAddress = Address('your-email@example.com');

  final personalization = Personalization([toAddress]);
  final email = Email(
    [personalization],
    fromAddress,
    subject,
    content: [
      Content('text/plain', message),
    ],
  );

  final response = await mailer.send(email);
  if (response.isValue) {
    print('Email sent successfully');
  } else {
    print('Failed to send email: ${response.asError!.error}');
  }
}
