import 'dart:convert' as json;
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:hn_flutter/src/serializers.dart';

part 'articles.g.dart';

abstract class Article implements Built<Article, ArticleBuilder> {
  // Fields
  static Serializer<Article> get serializer => _$articleSerializer;

  int get id;

  @nullable
  bool get deleted;

  String get type;

  String get by;

  int get time;

  @nullable
  String get text;

  @nullable
  bool get dead;

  @nullable
  int get parent;

  @nullable
  int get poll;

  BuiltList<int> get kids;

  @nullable
  String get url;

  @nullable
  int get score;

  @nullable
  String get title;

  BuiltList<int> get parts;

  @nullable
  int get descendants;

  Article._();

  factory Article([void Function(ArticleBuilder) updates]) = _$Article;
}

List<int> parseTopStories(String jsonStr) {
  return [];
  // final parsed = json.jsonDecode(jsonStr);
  // final listOfIds = List<int>.from(parsed);

  // return listOfIds;
}

Article parseArticle(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
  Article article =
      standardSerializers.deserializeWith(Article.serializer, parsed);

  return article;
}

// class Article {
//   final String text;
//   final String domain;
//   final String by;
//   final String age;
//   final int score;
//   final int commentsCount;

//   const Article(
//       {this.text,
//       this.domain,
//       this.by,
//       this.age,
//       this.score,
//       this.commentsCount});
// }

// final articles = [
//   new Article(
//     text:
//         "Circular Shock Acoustic Waves in Ionosphere Triggered by Launch of Formosat-5",
//     domain: "wiley.com",
//     by: "zdw",
//     age: "3 hours",
//     score: 177,
//     commentsCount: 62,
//   ),
//   new Article(
//     text: "BMW says electric car mass production not viable until 2020",
//     domain: "reuters.com",
//     by: "Mononokay",
//     age: "2 hours",
//     score: 81,
//     commentsCount: 128,
//   ),
//   new Article(
//     text: "Evolution Is the New Deep Learning",
//     domain: "sentient.ai",
//     by: "jonbaer",
//     age: "4 hours",
//     score: 200,
//     commentsCount: 87,
//   ),
//   new Article(
//     text: "TCP Traceopoints hace arrived in Linux",
//     domain: "brndangregg.com",
//     by: "brendangregg",
//     age: "1 hour",
//     score: 35,
//     commentsCount: 0,
//   ),
//   new Article(
//     text:
//         "Section 230: A Key Legal Shield for Facebook, Google Is About to Change",
//     domain: "npr.org",
//     by: "Monokay",
//     age: "5 hours",
//     score: 156,
//     commentsCount: 66,
//   ),
//   new Article(
//     text: "A Visiting Star Jostled Our Solar System 70,000 Years Ago",
//     domain: "gizmodo.com",
//     by: "rbanffy",
//     age: "7 hours",
//     score: 122,
//     commentsCount: 43,
//   ),
//   new Article(
//     text:
//         "Number systems of the world, sorted by complexity of counting (2006)",
//     domain: "airnet.ne.jp",
//     by: "ColinWright",
//     age: "8 hours",
//     score: 196,
//     commentsCount: 90,
//   ),
//   new Article(
//     text: "MIT's new device can pull water from desert air",
//     domain: "techcrunch.com",
//     by: "evo_9",
//     age: "43 minutes",
//     score: 11,
//     commentsCount: 11,
//   ),
//   new Article(
//     text:
//         "TravisBuddy: Adds comments to failed pull requests, tells author what went wrong",
//     domain: "github.com",
//     by: "bluzzi",
//     age: "8 hours",
//     score: 37,
//     commentsCount: 26,
//   ),
//   new Article(
//     text: "Using Technical Debt in Your Favor",
//     domain: "gitconnected.com",
//     by: "treyhuffine",
//     age: "7 hours",
//     score: 140,
//     commentsCount: 123,
//   ),
// ];
