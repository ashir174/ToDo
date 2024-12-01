import 'package:androidstudioprojects/MyHomePage.dart';
import 'package:flutter/material.dart';

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
        primaryColor: const Color.fromARGB(255, 211, 159, 108), // Primary color
        colorScheme: ColorScheme.fromSeed(
            seedColor:
                const Color.fromARGB(255, 211, 159, 108)), // New colorScheme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 211, 159, 108), // FAB color
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(
              255, 240, 240, 240), // Subtle grey color for the AppBar
          elevation: 1, // Optional: adds a subtle shadow
          titleTextStyle: TextStyle(
            color: Colors.black, // Set AppBar title text color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.black, // Set AppBar icon color (like the back button)
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Color.fromARGB(255, 211, 159, 108), // Active tab color
          unselectedLabelColor:
              Color.fromARGB(255, 207, 207, 207), // Unselected tab color
          indicatorColor:
              Color.fromARGB(255, 211, 159, 108), // Tab indicator color
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.black87, // AppBar title color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.black, // Body text color
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(
        title: "Dashboard",
      ),
    );
  }
}
