import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:cleaning/Widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, GridFS;
import 'package:path/path.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum UploadStatus { notStarted, inprogress, finished }

enum ImageUploadType { gallery, camera, none }

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final url = [
    "mongodb://admin:admin123@cluster0-shard-00-00.zn07v.mongodb.net:27017/cleaning_db?ssl=true&replicaSet=<MySet>&authSource=admin&retryWrites=true&w=majority",
    "mongodb://admin:admin123@cluster0-shard-00-01.zn07v.mongodb.net:27017/cleaning_db?ssl=true&replicaSet=<MySet>&authSource=admin&retryWrites=true&w=majority",
    "mongodb://admin:admin123@cluster0-shard-00-02.zn07v.mongodb.net:27017/cleaning_db?ssl=true&replicaSet=<MySet>&authSource=admin&retryWrites=true&w=majority"
  ];
  File? _imageFile = null;
  late MemoryImage _image;
  ImageUploadType _imageUploadType = ImageUploadType.none;
  GridFS? bucket;
  XFile? pickedFile;
  var flag = false;
  String uploadText = "Uploading...";
  final picker = ImagePicker();
  UploadStatus _uploadStatus = UploadStatus.notStarted;
  double progress = 0.0;
  String date = DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    connection();
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      try {
        _imageFile = File(pickedFile!.path);
      } catch (e) {
        print(e);
      }
    });
  }

  Future connection() async {
    try {
      Db _db = new Db.pool(url);
      await _db.open(secure: true);
      print(_db.databaseName);

      bucket = GridFS(_db, "image");
    } catch (e) {
      print(e);
    }
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile!.path);
    Reference reference =
        FirebaseStorage.instance.ref().child('uploads').child('/$fileName');

    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});

    UploadTask uploadTask;
    uploadTask = reference.putFile(io.File(_imageFile!.path), metadata);
    UploadTask task = await Future.value(uploadTask);
    Future.value(uploadTask)
        .then((value) => {print("upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("upload file path error ${error.toString()}")})
        .whenComplete(() {
      setState(() {
        uploadText = "Upload success!";
        _uploadStatus = UploadStatus.finished;
      });
    });
  }

  Future uploadImageToDatabase(BuildContext context) async {
    if (pickedFile != null) {
      var _cmpressed_image;
      try {
        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile!.path,
            format: CompressFormat.heic,
            quality: 70);
      } catch (e) {
        _cmpressed_image = await FlutterImageCompress.compressWithFile(
            pickedFile!.path,
            format: CompressFormat.jpeg,
            quality: 70);
      }
      setState(() {
        flag = true;
        _imageFile = File(pickedFile!.path);
      });

      Map<String, dynamic> image = {
        "_id": pickedFile!.path.split("/").last,
        "data": base64Encode(_cmpressed_image),
        "created_at": date
      };
      try {
        Db _db = new Db.pool(url);
        await _db.open(secure: true);
        GridFS bucket = GridFS(_db, "image");
        var res = await bucket.chunks.insert(image).whenComplete(() {
          setState(() {
            uploadText = "Upload success!";
            _uploadStatus = UploadStatus.finished;
          });
        });
      } catch (e) {
        print(e);
      }

      //   try
      //   {
      //      Db _db = new Db.pool(url);
      // await _db.open(secure: true);
      //     GridFS bucket = GridFS(_db,"image");
      //         var img = await bucket.chunks.findOne({
      //         "_id": pickedFile!.path.split("/").last
      //       });
      //         setState(() {
      //         _image = MemoryImage(base64Decode(img!["data"]));
      //         flag = false;
      //       });
      //   }
      //   catch(e)
      //   {
      //     print(e);
      //   }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(250.0),
                    bottomRight: Radius.circular(10.0)),
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Upload Image",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Lato'),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _imageFile != null
                              ? Image.file(_imageFile!)
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.blue,
                                        size: 50,
                                      ),
                                      onPressed: () async {
                                        final pickFile = await picker.pickImage(
                                            source: ImageSource.camera);
                                        setState(() {
                                          try {
                                            pickedFile = pickFile;
                                            _imageFile = File(pickedFile!.path);
                                          } catch (e) {
                                            print(e);
                                          }
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Icon(
                                        Icons.add_photo_alternate,
                                        color: Colors.blue,
                                        size: 50,
                                      ),
                                      onPressed: () async {
                                        final pickFile = await picker.pickImage(
                                            source: ImageSource.gallery);
                                        setState(() {
                                          try {
                                            pickedFile = pickFile;
                                            _imageFile = File(pickedFile!.path);
                                          } catch (e) {
                                            print(e);
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_uploadStatus == UploadStatus.notStarted)
                  uploadImageButton(context),
                if (_uploadStatus != UploadStatus.notStarted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(uploadText),
                  ),
                if (_uploadStatus == UploadStatus.inprogress)
                  SpinKitCircle(color: Colors.blue, size: 50.0)
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: TextButton(
              onPressed: () {
                uploadImageToFirebase(context);
                //uploadImageToDatabase(context);
                setState(() {
                  _uploadStatus = UploadStatus.inprogress;
                });
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_)=>
                //       ShowImages()
                //       )
                //     );
              },
              child: Text(
                "Upload Image",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
