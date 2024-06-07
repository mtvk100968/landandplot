import 'package:flutter/material.dart';

class BillingPage extends StatelessWidget {
  final Map<String, dynamic> propertyDetails;
  final Function(Map<String, dynamic>) onComplete;

  BillingPage({required this.propertyDetails, required this.onComplete});

  void _handlePaymentSuccess(BuildContext context) {
    // Simulate payment success
    onComplete(propertyDetails);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handlePaymentSuccess(context),
          child: Text('Complete Payment'),
        ),
      ),
    );
  }
}