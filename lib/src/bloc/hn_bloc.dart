import "dart:async";
import 'dart:collection';

import 'package:http/http.dart' as http;
import 'package:hn_flutter/src/articles.dart';
import 'package:rxdart/rxdart.dart';

enum StoriesType { topStories, newStories }

class HackerNewsBloc {
  static List<int> _newIds = [
    23285249,
    23279160,
    23289185,
    23277594,
    23290844,
  ];

  static List<int> _topIds = [
    23273247,
    23279837,
    23285466,
    23276456,
  ];

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  final _storiesTypeController = StreamController<StoriesType>();

  HackerNewsBloc() {
    _getArticlesAndUpdate(_topIds);

    _storiesTypeController.stream.listen((storiesType) {
      List<int> ids;

      if (storiesType == StoriesType.newStories) {
        _getArticlesAndUpdate(_newIds);
      } else {
        _getArticlesAndUpdate(_topIds);
      }
    });
  }

  _getArticlesAndUpdate(List<int> ids) async {
    _isLoadingSubject.add(true);

    await _updateArticles(ids);

    _articlesSubject.add(UnmodifiableListView(_articles));

    _isLoadingSubject.add(false);
  }

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);

    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
  }

  Future<Null> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((id) => _getArticle(id));

    final articles = await Future.wait(futureArticles);

    _articles = articles;
  }
}
