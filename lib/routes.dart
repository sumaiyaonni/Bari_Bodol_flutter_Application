import 'package:flutter/cupertino.dart';

import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen/login_page.dart';
import 'screens/signup_screen/signup_screen.dart';

//static String routeName = 'LoginScreen';

Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName : (context) =>  const LoginScreen(),
  SignUpScreen.routeName : (context) =>  const SignUpScreen(),
  HomeScreen.routeName : (context) =>  const HomeScreen(),

};