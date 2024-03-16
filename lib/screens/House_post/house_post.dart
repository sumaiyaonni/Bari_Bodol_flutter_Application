import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import '../../custom/custom_buttons.dart';

class PostHouseRent extends StatefulWidget {
  const PostHouseRent({Key? key}) : super(key: key);
  static String routeName = 'PostHouseRent';

  @override
  _PostHouseRentState createState() => _PostHouseRentState();
}

class _PostHouseRentState extends State<PostHouseRent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _priceOfHouse = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _houseDetails = TextEditingController();
  TextEditingController _bedRoomsController = TextEditingController();
  TextEditingController _bathRoomsController = TextEditingController();
  TextEditingController _garagesController = TextEditingController();

  List<File> _images = [];
  final picker = ImagePicker();

  bool _isUploading = false;

  Future<void> _getImage() async {
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 85,
    );

    if (_images.length + pickedFiles.length <= 6) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)));
      });
    } else {
      print("You can't select more than 6 images.");
    }
    }

  Future<void> _uploadAllData() async {
    setState(() {
      _isUploading = true;
    });

    try {
      if (_formKey.currentState!.validate() && _images.isNotEmpty) {
        User? firebaseUser = FirebaseAuth.instance.currentUser;

        if (firebaseUser != null) {
          String price = _priceOfHouse.text;
          String number = _phoneNumberController.text;
          String address = _address.text;
          String description = _houseDetails.text;
          String bedRooms = _bedRoomsController.text;
          String bathRooms = _bathRoomsController.text;
          String garages = _garagesController.text;

          List<String> imageUrl = [];

          for (var imageFile in _images) {
            Reference ref = FirebaseStorage.instance.ref().child(
                'user_house_images/${DateTime.now().millisecondsSinceEpoch}_${_images.indexOf(imageFile)}.jpg');

            UploadTask uploadTask = ref.putFile(imageFile);
            TaskSnapshot snapshot = await uploadTask;
            String imageURL = await snapshot.ref.getDownloadURL();
            imageUrl.add(imageURL);
          }

          await FirebaseFirestore.instance.collection("RentPost").add({
            "price": price,
            "number": number,
            "address": address,
            "description": description,
            "userId": firebaseUser.uid,
            "bedRooms": bedRooms,
            "bathRooms": bathRooms,
            "garages": garages,
            "isFav": false,
            "imageUrl": imageUrl[0], // Store the first image URL separately
            "moreImagesUrl": imageUrl, // Store the rest of the image URLs
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.accessible_forward,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Post upload Done",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: kPrimaryColor,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 6,
            ),
          );
          Navigator.pop(context);

          print("Data upload successful.");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.nearby_error,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Error found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: kErrorBorderColor,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 6,
            ),
          );

          print("User is null. Unable to upload data.");
        }
      }
    } catch (e) {
      print("Error uploading user data: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Rent House Details',style: TextStyle(color: kTextWhiteColor),),
      ),
      body: _isUploading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(_priceOfHouse, 'Rent Of House'),
              SizedBox(height: 16.0),
              _buildInputField(_phoneNumberController, 'Phone Number'),
              SizedBox(height: 16.0),
              _buildInputField(_address, 'Address'),
              SizedBox(height: 16.0),
              _buildInputField(_houseDetails, 'House Details'),
              SizedBox(height: 16.0),
              _buildInputField(_bedRoomsController, 'Bedrooms',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              _buildInputField(_bathRoomsController, 'Bathrooms',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              _buildInputField(_garagesController, 'Garages',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              DefaultButton(onPress: _getImage, title: 'Select Images (max-5)'),
              SizedBox(height: 16.0),
              _images.isEmpty
                  ? Container()
                  : Column(
                children: _images.map((image) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              DefaultButton(onPress: _uploadAllData, title: 'Post Rent House'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String labelText,
      {TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }
}
