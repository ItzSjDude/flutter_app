import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/CountDownTimer.dart'; // Ensure you have this widget implemented

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _transactionIdController = TextEditingController();
  final String _usdtAddress = '0x1234567890abcdef1234567890abcdef12345678'; // Replace with dynamic value if needed

  bool _isSubmitted = false; // Track whether the form has been submitted

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit USDT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('USDT Address:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(8),
                child: SelectableText(
                  _usdtAddress,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Transaction ID',
                  hintText: 'Enter your transaction ID',
                ),
                controller: _transactionIdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a transaction ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Timer:', style: TextStyle(fontWeight: FontWeight.bold)),
              CountdownTimer(duration: Duration(minutes: 30)),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text(_isSubmitted ? 'Submitted' : 'Submit'),
                onPressed: _isSubmitted
                    ? null // Disable button if already submitted
                    : () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final transactionId = _transactionIdController.text;
                    final usdtAddress = _usdtAddress; // Replace if dynamic

                    // Fetch user ID from SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getString('userId') ?? '0'; // Default to '0' if not found

                    _submitDeposit(userId, transactionId, usdtAddress);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle deposit submission
  Future<void> _submitDeposit(String userId, String transactionId, String usdtAddress) async {
    final url = Uri.parse('https://tl.brainyhub.in/api/deposit_usdt.php'); // Replace with your API endpoint

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_id': userId,
          'transaction_id': transactionId,
          'usdt_address': usdtAddress,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Deposit with Transaction ID: $transactionId was successful.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      setState(() {
                        _isSubmitted = true; // Update button text to "Submitted"
                      });
                      _formKey.currentState?.reset();
                      _transactionIdController.clear();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          _showErrorDialog(responseData['message'] ?? 'Unknown error occurred');
        }
      } else {
        _showErrorDialog('Failed to connect to the server');
      }
    } catch (error) {
      _showErrorDialog('An error occurred: $error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
