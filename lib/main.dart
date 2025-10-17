import 'package:flutter/material.dart';
import 'package:ticketing_flutter/public/home.dart';
import 'package:ticketing_flutter/public/bundle.dart';
import 'package:ticketing_flutter/public/about.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}
