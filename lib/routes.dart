import 'package:bari_bodol/screens/House_post/house_post.dart';
import 'package:bari_bodol/screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'screens/home/home_screen.dart';
import 'screens/login_screen/login_page.dart';
import 'screens/signup_screen/signup_screen.dart';

//static String routeName = 'LoginScreen';

Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName : (context) =>  const LoginScreen(),
  SignUpScreen.routeName : (context) =>  const SignUpScreen(),
  HomeScreen.routeName : (context) =>  const HomeScreen(),
  WelcomeScreen.routeName : (context) =>  const WelcomeScreen(),
  PostHouseRent.routeName : (context) =>  const PostHouseRent(),

};