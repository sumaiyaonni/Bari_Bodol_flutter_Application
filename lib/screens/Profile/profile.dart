import 'package:bari_bodol/constants/constants.dart';
import 'package:bari_bodol/screens/House_post/house_post.dart';
import 'package:bari_bodol/screens/Profile/profile_image.dart';
import 'package:bari_bodol/screens/login_screen/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase_auth/fetch_data/fetch_data.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    userData = (await FirebaseDataFetcher.fetchUserData())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundColor: Colors.indigoAccent,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(width: 400, height: 450),
                  Container(
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 70),
                        Text(
                          '${userData["Name"]}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        kHalfSizeBox,
                        Text(
                          'Email: ${userData["Email"]}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        kHalfSizeBox,
                        Text(
                          'Phone: ${userData["Phone Number"]}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        kHalfSizeBox,
                        TextButton(
                          onPressed: () {
                            //Navigator.pushNamed(context, PostHouseRent.routeName);
                            Navigator.pushNamed(context, PostHouseRent.routeName);
                          },
                          child: Container(
                            width: 250,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "Make a Post",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.indigoAccent),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                      top: 0,
                      child: ProfileImagePicker()),
                  const Positioned(
                    top: 100,
                    child: Chip(
                        backgroundColor: Colors.green,
                        label: Text(
                          "Active",
                          style: TextStyle(
                            fontSize: 15,
                            color: kTextWhiteColor,
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Row(
                  children: [
                    Icon(
                      Icons.accessible_forward,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Logout Successfully",
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
                duration: Duration(seconds: 5), // Adjust the duration as needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 6,
                //margin: EdgeInsets.all(20),
              ),);
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
            child: Container(
              width: 200,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "LOGOUT",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}