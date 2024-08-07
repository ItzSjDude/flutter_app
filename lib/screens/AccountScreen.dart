import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen ({Key ? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAccountInfo(),
            _buildBalanceCards(),
            _buildMenuItems(),
            _buildInvitationSection(),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildAccountInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.yellow,
            child: Icon(Icons.person, size: 50, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text('Account', style: TextStyle(color: Colors.black, fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('919616775153', style: TextStyle(color: Colors.black, fontSize: 20)),
              IconButton(icon: Icon(Icons.copy, color: Colors.black), onPressed: () {}),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Invitation code', style: TextStyle(color: Colors.black)),
              SizedBox(width: 8),
              Text('969262', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              IconButton(icon: Icon(Icons.copy, color: Colors.black), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCards() {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.only(left: 16, right: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Balance(USDT)'),
                  Text('0.0000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            margin: EdgeInsets.only(left: 8, right: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('≈ INR'),
                  Text('0.00', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {'icon': Icons.person, 'title': 'Personal'},
      {'icon': Icons.group, 'title': 'Team'},
      {'icon': Icons.attach_money, 'title': 'USDT Withdrawal'},
      {'icon': Icons.account_balance_wallet, 'title': 'Deposit'},
      {'icon': Icons.receipt, 'title': 'Bill'},
      {'icon': Icons.help, 'title': 'Help'},
    ];

    return Column(
      children: menuItems.map((item) => _buildMenuItem(item['icon'] as IconData, item['title'] as String)).toList(),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildInvitationSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Invitation code:', style: TextStyle(color: Colors.white70)),
              Text('969262', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text('Invite link: https://www.pickwallet.../invate?code=969262',
              style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          ElevatedButton(
            child: Text('Copy'),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green, backgroundColor: Colors.grey[200],
              minimumSize: Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBottomNavBar() {
  //   return BottomNavigationBar(
  //     items: [
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  //       BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'USDT'),
  //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mine'),
  //     ],
  //     currentIndex: 2,
  //     selectedItemColor: Colors.blue,
  //   );
  // }
}