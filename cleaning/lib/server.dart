import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void start() async {
   HttpOverrides.global = MyHttpOverrides();
   try
   {
     final db = await Db.create("mongodb+srv://admin:admin123@cluster0.zn07v.mongodb.net/cleaning_db?retryWrites=true&w=majority");
  await db.open();
  print(db.databaseName);
   }
   catch(e)
   {
     print(e);
   }
  
}