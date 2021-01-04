import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NewsArticle {
  final String title;
  final String description;
  final String urlToImage;

  NewsArticle({this.title, this.description, this.urlToImage});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
        title: json['title'],
        description: json['description'],
        urlToImage: json['urlToImage'] ?? 'assets/placeholder.jpg');
  }

  static Resource<List<NewsArticle>> get all {
    return Resource(
        url:
            'https://newsapi.org/v2/top-headlines?country=us&apiKey=insertyourapikeyhere',
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result['articles'];
          return list.map((model) => NewsArticle.fromJson(model)).toList();
        });
  }
}

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({this.url, this.parse});
}

class Webservice {
  Future<T> load<T>(Resource<T> resource) async {
    final response = await http.get(resource.url);
    if (response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Unable to load data!' + response.statusCode.toString());
    }
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response =
      await http.get("https://jsonplaceholder.typicode.com/albums/1");

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  }
}


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

}


//class _MyAppState extends State<MyApp> {
//  Future<Album> futureAlbum;
//
//  @override
//  void initState() {
//    super.initState();
//    futureAlbum = fetchAlbum();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Fetch Data Example',
//      theme: ThemeData(
//        primarySwatch: Colors.blue
//      ),
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Fetch Data Example'),
//        ),
//        body: Center(
//          child: FutureBuilder<Album>(
//            future: futureAlbum,
//            builder: (context, snapshot) {
//              if (snapshot.hasData) {
//                return Text(snapshot.data.title);
//              } else if(snapshot.hasError) {
//                return Text('${snapshot.error}');
//              }
//              return CircularProgressIndicator();
//            },
//          ),
//        ),
//      ),
//    );
//  }
//
//}


class _MyAppState extends State<MyApp> {
  List<String> data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          "Accept": "application/json"
        }
    );

    this.setState(() {
      data = json.decode(response.body);
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('News'),
        ),
        body: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: new Text(data[index]),
            );
          },
        )
    );
  }

}