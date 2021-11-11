import 'dart:io' as io;
import 'dart:io';
import 'package:cleaning/Screens/ShowImages.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

enum UploadStatus{
  notStarted, inprogress, finished
}

class ImageUpload extends StatefulWidget {
  const ImageUpload({ Key? key }) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File ?_imageFile = null;
  String uploadText = "Uploading...";
  final picker = ImagePicker();
  UploadStatus _uploadStatus = UploadStatus.notStarted;
  double progress = 0.0;
  String date = DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now());
  late firebase_storage.UploadTask _uploadTask;
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      try{
        _imageFile = File(pickedFile!.path);
      }
      catch(e)
      {
        print(e);
      }
    });
  }

  Future uploadImageToDatabase(BuildContext context) async {
    String fileName = basename(_imageFile!.path);
    firebase_storage.Reference reference = 
          firebase_storage.FirebaseStorage.instance
          .ref().child('uploads').child('/$fileName');

    final metadata = firebase_storage
                    .SettableMetadata(
                      contentType: 'image/jpeg',
                      customMetadata: {'picked-file-path':fileName,
                                        'upload_time': date});
  
    _uploadTask = reference.putFile(io.File(_imageFile!.path),metadata);
    firebase_storage.UploadTask task = await Future.value(_uploadTask);
    Future.value(_uploadTask).then((value) => {
      print("upload file path ${value.ref.fullPath}")
    }).onError((error, stackTrace) => {
      print("upload file path error ${error.toString()}")
    });
    task.snapshotEvents.listen((event) {
      setState(() {
        progress = ((event.bytesTransferred.toDouble()/
                      event.totalBytes.toDouble())*100)
                      .roundToDouble();
      });
    });
    task.whenComplete((){
      uploadText = "Upload success!";
      _uploadStatus = UploadStatus.finished;
      Navigator.push(
        context, MaterialPageRoute(builder: (_)=> ShowImages()));
    });
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
                    colors: [Colors.black,Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                    ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Uploading Image to Firebase Storage",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontStyle: FontStyle.italic),
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
                              :Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                      child: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.blue,
                                            size: 50,
                                      ),
                                      onPressed: () async{                         
                                          final pickedFile = await picker.pickImage(source: ImageSource.camera);
                                          setState(() {
                                            try{
                                              _imageFile = File(pickedFile!.path);
                                            }
                                            catch(e)
                                            {
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
                                      onPressed: () async{                         
                                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                          setState(() {
                                            try{
                                              _imageFile = File(pickedFile!.path);
                                            }
                                            catch(e)
                                            {
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
                if( _uploadStatus == UploadStatus.notStarted)
                uploadImageButton(context),
                if(_uploadStatus != UploadStatus.notStarted)
                Padding(
                  padding: const EdgeInsets.only(bottom:20.0),
                  child: Text(uploadText),
                ),
                if(_uploadStatus == UploadStatus.inprogress )
                  CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 5.0,
                  percent: progress/100,
                  center: new Text("$progress%"),
                  linearGradient: LinearGradient(
                    colors: [Colors.black,Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                )
              ],
            ),
          ),
        ],
      ),
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
              onPressed: (){
                uploadImageToDatabase(context);
                setState(() {
                  _uploadStatus = UploadStatus.inprogress;
                });   
              } ,
              child: Text(
                "Upload Image",
                style: TextStyle(fontSize: 20,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}