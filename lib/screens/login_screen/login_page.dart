import 'package:bari_bodol/constants.dart';
import 'package:bari_bodol/custom/custom_buttons.dart';
import 'package:bari_bodol/firebase_auth/firebase_auth_service.dart';
import 'package:bari_bodol/screens/home/home_screen.dart';
import 'package:bari_bodol/screens/signup_screen/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  void _signIn() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (_formKey.currentState!.validate()) {
        // Access the user data using userCredential.user
        User? user = await _auth.signInWithEmailAndPassword(email, password);

        if (user != null) {
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
                    "Successfully SignIn",
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
          Navigator.pushNamed(context, HomeScreen.routeName);
          print("User is successfully SignIn");
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
                    "Email or Password Incorrect",
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.arrow_back_ios,
            )),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height /2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/house.png',
                  height: 200.0,
                  width: 250.0,
                ),
                const SizedBox(height: kDefaultPadding / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bari Bodol',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 35,
                          color: Colors.deepPurple,
                        )),
                  ],
                ),
                const SizedBox(height: kDefaultPadding / 6),
                Text(
                  'Login to continue',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 20,
                    color: Colors.black26,
                  ),
                )
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
                        buildEmailField(),
                        sizeBox,
                        buildPasswordField(),
                        sizeBox,
                        InkWell(
                          onTap: () {},
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Forget password?',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        sizeBox,
                        DefaultButton(
                          onPress: _signIn,
                          title: 'Login',
                        ),
                        sizeBox,
                        InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                SignUpScreen.routeName, (route) => false);
                          },
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Don't have an account?",
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

  TextFormField buildEmailField() {
    return TextFormField(
      controller: _emailController,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
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
      style: TextStyle(
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
        if (value!.length < 5) {
          return 'Must be more then 5 character';
        }
      },
    );
  }
}