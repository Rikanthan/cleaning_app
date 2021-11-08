import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({ Key? key }) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File ?_imageFile = null;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile!.path);
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
                      customMetadata: {'picked-file-path':fileName});

    firebase_storage.UploadTask uploadTask;
    uploadTask = reference.putFile(io.File(_imageFile!.path),metadata);
    firebase_storage.UploadTask task = await Future.value(uploadTask);
    Future.value(uploadTask).then((value) => {
      print("upload file path ${value.ref.fullPath}")
    }).onError((error, stackTrace) => {
      print("upload file path error ${error.toString()}")
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
                    colors: [Colors.orange,Colors.green],
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
                              : FlatButton(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.blue,
                              size: 50,
                            ),
                            onPressed: pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                uploadImageButton(context),
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
                  colors: [Colors.orange, Colors.green],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: TextButton(
              onPressed: () => uploadImageToDatabase(context),
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