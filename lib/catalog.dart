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

class Thread {
  final int id;
  final int thumbnailId;
  final String subject;
  final String comment;
  final DateTime lastModified;
  final int replies;

  Thread({this.id, this.thumbnailId, this.subject, this.comment, this.lastModified, this.replies});

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['no'] as int,
      thumbnailId: json['tim'] as int,
      subject: json['sub'] as String,
      comment: json['com'] as String,
      lastModified: DateTime.fromMillisecondsSinceEpoch((json['last_modified'] as int)*1000),
      replies: json['replies'] as int
    );
  }
}

class ThreadsView extends StatefulWidget {
  ThreadsView({Key key, this.board}) : super(key: key);

  final String board;

  @override
  _ThreadsViewState createState() => _ThreadsViewState();
}

class _ThreadsViewState extends State<ThreadsView> {
  Map<String, dynamic> threads;

  Future<List<Thread>> fetchThreads(http.Client client) async {
    final response = await client.get('https://a.4cdn.org/${widget.board}/catalog.json');

    return parseThreads(response.body);
  }

  List<Thread> parseThreads(String responseBody) {
    List<Thread> threads = [];
    final parsed = json.decode(responseBody);

    for (final page in parsed) {
      for (final thread in page['threads']) {
        threads.add(Thread.fromJson(thread));
      }
    }

    return threads;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Thread>>(
      future: fetchThreads(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
          ? ThreadList(threads: snapshot.data, board: widget.board)
          : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ThreadList extends StatefulWidget {
  ThreadList({Key key, this.board, this.threads}) : super(key: key);

  final String board;
  final List<Thread> threads;

  @override
  _ThreadListState createState() => _ThreadListState();
}

class _ThreadListState extends State<ThreadList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.threads.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Container (
            height: 64,
            width: 64,
            child: Image.network('https://i.4cdn.org/${widget.board}/${widget.threads[index].thumbnailId}s.jpg')
          ),
          title: Text(widget.threads[index].subject != null ? widget.threads[index].subject : '', maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(widget.threads[index].comment != null ? widget.threads[index].comment : '', maxLines: 2, overflow: TextOverflow.ellipsis)
        );
      }
    );
  }
}
