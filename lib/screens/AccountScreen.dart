import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final Color primaryColor = Color(0xFF6200EE);
  final Color accentColor = Color(0xFF03DAC6);
  final Color backgroundColor = Color(0xFFF3E5F5);

  Future<Map<String, String>> _loadAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    double usdt = prefs.getDouble('totalUSDT') ?? 0.0;
    double inr = prefs.getDouble('totalINR') ?? 0.0;
    String phoneNumber = prefs.getString('phone') ?? 'N/A';
    String invitationCode = prefs.getString('referralCode') ?? 'N/A';
    return {
      'usdt': usdt.toStringAsFixed(4),
      'inr': inr.toStringAsFixed(2),
      'phoneNumber': phoneNumber,
      'invitationCode': invitationCode,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: FutureBuilder<Map<String, String>>(
        future: _loadAccountData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final accountData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildAccountInfo(accountData['phoneNumber']!, accountData['invitationCode']!),
                  _buildBalanceCards(accountData['usdt']!, accountData['inr']!),
                  _buildMenuItems(),
                  _buildInvitationSection(accountData['invitationCode']!),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: Text('My Account', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildAccountInfo(String phoneNumber, String invitationCode) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 60, color: primaryColor),
          ),
          SizedBox(height: 16),
          Text('Account', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(phoneNumber, style: TextStyle(color: Colors.white, fontSize: 20)),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.white),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: phoneNumber));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Phone number copied to clipboard')),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Invitation code', style: TextStyle(color: Colors.white70)),
              SizedBox(width: 8),
              Text(invitationCode, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.white),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: invitationCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invitation code copied to clipboard')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCards(String usdtBalance, String inrBalance) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildBalanceCard('Balance (USDT)', usdtBalance, Colors.orange),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildBalanceCard('≈ INR', inrBalance, Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, String amount, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 8),
            Text(amount, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {'icon': Icons.person, 'title': 'Personal', 'color': Colors.blue},
      {'icon': Icons.group, 'title': 'Team', 'color': Colors.green},
      {'icon': Icons.attach_money, 'title': 'USDT Withdrawal', 'color': Colors.orange},
      {'icon': Icons.account_balance_wallet, 'title': 'Deposit', 'color': Colors.purple},
      {'icon': Icons.receipt, 'title': 'Bill', 'color': Colors.red},
      {'icon': Icons.help, 'title': 'Help', 'color': Colors.teal},
    ];

    return Column(
      children: menuItems.map((item) => _buildMenuItem(item['icon'] as IconData, item['title'] as String, item['color'] as Color)).toList(),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.chevron_right, color: color),
      ),
    );
  }

  Widget _buildInvitationSection(String invitationCode) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor, primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Invite Friends', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Invitation code:', style: TextStyle(color: Colors.white70)),
              Text(invitationCode, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text('Invite link: https://tl.brainyhub.in/invite?code=$invitationCode',
              style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.copy, color: primaryColor),
            label: Text('Copy Invitation Link', style: TextStyle(color: primaryColor)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: 'https://tl.brainyhub.in/invite?code=$invitationCode'));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invitation link copied to clipboard')),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: primaryColor,
              backgroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ],
      ),
    );
  }
}
