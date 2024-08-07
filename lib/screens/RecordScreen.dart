import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  RecordScreen ({Key? key}) : super(key:key);

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
                _buildDetailExchangeRow(),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
       
   Widget _buildDetailExchangeRow() {
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('0', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Exchange amount today',style: TextStyle(fontSize:12,color:Colors.grey)),
                    SizedBox(height: 8),
                    ElevatedButton(onPressed: () {}, child: Text('Detail',style: TextStyle(color: Colors.green))),
                  ],
                ),
                Container(
                width: 1, 
                height: 100, 
                color: Colors.grey, 
                margin: EdgeInsets.symmetric(horizontal: 2), 
              ),
                Column(
                  children: [
                    Text('0', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Quantity completed',style: TextStyle(fontSize:12,color:Colors.grey)),
                    SizedBox(height: 8),
                    ElevatedButton(onPressed: () {}, child: Text('Exchange',style: TextStyle(color: Colors.green))),
                  ],
                ),
              ],
            ),
          ),
        ],
    );
   }

}