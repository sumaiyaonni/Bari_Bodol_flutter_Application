import 'package:bari_bodol/screens/login_screen/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBVgz2hJJKwOplSo_DHyBjOgNJWJQnsics",
          projectId: "bari-bodol",
          messagingSenderId: "647642615738",
          appId: "1:647642615738:web:107b828e3f03078cf55783",
        ),
      );
      print('Web Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBVgz2hJJKwOplSo_DHyBjOgNJWJQnsics",
        projectId: "bari-bodol",
        messagingSenderId: "647642615738",
        appId: "1:647642615738:web:107b828e3f03078cf55783",
      ),
    );
    print('Android Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baari Bodol',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: routes,
    );
  }
}