// models/user_details.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String userId;
  final String? email;
  final String? phoneNumber;
  final String? fullName;
  final String? imageUrl;
  final String? company;

  UserDetails({
    required this.userId,
    this.email,
    this.phoneNumber,
    this.fullName,
    this.imageUrl,
    this.company,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'imageUrl': imageUrl,
      'company': company,
    };
  }

  static UserDetails fromMap(Map<String, dynamic> map) {
    return UserDetails(
      userId: map['userId'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      fullName: map['fullName'],
      imageUrl: map['imageUrl'],
      company: map['company'],
    );
  }

  static Future<Map<String, UserDetails>> fetchUserDetailsMap() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('userDetails').get();

      Map<String, UserDetails> userDetailsMap = {};

      for (var doc in querySnapshot.docs) {
        userDetailsMap[doc.id] =
            UserDetails.fromMap(doc.data() as Map<String, dynamic>);
      }

      return userDetailsMap;
    } catch (e) {
      print('Error fetching user details: $e');
      return {};
    }
  }
}
