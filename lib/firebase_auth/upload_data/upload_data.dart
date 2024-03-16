import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/house.dart';

class FirebaseDataUploader {
  static Future<void> uploadUserData({
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        CollectionReference collRef =
        FirebaseFirestore.instance.collection("users");

        // Explicitly set the document ID to be the same as the user's UID
        DocumentReference docRef = collRef.doc(firebaseUser.uid);

        await docRef.set({
          "Name": name,
          "Phone Number": phoneNumber,
          "Email": email,
          "Password": password,
          "uid": firebaseUser.uid,
        });

        print("Data upload successful. Document ID (UID): ${docRef.id}");
      } else {
        print("User is null. Unable to upload data.");
      }
    } catch (e) {
      print("Error uploading user data: $e");
    }
  }
}


