import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _expenditureRecords = [];
  List<dynamic> _incomeRecords = [];
  bool _isLoadingExpenditure = true;
  bool _isLoadingIncome = true;
  String? _errorMessageExpenditure; // Separate error messages
  String? _errorMessageIncome;
  late int _userId; // To store the user ID

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs: expenditure and income
    _loadUserId(); // Load the user ID when the screen initializes
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('userId');
    print('Retrieved userIdString: $userIdString'); // Debug

    final userId = int.tryParse(userIdString ?? '0');
    print('Parsed userId: $userId'); // Debug

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      // Fetch records once the user ID is loaded
      _fetchExpenditureRecords();
      _fetchIncomeRecords();
    } else {
      setState(() {
        _isLoadingExpenditure = false;
        _isLoadingIncome = false;
        _errorMessageExpenditure = 'User ID not found or invalid.';
        _errorMessageIncome = 'User ID not found or invalid.';
      });
    }
  }

  Future<void> _fetchExpenditureRecords() async {
    final url = Uri.parse('https://tl.brainyhub.in/api/fetch_transactions.php?user_id=$_userId'); // Use the user ID from shared prefs

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final transactions = data['data'];
          setState(() {
            _expenditureRecords = transactions; // Assuming all transactions are expenditure records
            _isLoadingExpenditure = false;
          });
        } else {
          setState(() {
            _isLoadingExpenditure = false;
            _errorMessageExpenditure = 'Error fetching expenditure records.';
          });
        }
      } else {
        setState(() {
          _isLoadingExpenditure = false;
          _errorMessageExpenditure = 'Failed to connect to the server.';
        });
      }
    } catch (error) {
      setState(() {
        _isLoadingExpenditure = false;
        _errorMessageExpenditure = 'An error occurred: $error';
      });
    }
  }

  Future<void> _fetchIncomeRecords() async {
    final url = Uri.parse('https://tl.brainyhub.in/api/fetch_income.php?user_id=$_userId'); // Use the user ID from shared prefs

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final transactions = data['data'];
          setState(() {
            _incomeRecords = transactions; // Assuming all transactions are income records
            _isLoadingIncome = false;
          });
        } else {
          setState(() {
            _isLoadingIncome = false;
            _errorMessageIncome = 'Error fetching income records.';
          });
        }
      } else {
        setState(() {
          _isLoadingIncome = false;
          _errorMessageIncome = 'Failed to connect to the server.';
        });
      }
    } catch (error) {
      setState(() {
        _isLoadingIncome = false;
        _errorMessageIncome = 'An error occurred: $error';
      });
    }
  }

  Widget _buildExpenditureTab() {
    if (_isLoadingExpenditure) {
      return Center(child: CircularProgressIndicator());
    } else if (_errorMessageExpenditure != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(_errorMessageExpenditure!, style: TextStyle(color: Colors.red, fontSize: 18)),
          ],
        ),
      );
    } else if (_expenditureRecords.isEmpty) {
      return _buildEmptyDataView();
    } else {
      return ListView.builder(
        itemCount: _expenditureRecords.length,
        itemBuilder: (context, index) {
          final record = _expenditureRecords[index];
          return ListTile(
            contentPadding: EdgeInsets.all(16.0),
            title: Text('Transaction ID: ${record['transaction_id']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text('Status: ${record['status']}', style: TextStyle(fontSize: 14, color: Colors.grey)),
            tileColor: Colors.grey[200],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          );
        },
      );
    }
  }

  Widget _buildIncomeTab() {
    if (_isLoadingIncome) {
      return Center(child: CircularProgressIndicator());
    } else if (_errorMessageIncome != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(_errorMessageIncome!, style: TextStyle(color: Colors.red, fontSize: 18)),
          ],
        ),
      );
    } else if (_incomeRecords.isEmpty) {
      return _buildEmptyDataView();
    } else {
      return ListView.builder(
        itemCount: _incomeRecords.length,
        itemBuilder: (context, index) {
          final record = _incomeRecords[index];
          return ListTile(
            contentPadding: EdgeInsets.all(16.0),
            title: Text('Transaction ID: ${record['transaction_id']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text('Status: ${record['status']}', style: TextStyle(fontSize: 14, color: Colors.grey)),
            tileColor: Colors.grey[200],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records', style: TextStyle(fontSize: 20)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Expenditure Records"),
            Tab(text: "Income Records"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExpenditureTab(),
          _buildIncomeTab(),
        ],
      ),
    );
  }

  Widget _buildEmptyDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, size: 64, color: Colors.brown),
          SizedBox(height: 16),
          Text("No records found", style: TextStyle(color: Colors.grey, fontSize: 18)),
        ],
      ),
    );
  }
}
