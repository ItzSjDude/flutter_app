import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'DetailScreen.dart';

class ExchangeScreen extends StatefulWidget {
  @override
  _ExchangeScreenState createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _completedRecords = [];
  bool _isLoadingRecords = true;
  String? _errorMessage;
  late int _userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserId();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('userId');
    final userId = int.tryParse(userIdString ?? '0');

    if (userId != null && userId > 0) {
      setState(() {
        _userId = userId;
      });
      _fetchCompletedRecords();
    } else {
      setState(() {
        _isLoadingRecords = false;
        _errorMessage = 'User ID not found or invalid.';
      });
    }
  }

  Future<void> _fetchCompletedRecords() async {
    final url = Uri.parse('https://tl.brainyhub.in/api/fetch_transactions.php?user_id=$_userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          final transactions = data['data'];
          setState(() {
            _completedRecords = transactions.where((t) => t['status'] == 'completed').toList();
            _isLoadingRecords = false;
          });
        } else {
          setState(() {
            _isLoadingRecords = false;
            _errorMessage = 'Error fetching records.';
          });
        }
      } else {
        setState(() {
          _isLoadingRecords = false;
          _errorMessage = 'Failed to connect to the server.';
        });
      }
    } catch (error) {
      setState(() {
        _isLoadingRecords = false;
        _errorMessage = 'An error occurred: $error';
      });
    }
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoCard("Exchange Amount Today", "0", Colors.blueAccent),
          _buildInfoCard("Quantity Completed", "0", Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Container(
      width: 120, // Fixed width for smaller cards
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0), // Consistent padding
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 6),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRoundedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailScreen()),
              );
            },
            color: Colors.blueAccent,
            text: 'Detail',
          ),
          _buildRoundedButton(
            onPressed: () {},
            color: Colors.greenAccent,
            text: 'Exchange',
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedButton({
    required VoidCallback onPressed,
    required Color color,
    required String text,
  }) {
    return Container(
      width: 100, // Fixed width for buttons
      height: 40, // Fixed height for buttons
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          padding: EdgeInsets.all(0), // Remove additional padding
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(text: "Hall", icon: Icon(Icons.home, color: Colors.blueAccent)),
        Tab(text: "Record", icon: Icon(Icons.receipt, color: Colors.greenAccent)),
      ],
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blueAccent,
    );
  }

  Widget _buildEmptyDataView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info, size: 64, color: Colors.grey[600]),
          SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey[600], fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildCompletedRecordsTab() {
    if (_isLoadingRecords) {
      return Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(_errorMessage!, style: TextStyle(color: Colors.red, fontSize: 18)),
          ],
        ),
      );
    } else if (_completedRecords.isEmpty) {
      return _buildEmptyDataView("No completed records found");
    } else {
      return ListView.builder(
        itemCount: _completedRecords.length,
        itemBuilder: (context, index) {
          final record = _completedRecords[index];
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildInfoSection(),
          SizedBox(height: 20),
          _buildActionButtons(),
          SizedBox(height: 20),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmptyDataView("No Hall Data Available"),
                _buildCompletedRecordsTab(), // Show completed records in the Record tab
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Exchange Screen',
        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings, color: Colors.black),
          onPressed: () {
            // Add settings action here
          },
        ),
      ],
    );
  }
}
