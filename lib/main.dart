import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:http/http.dart' as http;


class Pictures {
  final List<dynamic> pictureCollection;

  const Pictures({
    required this.pictureCollection,
  });

  factory Pictures.fromJson(List<dynamic> json) {
    return Pictures(
      pictureCollection: json
    );
  }
}

Future<Pictures> fetchPicture() async {
  final response = await http.get(Uri.parse('https://api.unsplash.com/users/ashbot/photos/?client_id=896d4f52c589547b2134bd75ed48742db637fa51810b49b607e37e46ab2c0043'));
  if (response.statusCode == 200) {
    return Pictures.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Pictures> futurePictures;
  int _pageIndex = 0;

  @override

  void initState() {
    super.initState();
    futurePictures = fetchPicture();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.amberAccent),
      home: Scaffold(
        appBar: AppBar(title: Text('It progger app'), centerTitle: true),
        body: Container(
          child: FutureBuilder<Pictures>(
            future: futurePictures,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PhotoViewGallery.builder(
                    itemCount: snapshot.data!.pictureCollection.length,
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(snapshot.data!.pictureCollection[index]['urls']['full']),
                          heroAttributes: PhotoViewHeroAttributes(tag: Text('fadf'))
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          )
        ),
      ),
    );
  }
}

