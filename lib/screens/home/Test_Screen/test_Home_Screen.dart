import 'package:flutter/material.dart';
import '../components/houses.dart';
import 'app_bar.dart';

class TestHomeScreen extends StatefulWidget {
  const TestHomeScreen({Key? key}) : super(key: key);
  static String routeName = 'TestHomeScreen';

  @override
  State<TestHomeScreen> createState() => _TestHomeScreenState();
}

class _TestHomeScreenState extends State<TestHomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TestTopSection(), // Assuming you have a TopSection component
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Expanded(
            child: Houses(), // Assuming Houses is a ListView or similar widget
          ),
        ],
      ),
    );
  }
}
