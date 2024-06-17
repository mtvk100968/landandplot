import 'package:flutter/cupertino.dart';
import 'package:landandplot/screens/user_registration_form.dart';

class TenantRegistrationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserRegistrationForm(userType: 'tenant');
  }
}
