import 'package:flutter/material.dart';
import 'santri_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Santri',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SantriPage(),
    );
  }
}
