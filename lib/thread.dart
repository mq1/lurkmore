/* Copyright (C) 2020  Manuel Quarneti
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' show parse;

class Post {
  final int no; // numeric id
  final String name; // author
  final String sub; // subject
  final String com; // comment
  final int tim; // image numeric id

  Post({this.no, this.name, this.sub, this.com, this.tim});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        no: json['no'] as int,
        name: json['name'] as String,
        sub: json['sub'] as String,
        com: json['com'] as String,
        tim: json['tim'] as int);
  }
}

class ThreadView extends StatefulWidget {
  ThreadView({Key key, @required this.board, @required this.threadNo})
      : super(key: key);

  final String board;
  final int threadNo;

  @override
  _ThreadViewState createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  Future<List<Post>> fetchThread(http.Client client) async {
    final response = await client.get(
        'https://a.4cdn.org/${widget.board}/thread/${widget.threadNo}.json');

    return parseThread(response.body);
  }

  List<Post> parseThread(String responseBody) {
    final parsed = json.decode(responseBody)['posts'];

    return parsed.map<Post>((json) => Post.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<Post>>(
      future: fetchThread(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? PostList(board: widget.board, posts: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    ));
  }
}

class PostList extends StatefulWidget {
  PostList({Key key, @required this.board, @required this.posts})
      : super(key: key);

  final String board;
  final List<Post> posts;

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.posts.length,
        itemBuilder: (BuildContext context, int index) {
          var title = widget.posts[index].sub == null
              ? widget.posts[index].com
              : widget.posts[index].sub;
          var subtitle =
              widget.posts[index].com == title ? '' : widget.posts[index].com;

          return widget.posts[index].tim != null
              ? Card(
                  child: ListTile(
                      leading: Container(
                          height: 64,
                          width: 64,
                          child: widget.posts[index].tim != null
                              ? Image.network(
                                  'https://i.4cdn.org/${widget.board}/${widget.posts[index].tim}s.jpg')
                              : SizedBox.shrink()),
                      title: Text(parseHtmlString(title)),
                      subtitle: Text(parseHtmlString(subtitle))))
              : Card(
                  child: ListTile(
                      title: Text(parseHtmlString(title)),
                      subtitle: Text(parseHtmlString(subtitle))));
        });
  }
}

String parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  String parsedString = parse(document.body.text).documentElement.text;
  return parsedString;
}
