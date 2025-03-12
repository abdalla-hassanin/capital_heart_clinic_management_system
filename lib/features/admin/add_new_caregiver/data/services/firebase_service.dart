import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  Future<String> uploadImage(dynamic image, String path) async {
    try {
      final ref = storage.ref().child(path);
      UploadTask uploadTask;

      if (image is File) {
        uploadTask = ref.putFile(image);
      } else if (image is Uint8List) {
        uploadTask = ref.putData(image);
      } else {
        throw Exception('Invalid image type');
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}