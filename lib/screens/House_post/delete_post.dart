import 'package:bari_bodol/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../model/house.dart';

class DeletePost extends StatefulWidget {
  const DeletePost({Key? key}) : super(key: key);

  @override
  _DeletePostState createState() => _DeletePostState();
}

class _DeletePostState extends State<DeletePost> {
  late final User _currentUser;
  late Stream<List<House>> _userPostsStream;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _userPostsStream = _fetchUserPosts();
  }

  Stream<List<House>> _fetchUserPosts() {
    return FirebaseFirestore.instance
        .collection('RentPost')
        .where('userId', isEqualTo: _currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return House(
          imageUrl: doc.get('imageUrl'),
          address: doc.get('address'),
          description: doc.get('description'),
          price: doc.get('price'),
          bedRooms: doc.get('bedRooms'),
          bathRooms: doc.get('bathRooms'),
          garages: doc.get('garages'),
          number: doc.get('number'),
          isFav: doc.get('isFav'),
          moreImagesUrl: List<String>.from(doc.get('moreImagesUrl')),
          docId: doc.id, // Extracting document ID
        );
      }).toList();
    });
  }

  Future<void> _deletePost(BuildContext context, {required String postId, required List<String> imageUrls}) async {
    try {
      // Delete images from Firebase Storage
      for (String imageUrl in imageUrls) {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      // Delete post from Firestore
      await FirebaseFirestore.instance.collection('RentPost').doc(postId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post deleted successfully.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete post. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('List of Post',style: TextStyle(
          color: kTextWhiteColor,
        ),),
        centerTitle: true,
      ),
      body: StreamBuilder<List<House>>(
        stream: _userPostsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<House> userPosts = snapshot.data ?? [];
            return ListView.builder(
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                House post = userPosts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(post.address),
                    subtitle: Text('Price: ${post.price}Tk'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirm Delete'),
                          content: Text('Are you sure you want to delete this post?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deletePost(context, postId: post.docId, imageUrls: post.moreImagesUrl);
                                Navigator.pop(context);
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
