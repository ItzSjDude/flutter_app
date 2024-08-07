import 'package:flutter/material.dart';
import 'PersonalInfoScreen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen ({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                _buildPriceList(),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: ()  => PersonalInfoScreen(),
              child: CircleAvatar(
                backgroundColor: Colors.yellow,
                child: Icon(Icons.person, color: Colors.black),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
        Text(
          'Language',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTransactionCard() {
    return Card(
      color: Colors.blue[800],
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Total number of transactions',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '0 INR',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Total Value(USDT)',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '0.0000',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '≈ 0.00 INR',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamProfitCard() {
    return Card(
      color: Colors.blue[800],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Profit',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today(USDT)', style: TextStyle(color: Colors.white)),
                    Text('0.0000', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total(USDT)', style: TextStyle(color: Colors.white)),
                    Text('0.0000', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Today Price: 92.2 INR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ElevatedButton(
          onPressed: () {},
          child: Text('Exchange'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }

  Widget _buildPriceList() {
    return Column(
      children: [
        _buildPriceItem('WazirX Price', '6,240.00', '+1.68%', '90.9'),
        _buildPriceItem('Binance Price', '6,240.00', '+1.68%', '91.1'),
        _buildPriceItem('KuCoin Price', '6,240.00', '-1.68%', ''),
      ],
    );
  }

  Widget _buildPriceItem(String title, String price, String change, String inr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              if (inr.isNotEmpty) Text('≈ $inr INR', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$$price', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                change,
                style: TextStyle(
                  color: change.startsWith('+') ? Colors.green : Colors.red,
                ),
              ),
            ],
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
  //     currentIndex: 0,
  //     selectedItemColor: Colors.blue[800],
  //   );
  // }
}