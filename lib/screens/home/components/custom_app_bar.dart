import 'package:bari_bodol/constants/colors..dart';
import 'package:bari_bodol/constants/styles.dart';
import 'package:bari_bodol/firebase_auth/fetch_data/fetch_data.dart';
import 'package:bari_bodol/profile.dart';
import 'package:bari_bodol/screens/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';

class TopSection extends StatefulWidget {
  const TopSection({super.key});

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  final TextStyle textStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: darkBlue,
  );
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, top: 40),
      padding: const EdgeInsets.symmetric(horizontal: appPadding / 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Hello!",
              ),
              Text(
                '${userData["Name"]}',
                style: textStyle,
              )
            ],
          ),
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: TextButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  ProfileView(),
                ),
              );
            },
                child: Icon(Icons.person, color: darkBlue, size: 25.0)),
          )
        ],
      ),
    );
  }
}
