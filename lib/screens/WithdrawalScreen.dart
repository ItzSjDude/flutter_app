import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawalState {
  final bool isBankBound;
  final bool isLoading;
  final String? errorMessage;

  WithdrawalState({
    this.isBankBound = false,
    this.isLoading = false,
    this.errorMessage,
  });

  WithdrawalState copyWith({
    bool? isBankBound,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WithdrawalState(
      isBankBound: isBankBound ?? this.isBankBound,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

final withdrawalProvider = StateNotifierProvider<WithdrawalNotifier, WithdrawalState>((ref) {
  return WithdrawalNotifier();
});

class WithdrawalNotifier extends StateNotifier<WithdrawalState> {
  WithdrawalNotifier() : super(WithdrawalState());

  Future<void> bindBankAccount(Map<String, String> bankDetails) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Implement the API call to bind the bank account
      // For example:
      // final response = await http.post('your_api_endpoint', body: bankDetails);
      // if (response.statusCode == 200) {
      //   state = state.copyWith(isBankBound: true, isLoading: false);
      // } else {
      //   throw Exception('Failed to bind bank account');
      // }

      // For now, we'll just simulate a successful binding
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay
      state = state.copyWith(isBankBound: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> submitWithdrawal(String amount) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Implement the API call to submit the withdrawal
      // For example:
      // final response = await http.post('your_api_endpoint', body: {'amount': amount});
      // if (response.statusCode == 200) {
      //   state = state.copyWith(isLoading: false);
      // } else {
      //   throw Exception('Failed to submit withdrawal');
      // }

      // For now, we'll just simulate a successful withdrawal
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

class WithdrawalScreen extends ConsumerWidget {
  WithdrawalScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _bankAccountNumberController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawalState = ref.watch(withdrawalProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw USDT', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBankDetailsSection(context, ref),
                  SizedBox(height: 32),
                  _buildWithdrawalSection(context, ref),
                  if (withdrawalState.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        withdrawalState.errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankDetailsSection(BuildContext context, WidgetRef ref) {
    final withdrawalState = ref.watch(withdrawalProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bank Account Details',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            _buildTextField(
              controller: _bankAccountNumberController,
              label: 'Bank Account Number',
              icon: Icons.account_balance,
              validator: (value) => value?.isEmpty ?? true ? 'Please enter bank account number' : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _accountHolderNameController,
              label: 'Account Holder Name',
              icon: Icons.person,
              validator: (value) => value?.isEmpty ?? true ? 'Please enter account holder name' : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _ifscCodeController,
              label: 'IFSC Code',
              icon: Icons.code,
              validator: (value) => value?.isEmpty ?? true ? 'Please enter IFSC code' : null,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: withdrawalState.isLoading
                  ? null
                  : () {
                if (_formKey.currentState?.validate() ?? false) {
                  ref.read(withdrawalProvider.notifier).bindBankAccount({
                    'bank_account_number': _bankAccountNumberController.text,
                    'account_holder_name': _accountHolderNameController.text,
                    'ifsc_code': _ifscCodeController.text,
                  });
                }
              },
              child: Text(withdrawalState.isBankBound ? 'Bank Account Bound' : 'Bind Bank Account'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawalSection(BuildContext context, WidgetRef ref) {
    final withdrawalState = ref.watch(withdrawalProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Withdrawal Amount',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            _buildTextField(
              controller: _amountController,
              label: 'Amount (USDT)',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Please enter withdrawal amount' : null,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: (!withdrawalState.isBankBound || withdrawalState.isLoading)
                  ? null
                  : () {
                if (_formKey.currentState?.validate() ?? false) {
                  ref.read(withdrawalProvider.notifier).submitWithdrawal(_amountController.text);
                }
              },
              child: Text('Submit Withdrawal'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}