import 'package:flutter/material.dart';
import 'components/custom_app_bar.dart';
import 'components/houses.dart';
import 'components/search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopSection(), // Assuming you have a TopSection component
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
