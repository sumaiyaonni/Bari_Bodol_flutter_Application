import 'package:bari_bodol/screens/home/Test_Screen/test_Home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //user is logged in
          if(snapshot.hasData)
          {
            return const HomeScreen();
          }

          //user is not log in
          else{
            return const TestHomeScreen();
          }
        },
      ),
    );
  }
}