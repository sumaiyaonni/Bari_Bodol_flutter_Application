import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDataFetcher {
  static Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        DocumentSnapshot ds = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .get();

        if (ds.exists && ds.data() != null) {
          // Return the user data as a Map
          return ds.data() as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null; // Return null in case of an error or when the data doesn't exist
  }
}
