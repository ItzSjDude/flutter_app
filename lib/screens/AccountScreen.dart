import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DepositScreen.dart';
import 'WithdrawalScreen.dart';

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

  Future<void> _launchTelegram() async {
    const telegramUrl = 'https://t.me/novaxlink'; // Replace with your actual Telegram group URL
    final Uri uri = Uri.parse(telegramUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $telegramUrl';
      }
    } catch (e) {
      // Handle the exception and provide feedback to the user
      print(e); // Replace this with a more user-friendly message if needed
    }
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
          _buildCopyRow(phoneNumber),
          _buildCopyRow('Invitation code: $invitationCode'),
        ],
      ),
    );
  }

  Widget _buildCopyRow(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20))),
        IconButton(
          icon: Icon(Icons.copy, color: Colors.white),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Copied to clipboard')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBalanceCards(String usdtBalance, String inrBalance) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: _buildBalanceCard('Balance (USDT)', usdtBalance, Colors.orange)),
          SizedBox(width: 16),
          Expanded(child: _buildBalanceCard('≈ INR', inrBalance, Colors.green)),
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
      {'icon': Icons.person, 'title': 'Personal', 'color': Colors.blue, 'screen': null},
      {'icon': Icons.group, 'title': 'Team', 'color': Colors.green, 'screen': null},
      {'icon': Icons.attach_money, 'title': 'USDT Withdrawal', 'color': Colors.orange, 'screen': WithdrawalScreen()},
      {'icon': Icons.account_balance_wallet, 'title': 'Deposit', 'color': Colors.purple, 'screen': DepositScreen()},
      {'icon': Icons.receipt, 'title': 'Bill', 'color': Colors.red, 'screen': null},
      {'icon': Icons.telegram, 'title': 'Telegram Support', 'color': Colors.blue, 'screen': null},
    ];

    return Column(
      children: menuItems.map((item) {
        return _buildMenuItem(
          item['icon'] as IconData,
          item['title'] as String,
          item['color'] as Color,
          item['screen'] != null
              ? () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item['screen'] as Widget),
          )
              : item['title'] == 'Telegram Support' ? () => _launchTelegram() : null,
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color, [VoidCallback? onTap]) {
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
        onTap: onTap,
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
          Text('Invite link: https://tl.brainyhub.in/invite?code=$invitationCode', style: TextStyle(color: Colors.white70)),
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
              foregroundColor: primaryColor, backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
