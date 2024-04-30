// lib/services/user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> storeUserData(User user) async {
    Map<String, dynamic> userData = {
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      // ... other user data ...
    };
    // Add or update user document in Firestore
    return await _usersCollection.doc(user.uid).set(userData, SetOptions(merge: true));
  }
}