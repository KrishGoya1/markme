import 'package:flutter/material.dart';
import 'scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Scanner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NFCScanner(),
    );
  }
}
