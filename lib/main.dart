import 'package:flutter/material.dart';
import 'package:inventory/screens/item_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light, // Light theme settings
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // Light theme app bar color
          foregroundColor: Colors.white, // Light theme app bar text color
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue, // Light theme FAB color
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue, // Light theme button color
            backgroundColor:
                Colors.transparent, // Set a background color if needed
          ),
        ),
        // Add other theme customizations as needed
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark, // Dark theme settings
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey, // Dark theme app bar color
          foregroundColor: Colors.white, // Dark theme app bar text color
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey, // Dark theme FAB color
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueGrey, // Dark theme button color
            backgroundColor:
                Colors.transparent, // Set a background color if needed
          ),
        ),
        // Add other theme customizations as needed
      ),
      themeMode: ThemeMode.system, // Automatically switch themes
      home: const ItemList(),
    );
  }
}
