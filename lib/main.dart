import 'package:flutter/material.dart';
import 'package:toons/screens/Home_today.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeToday(),
    );
  }
}

