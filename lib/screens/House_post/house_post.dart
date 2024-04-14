import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../constants/constants.dart';
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
  TextEditingController _houseDetails = TextEditingController();
  TextEditingController _bedRoomsController = TextEditingController();
  TextEditingController _bathRoomsController = TextEditingController();
  TextEditingController _garagesController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _sectorController = TextEditingController();
  TextEditingController _roadController = TextEditingController();
  TextEditingController _othersController = TextEditingController();

  List<File> _images = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 85,
    );
    setState(() {
      if (pickedFiles != null) {
        // Add the selected images to the list
        _images.addAll(pickedFiles.map((file) => File(file.path)));
      }
    });
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
          String area = _areaController.text;
          String sector = _sectorController.text;
          String road = _roadController.text;
          String others = _othersController.text;
          String address = '$area, Sector: $sector, Road: $road, Others: $others';
          String description = _houseDetails.text;
          String bedRooms = _bedRoomsController.text;
          String bathRooms = _bathRoomsController.text;
          String garages = _garagesController.text;

          List<String> imageUrl = [];
          double totalProgress = 0.0;

          for (var imageFile in _images) {
            Reference ref = FirebaseStorage.instance.ref().child(
                'user_house_images/${DateTime.now().millisecondsSinceEpoch}_${_images.indexOf(imageFile)}.jpg');

            UploadTask uploadTask = ref.putFile(imageFile);
            TaskSnapshot snapshot = await uploadTask;
            String imageURL = await snapshot.ref.getDownloadURL();
            imageUrl.add(imageURL);

            totalProgress += 1 / _images.length;
            setState(() {
              _uploadProgress = totalProgress;
            });
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
              content: const Row(
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
              content: const Row(
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
              duration: const Duration(seconds: 5),
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
        _uploadProgress = 0.0;
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
        child: CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 16.0,
          percent: _uploadProgress,
          center: Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
          progressColor: Colors.blue,
        ),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(_priceOfHouse, 'Rent'),
              SizedBox(height: 16.0),
              _buildInputField(_phoneNumberController, 'Contact Number'),
              SizedBox(height: 16.0),
              _buildInputField(_areaController, 'Area'),
              SizedBox(height: 16.0),
              _buildInputField(_sectorController, 'Sector'),
              SizedBox(height: 16.0),
              _buildInputField(_roadController, 'Road'),
              SizedBox(height: 16.0),
              _buildInputField(_othersController, "Other's Address"),
              SizedBox(height: 16.0),
              _buildInputField(_houseDetails, 'House Details'),
              SizedBox(height: 16.0),
              _buildInputField(_bedRoomsController, 'Number of Bedrooms',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              _buildInputField(_bathRoomsController, 'Number of Bathrooms',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              _buildInputField(_garagesController, 'Parking',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              DefaultButton(onPress: _getImage, title: 'Select Images'),
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
              const SizedBox(height: 16.0),
              DefaultButton(onPress: _uploadAllData, title: 'POST'),
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
