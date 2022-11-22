import 'dart:io';

import 'package:cleaning/Screens/Check.dart';
import 'package:cleaning/Screens/ImageUpload.dart';
//import 'package:cleaning/Screens/ImageUpload.txt';
import 'package:cleaning/Screens/Login.dart';
import 'package:cleaning/Screens/Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'server.dart' as server;
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  server.start();
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
      home: Login(key: key,)
    );
  }
}
