import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hn_flutter/src/articles.dart';

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackerNews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'HackerNews'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List<Article> _articles = articles;
  List<int> _ids = [
    23273247,
    23279837,
    23285466,
    23276456,
    23285249,
    23279160,
    23289185,
    23277594,
    23290844,
  ];

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);

    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));

          setState(() {
            _ids.removeAt(0);
          });
        },
        child: ListView(
            children: _ids.map((i) {
          return FutureBuilder<Article>(
            future: _getArticle(i),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildItems(snapshot.data);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }).toList()),
      ),
    );
  }

  Widget _buildItems(Article article) {
    return Padding(
      key: Key(article.title),
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(
          article.title ?? ['null'],
          style: TextStyle(fontSize: 24.0),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(article.type),
              IconButton(
                onPressed: () async {
                  if (await canLaunch(article.url)) {
                    launch(article.url);
                  }
                },
                icon: Icon(Icons.launch),
              )
            ],
          ),
        ],
      ),
    );
  }
}
