import 'package:flutter/material.dart';
import '../components/houses.dart';
import '../components/search_field.dart';
import 'app_bar.dart';

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TestTopSection(), // Assuming you have a TopSection component
          SearchField(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Expanded(
            child: Houses(), // Assuming Houses is a ListView or similar widget
          ),
        ],
      ),
    );
  }
}
