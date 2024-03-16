import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bari_bodol/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyC-S_ngfbTqQ7okcim62iPVhbVIA6TYKNM',
          appId: '1:650533910297:web:b5f37f040829516450f788',
          messagingSenderId: '650533910297',
          projectId: 'bari-bodol-cbb21',
          authDomain: 'bari-bodol-cbb21.firebaseapp.com',
          storageBucket: 'bari-bodol-cbb21.appspot.com',
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
        apiKey: 'AIzaSyAGRiYJi_g0CMhdfD24dxyvhT_mr332jYE',
        appId: '1:650533910297:android:b2491e0e6681708b50f788',
        messagingSenderId: '650533910297',
        projectId: 'bari-bodol-cbb21',
        storageBucket: 'bari-bodol-cbb21.appspot.com',
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
    return GetMaterialApp(
      title: 'Bari Bodol',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen.withScreenFunction(
        backgroundColor: Colors.indigoAccent,
        splash: 'assets/images/house.png',
        splashIconSize: 150,

        screenFunction: () async{
          return WelcomeScreen();
        },
        splashTransition: SplashTransition.sizeTransition,
      ),
      routes: routes,
    );
  }
}
