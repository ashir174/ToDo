import 'package:flutter/material.dart';
import 'MyHomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFF0F0F0), // Light grey for primary color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF0F0F0),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor:
              Color.fromARGB(255, 219, 163, 123), // Light orange for FAB
          splashColor: Color(0xFFFFE0B2), // Soft glow effect on interaction
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF0F0F0), // Light grey for AppBar
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 0, 0, 0), // Orange icons in AppBar
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black, // Black for active tab text
          unselectedLabelColor: Colors.grey, // Grey for inactive tab text
          indicatorColor: Color.fromARGB(
              255, 185, 117, 97), // Orange for active tab underline
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 185, 117, 97), // Light skin for icons
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: "Dashboard"),
    );
  }
}
