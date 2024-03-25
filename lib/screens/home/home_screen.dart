import 'package:flutter/material.dart';
import 'components/custom_app_bar.dart';
import 'components/houses.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopSection(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Expanded(
            child: Houses(),
          ),
        ],
      ),
    );
  }
}
