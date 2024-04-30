// facebook_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithFacebook() async {
    print("Attempting to sign in with Facebook 1");

    try {
      // Trigger the Facebook Sign-in.
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // Get the Facebook Auth credential
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);
        // Use the credential to sign-in with Firebase
        final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        print("Attempting to sign in with Facebook 1");
        // Return the signed-in user
        return userCredential.user;
      } else if (result.status == LoginStatus.cancelled) {
        // Handle the case where the user cancelled the sign-in
        print('Facebook sign-in was cancelled.');
        return null;
      } else {
        // Handle any other error that might have occurred
        print('Facebook sign-in failed: ${result.status}');
        return null;
      }
    } catch (error) {
      print('Facebook Sign-in Error: $error');
      return null;
    }
  }
}
