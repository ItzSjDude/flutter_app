import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/CountDownTimer.dart';  // Ensure this path is correct

// State notifier for managing deposit state
class DepositState {
  final String tokenAddress;
  final String tokenImage;
  final bool isLoading;
  final bool isSubmitted;

  DepositState({
    required this.tokenAddress,
    required this.tokenImage,
    this.isLoading = true,
    this.isSubmitted = false,
  });

  DepositState copyWith({
    String? tokenAddress,
    String? tokenImage,
    bool? isLoading,
    bool? isSubmitted,
  }) {
    return DepositState(
      tokenAddress: tokenAddress ?? this.tokenAddress,
      tokenImage: tokenImage ?? this.tokenImage,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

class DepositNotifier extends StateNotifier<DepositState> {
  DepositNotifier() : super(DepositState(tokenAddress: '', tokenImage: '')) {
    fetchTokenData();
  }

  Future<void> fetchTokenData() async {
    try {
      final response = await http.get(Uri.parse('https://tl.brainyhub.in/api/get_token.php'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          state = state.copyWith(
            tokenAddress: responseData['data']['token_address'],
            tokenImage: responseData['data']['token_image'],
            isLoading: false,
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch token data');
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  void setSubmitted(bool value) {
    state = state.copyWith(isSubmitted: value);
  }
}

final depositProvider = StateNotifierProvider<DepositNotifier, DepositState>((ref) => DepositNotifier());

class DepositScreen extends ConsumerWidget {
  DepositScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _transactionIdController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depositState = ref.watch(depositProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit USDT', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text(
              //   'TRC20 USDT Token Address',
              //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
              //   textAlign: TextAlign.center,
              // ),
              SizedBox(height: 8),
              Center(
                child: CountdownTimer(
                  duration: Duration(minutes: 30),
                  // onTimerExpired: () {
                  //   // Timer expired callback
                  // },
                ),
              ),
              SizedBox(height: 16),
              _buildTokenInfo(context, depositState),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Warning: Only TRC20 network is supported.',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              _buildTransactionForm(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenInfo(BuildContext context, DepositState state) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Text('TRC20 USDT Token Address:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _copyToClipboard(context, state.tokenAddress),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    state.tokenAddress,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.copy, size: 18),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        if (state.tokenImage.isNotEmpty)
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                state.tokenImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.error, size: 40),
              ),
            ),
          )
        else
          Text('No image available', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionForm(BuildContext context, WidgetRef ref) {
    final depositState = ref.watch(depositProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _transactionIdController,
            decoration: InputDecoration(
              labelText: 'Transaction ID',
              hintText: 'Enter your transaction ID',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Icon(Icons.receipt_long, size: 20),
            ),
            validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter a transaction ID' : null,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: depositState.isSubmitted
                ? null
                : () => _submitDeposit(context, ref),
            child: Text(
              depositState.isSubmitted ? 'Submitted' : 'Submit',
              style: TextStyle(fontSize: 14),  // Reduced font size
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: depositState.isSubmitted ? Colors.grey : Colors.green,
              padding: EdgeInsets.symmetric(vertical: 12),  // Reduced vertical padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Token address copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitDeposit(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState?.validate() ?? false) {
      final transactionId = _transactionIdController.text;
      final depositState = ref.read(depositProvider);

      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId') ?? '0';

        final response = await http.post(
          Uri.parse('https://tl.brainyhub.in/api/deposit_usdt.php'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'user_id': userId,
            'transaction_id': transactionId,
            'usdt_address': depositState.tokenAddress,
          },
        );

        final responseData = json.decode(response.body);

        if (response.statusCode == 200 && responseData['status'] == 'success') {
          ref.read(depositProvider.notifier).setSubmitted(true);
          _showSuccessDialog(context, transactionId);
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error occurred');
        }
      } catch (error) {
        _showErrorDialog(context, 'An error occurred: $error');
      }
    }
  }

  void _showSuccessDialog(BuildContext context, String transactionId) {
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
                Navigator.of(context).pop();
                _formKey.currentState?.reset();
                _transactionIdController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
