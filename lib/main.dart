import 'package:flutter/material.dart';
import "screens/HomeScreen.dart";
import 'screens/BottomNavBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/PersonalInfoScreen.dart';

void main() {
  runApp(
    // Wrap the entire app with ProviderScope
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginScreen(),
      // home: PersonalInfoScreen(),
      // home : LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}






