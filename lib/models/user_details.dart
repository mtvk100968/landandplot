import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final int userId;
  final String fullName;
  final String contactNumber;
  final String email;
  final String? address;
  final String? identityProof;
  final int? ownedProperties;
  final String imageUrl;
  final String company;

  UserDetails({
    required this.userId,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    this.address,
    this.identityProof,
    this.ownedProperties,
    required this.imageUrl,
    required this.company,
  });

  factory UserDetails.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserDetails(
      userId: data['owner_id'],
      fullName: data['full_name'],
      contactNumber: data['contact_number'],
      email: data['email'],
      address: data['address'],
      identityProof: data['identity_proof'],
      ownedProperties: data['owned_properties'],
      imageUrl: data['imageUrl'],
      company: data['company'],
    );
  }

  static Future<Map<String, UserDetails>> fetchUserDetailsMap() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    Map<String, UserDetails> userDetailsMap = {};
    for (var doc in querySnapshot.docs) {
      userDetailsMap[doc.id] = UserDetails.fromFirestore(doc);
    }
    return userDetailsMap;
  }
}