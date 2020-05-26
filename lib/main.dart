import 'dart:async';
import 'dart:collection';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:hn_flutter/src/articles.dart';
import 'package:hn_flutter/src/bloc/hn_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

Future main() async {
  final hnBloc = HackerNewsBloc();

  runApp(MyApp(
    bloc: hnBloc,
  ));
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc bloc;

  MyApp({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackerNews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'HackerNews',
        bloc: bloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewsBloc bloc;

  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: widget.bloc.articles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) => ListView(
          children: snapshot.data.map(_buildItems).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), title: Text('Top Stories')),
          BottomNavigationBarItem(
              icon: Icon(Icons.new_releases), title: Text('New Stories')),
        ],
        onTap: (index) {
          if (index == 0) {
            widget.bloc.storiesType.add(StoriesType.topStories);
          } else {
            widget.bloc.storiesType.add(StoriesType.newStories);
          }
        },
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
