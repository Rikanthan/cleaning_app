import 'dart:io';

import 'package:cleaning/Screens/Check.dart';
import 'package:cleaning/Screens/ImageUpload.dart';
//import 'package:cleaning/Screens/ImageUpload.txt';
import 'package:cleaning/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'server.dart' as server;
 
void main(List<String> arguments){
  // WidgetsFlutterBinding.ensureInitialized();
  // await firebase_core.Firebase.initializeApp();
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
      home: ImageUpload()
    );
  }
}
