import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class ShowImages extends StatefulWidget {
  const ShowImages({ Key? key }) : super(key: key);

  @override
  _ShowImagesState createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().child("uploads").list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "upload_time":fileMeta.customMetadata?['upload_time'] ?? ""
      });
    });
    return files;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
             Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot.data);
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                            snapshot.data![index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            dense: false,
                            leading: Image.network(
                              image['url'], 
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context, 
                              Widget child,
                              ImageChunkEvent? loadingProgress){
                                if(loadingProgress == null)
                                return child;
                                return SpinKitCubeGrid(
                                  size: 40,
                                  color: Colors.blue,
                                );
                              },
                              ),
                             title: Text(image['upload_time']),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Center(
                    child: SpinKitWave(
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}