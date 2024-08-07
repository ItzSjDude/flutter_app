import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatelessWidget {
  PersonalInfoScreen ({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Text('Personal information'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.yellow,
            child: Icon(Icons.person, size: 50, color: Colors.black),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              '91967968654153',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          InfoListTile(title: 'User ID', value: '3120'),
          InfoListTile(title: 'Phone Number', value: '9165864153'),
          InfoListTile(title: 'Telegram Number'),
          InfoListTile(title: 'Withdrawals password'),
          InfoListTile(title: 'Recharge History'),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              child: Text('Log out', style: TextStyle(color: Colors.red)),
              onPressed: ()  {},
            ),
          ),
        ],
      ),
    );
  }
}

class InfoListTile extends StatelessWidget {
  final String title;
  final String? value;

  InfoListTile({required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) Text(value!, style: TextStyle(color: Colors.grey)),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }

}