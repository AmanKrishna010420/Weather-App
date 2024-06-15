import 'package:flutter/material.dart';
import 'package:weather_app/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: const  WeatherApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
    );  
  }
  }