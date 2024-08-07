import 'package:flutter/material.dart';
import '../constants.dart';

class BottomNavBar extends StatefulWidget{
    const BottomNavBar({Key? key}) : super(key: key);

    @override
    State<BottomNavBar> createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar>{
    int pageIdx = 0;

     @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap:(idx){
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[800],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        currentIndex: pageIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'USDT',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mine',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}

