import 'package:bari_bodol/constants/colors..dart';
import 'package:bari_bodol/constants/styles.dart';
import 'package:bari_bodol/screens/login_screen/login_page.dart';
import 'package:flutter/material.dart';

class TestTopSection extends StatelessWidget {
  final TextStyle textStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: darkBlue,
  );

  const TestTopSection({super.key});

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
                "Welcome to Bari Bodol",
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
                  builder: (context) => const LoginScreen(),
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
