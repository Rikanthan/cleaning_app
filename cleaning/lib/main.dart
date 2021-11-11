import 'package:cleaning/Screens/ImageUpload.dart';
import 'package:cleaning/Screens/Login.dart';
import 'package:cleaning/Screens/ShowImages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cleaning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login()
    );
  }
}
