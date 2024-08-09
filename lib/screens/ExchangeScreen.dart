import 'package:flutter/material.dart';
import 'DetailScreen.dart';

// class ExchangeScreen extends StatelessWidget {
//   ExchangeScreen ({Key? key}) : super(key:key);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: SingleChildScrollView(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _buildDetailExchangeRow(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDetailExchangeRow() {
  //   return Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(1.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               Column(
  //                 children: [
  //                   Text('0', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
  //                   SizedBox(height: 10),
  //                   Text('Exchange amount today',style: TextStyle(fontSize:12,color:Colors.grey)),
  //                   SizedBox(height: 8),
  //                   ElevatedButton(onPressed: () {}, child: Text('Detail',style: TextStyle(color: Colors.green))),
  //                 ],
  //               ),
  //               Container(
  //               width: 1, 
  //               height: 100, 
  //               color: Colors.grey, 
  //               margin: EdgeInsets.symmetric(horizontal: 2), 
  //             ),
  //               Column(
  //                 children: [
  //                   Text('0', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
  //                   SizedBox(height: 10),
  //                   Text('Quantity completed',style: TextStyle(fontSize:12,color:Colors.grey)),
  //                   SizedBox(height: 8),
  //                   ElevatedButton(onPressed: () {}, child: Text('Exchange',style: TextStyle(color: Colors.green))),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //   );
  // }
       
class ExchangeScreen extends StatefulWidget {
  @override
  _ExchangeScreenState createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : _buildAppBar(),
      body: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoCard("Exchange amount today", "0"),
              _buildInfoCard("Quantity completed", "0"),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailScreen()),
                      );
                },
                child: Text('Detail',style: TextStyle(color: Colors.green))),
              ElevatedButton(
                onPressed: () {},
                child: Text('Exchange',style: TextStyle(color: Colors.green))),
            ],
          ),
          SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Hall"),
              Tab(text: "Record"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmptyDataView(),
                _buildEmptyDataView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildEmptyDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, size: 64, color: Colors.brown),
          SizedBox(height: 16),
          Text("Empty data", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}