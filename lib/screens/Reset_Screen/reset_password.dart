import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);
  static String routeName = 'PasswordResetPage';

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _resetMessage = '';
  bool _showPasswordResetForm = false;

  Future<void> _resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        _resetMessage = 'Password reset email sent. Please check your email.';
        _showPasswordResetForm = true;
      });
    } catch (e) {
      setState(() {
        _resetMessage = 'Error sending password reset email: $e';
      });
    }
  }

  Future<void> _updatePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        setState(() {
          _resetMessage = 'Password updated successfully.';
        });
      }
    } catch (e) {
      setState(() {
        _resetMessage = 'Error updating password: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_showPasswordResetForm)
              Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _resetPassword(_emailController.text.trim()),
                    child: Text('Reset Password'),
                  ),
                ],
              ),
            if (_showPasswordResetForm)
              Column(
                children: [
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'New Password'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _updatePassword(_passwordController.text),
                    child: Text('Update Password'),
                  ),
                ],
              ),
            SizedBox(height: 10),
            Text(
              _resetMessage,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
