import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'PersonalInfoScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  double _totalUSDT = 0.0;
  double _totalINR = 0.0;
  double _conversionRate = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchConversionRate();
    _loadSavedValues(); // Load saved values from SharedPreferences
  }

  Future<void> _fetchProducts() async {
    final url = 'https://tl.brainyhub.in/api/get_products.php'; // Replace with your products API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _products = json.decode(response.body);
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load products.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'An error occurred: $error';
      });
    }
  }

  Future<void> _fetchConversionRate() async {
    final url = 'http://tl.brainyhub.in/api/get_inr_value.php?id=1'; // Replace with actual domain or IP

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('inr_value')) {
          setState(() {
            _conversionRate = double.tryParse(data['inr_value']) ?? 0.0;
          });
          await _calculateTotalINR(); // Update total INR after fetching conversion rate
        } else {
          print('Error from API: ${data['error']}');
        }
      } else {
        print('Failed to load conversion rate.');
      }
    } catch (error) {
      print('Error fetching conversion rate: $error');
    }
  }

  Future<void> _calculateTotalINR() async {
    final prefs = await SharedPreferences.getInstance();
    double usdtBalance = double.tryParse(prefs.getString('balance') ?? '0.0') ?? 0.0;

    double totalINR = usdtBalance * _conversionRate;

    setState(() {
      _totalUSDT = usdtBalance;
      _totalINR = totalINR;
      _isLoading = false;
    });

    // Save the calculated values to SharedPreferences
    await prefs.setDouble('totalUSDT', _totalUSDT);
    await prefs.setDouble('totalINR', _totalINR);
  }

  Future<void> _loadSavedValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalUSDT = prefs.getDouble('totalUSDT') ?? 0.0;
      _totalINR = prefs.getDouble('totalINR') ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  SizedBox(height: 16),
                  _buildTransactionCard(),
                  SizedBox(height: 16),
                  _buildTeamProfitCard(),
                  SizedBox(height: 16),
                  _buildTodayPrice(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _buildProductList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Home', style: TextStyle(color: Colors.white)),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.indigo],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.language),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonalInfoScreen()),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.yellow,
            child: Icon(Icons.person, color: Colors.black),
          ),
        ),
        SizedBox(width: 16),
        Text(
          'Welcome, User',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTransactionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[800]!, Colors.blue[600]!],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.currency_exchange, color: Colors.white),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Deposit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildTransactionInfo('Total USDT Balance', '$_totalUSDT USDT'),
              SizedBox(height: 8),
              _buildTransactionInfo('Total Value (INR)', '${_totalINR.toStringAsFixed(2)} INR'),
              Text(
                '≈ ${_totalINR.toStringAsFixed(2)} INR',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70)),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTeamProfitCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[800]!, Colors.purple[600]!],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team Profit',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProfitInfo('Today (USDT)', '0.0000'),
                  _buildProfitInfo('Total (USDT)', '0.0000'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfitInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70)),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTodayPrice() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Today Price: ${_conversionRate.toStringAsFixed(2)} INR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {},
              child: Text('Exchange'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    if (_isLoading) {
      return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_errorMessage.isNotEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red))),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final product = _products[index];
            return _buildPriceItem(
              product['product_name'],
              product['price_usdt'],
              '+1.68%', // Placeholder for actual change value
              product['price_inr'],
            );
          },
          childCount: _products.length,
        ),
      );
    }
  }

  Widget _buildPriceItem(String title, String price, String change, String inr) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: inr.isNotEmpty ? Text('≈ $inr INR', style: TextStyle(color: Colors.grey)) : null,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$$price', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              change,
              style: TextStyle(
                color: change.startsWith('+') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
