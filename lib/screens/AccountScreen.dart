import 'package:flutter/material.dart';
import 'DepositScreen.dart';
import 'WithdrawalScreen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildMenuItems(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('My Account', style: TextStyle(color: Colors.white)),
        background: Image.asset(
          'assets/account_background.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, John!',
            // style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 8),
          Text(
            'What would you like to do today?',
            // style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      {'icon': Icons.person, 'title': 'Personal', 'color': Colors.blue},
      {'icon': Icons.group, 'title': 'Team', 'color': Colors.green},
      {'icon': Icons.attach_money, 'title': 'USDT Withdrawal', 'color': Colors.orange, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawalScreen()))},
      {'icon': Icons.account_balance_wallet, 'title': 'Deposit', 'color': Colors.purple, 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => DepositScreen()))},
      {'icon': Icons.receipt, 'title': 'Bill', 'color': Colors.red},
      {'icon': Icons.help, 'title': 'Help', 'color': Colors.teal},
    ];

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final item = menuItems[index];
          return _buildMenuItem(
            item['icon'] as IconData,
            item['title'] as String,
            item['color'] as Color,
            onTap: item['onTap'] as VoidCallback?,
          );
        },
        childCount: menuItems.length,
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color, {VoidCallback? onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}