import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> uploadImage(String filePath, String propertyId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('property_images')
        .child('$propertyId/${DateTime.now().millisecondsSinceEpoch}.jpg');

    final uploadTask = ref.putFile(File(filePath));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}