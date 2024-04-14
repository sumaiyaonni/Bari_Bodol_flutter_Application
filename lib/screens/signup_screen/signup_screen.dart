import 'package:bari_bodol/constants/constants.dart';
import 'package:bari_bodol/custom/custom_buttons.dart';
import 'package:bari_bodol/firebase_auth/firebase_auth_service.dart';
import 'package:bari_bodol/firebase_auth/upload_data/upload_data.dart';
import 'package:bari_bodol/screens/home/Test_Screen/test_Home_Screen.dart';
import 'package:bari_bodol/screens/home/home_screen.dart';
import 'package:bari_bodol/screens/login_screen/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

late bool _passwordVisible;

class SignUpScreen extends StatefulWidget {
  static const String routeName = 'SignUpScreen';

  const SignUpScreen({
    super.key,
  });

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _uploadData() {
    FirebaseDataUploader.uploadUserData(
      name: _usernameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _signUp() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (_formKey.currentState!.validate()) {
        // Access the user data using userCredential.user
        User? user = await _auth.signUpWithEmailAndPassword(email, password);

        if (user != null) {
          //<---upload Data to Firebase--->
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.accessible_forward,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Signup Successfull",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: kPrimaryColor,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 5), // Adjust the duration as needed
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
            //margin: EdgeInsets.all(20),
          ),);
          _uploadData();
          print("Data upload successfully Done");
          //<---UPLOAD DONE--->
          Navigator.pushNamed(context, HomeScreen.routeName);
          print("User is successfully created");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Some error found!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: kErrorBorderColor,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 5), // Adjust the duration as needed
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
            //margin: EdgeInsets.all(20),
          ),);

          print("Unexpected error: User is null");
        }
      }
    } catch (e) {
      print("Sign-up failed: $e");
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: kTextWhiteColor,
            )),
      ),
      body: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/house.png',
                  height: 150.0,
                  width: 150.0,
                ),
                const SizedBox(height: kDefaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            //fontWeight: FontWeight.w200,
                            fontSize: 30,
                            color: Colors.black26,
                          ),
                    ),
                    Text(
                      'Baari Bodol',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 30,
                            color: Colors.deepPurple,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultPadding / 6),
                Text(
                  'Create new account',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 20,
                        color: Colors.black26,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding * 3),
                topRight: Radius.circular(kDefaultPadding * 3),
              ),
              color: kOtherColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        sizeBox,
                        buildNameField(),
                        sizeBox,
                        buildPhoneNumberField(),
                        sizeBox,
                        buildEmailField(),
                        sizeBox,
                        buildPasswordField(),
                        sizeBox,
                        DefaultButton(
                          onPress: _signUp,
                          title: 'Sign Up',
                        ),
                        sizeBox,
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                            ),
                            );
                          },
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Already have an account?",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneController,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: kTextBlackColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
      ),
      validator: (value) {
        if (value == null || value!.isEmpty) {
          return 'Please enter some text';
        }
      },
    );
  }

  TextFormField buildNameField() {
    return TextFormField(
      controller: _usernameController,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: kTextBlackColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
      decoration: const InputDecoration(
        labelText: 'Full Name',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
      ),
      validator: (value) {
        if (value == null || value!.isEmpty) {
          return 'Please enter some text';
        }
      },
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: _emailController,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: kTextBlackColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
      decoration: const InputDecoration(
        labelText: 'Email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
      ),
      validator: (value) {
        RegExp regExp = RegExp(emailPattern);
        if (value == null || value!.isEmpty) {
          return 'Please enter some text';
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid address';
        }
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _passwordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      style: const TextStyle(
        color: kTextBlackColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        labelText: 'Password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible
                ? Icons.visibility_off_outlined
                : Icons.remove_red_eye_outlined,
          ),
          iconSize: kDefaultPadding,
        ),
      ),
      validator: (value) {
        if (value!.length < 6) {
          return 'Must be more then 6 character';
        }
      },
    );
  }
}
