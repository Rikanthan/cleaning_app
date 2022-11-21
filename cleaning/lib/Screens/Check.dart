import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, GridFS;
import 'package:percent_indicator/percent_indicator.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
  
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  
  final url = [
      "mongodb://admin:admin123@cluster0-shard-00-00.zn07v.mongodb.net:27017/cleaning_db?ssl=true&replicaSet=<MySet>&authSource=admin&retryWrites=true&w=majority",
      "mongodb://admin:admin123@cluster0-shard-00-01.zn07v.mongodb.net:27017/cleaning_db?ssl=true&replicaSet=<MySet>&authSource=admin&retryWrites=true&w=majority",
      "mongodb://admin:admin123@cluster0-shard-00-02.zn07v.mongodb.net:27017/cleaning_db?ssl=true&replicaSet=<MySet>&authSource=admin&retryWrites=true&w=majority"
  ];
  
  final picker = ImagePicker();
  late MemoryImage _image;
  File ?_imageFile = null;
   GridFS? bucket;
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;
 // late ImageProvider provider ;
  var flag = false;
    
  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );
    _colorTween = _animationController.drive(
      ColorTween(
        begin: Colors.green, 
        end: Colors.deepOrange)
        );
    _animationController.repeat();
    super.initState();
    connection();
  }
  
  Future getImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
     
      var _cmpressed_image;
      try {
        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile.path,
            format: CompressFormat.heic,
            quality: 70
        );
      } catch (e) {
  
        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile.path,
            format: CompressFormat.jpeg,
            quality: 70
        );
      }
      setState(() {
        flag = true;
         _imageFile = File(pickedFile.path);
      });
  
      Map<String,dynamic> image = {
        "_id" : pickedFile.path.split("/").last,
        "data": base64Encode(_cmpressed_image)
      };
      try{
        var res = await bucket!.chunks.insert(image);
      }
      catch(e)
      {
        print(e);
      }
      try
      {
            var img = await bucket!.chunks.findOne({
            "_id": pickedFile.path.split("/").last
          });
            setState(() {
            _image = MemoryImage(base64Decode(img!["data"]));
            flag = false;
          });
      }
      catch(e)
      {
        print(e);
      }
      
    }
  }
    
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child:  Column(
            children: [
              SizedBox(
                height: 20,
              ),
              _imageFile == null ? CircularProgressIndicator() :
               Image.file(_imageFile!),
              SizedBox(height: 10,),
              if(flag==true)
                CircularProgressIndicator(valueColor: _colorTween),
              SizedBox(height: 20,),
              TextButton(
                onPressed: getImage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.green,
                        Colors.white,
                        Colors.green,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                      'Select Image',
                      style: TextStyle(fontSize: 20)
                  ),
                ),
  
              ),
            ],
          ),
        )
      )
  
    );
  }
  
  Future connection () async{
    try{
      Db _db = new Db.pool(url);
    await _db.open(secure: true);
    print(_db.databaseName);
    bucket = GridFS(_db,"image");
    }
    catch(e)
    {
      print(e);
    }
  }
}