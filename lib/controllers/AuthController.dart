import 'dart:convert'; // For jsonEncode
import 'package:flutter_project/screens/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // For showing dialogs or other UI elements

class AuthController {
  final String _loginUrl = 'http://tl.brainyhub.in/api/login.php'; // Your API URL

  Future<void> loginUser(String email, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          // Handle successful login
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(), // Replace with your home page
            ),
          );
        } else {
          // Handle errors from the server
          _showErrorDialog(context, responseData['message']);
        }
      } else {
        // Handle unexpected server responses
        _showErrorDialog(context, 'Unexpected error occurred');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      _showErrorDialog(context, 'Network error: ${e.toString()}');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
