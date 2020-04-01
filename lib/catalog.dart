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
import 'package:lurkmore/thread.dart';
import 'package:lurkmore/types.dart';
import '4chan/static.dart';
import '4chan/api.dart';

class CatalogPage extends StatelessWidget {
  final board;

  const CatalogPage({Key key, @required this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('/$board/')),
      body: CatalogView(board: board),
    );
  }
}

class CatalogView extends StatefulWidget {
  CatalogView({Key key, @required this.board}) : super(key: key);

  final String board;

  @override
  _CatalogViewState createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  Map<String, dynamic> threads;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Thread>>(
      future: fetchCatalog(widget.board),
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
  void _handleTap(Thread thread) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThreadPage(
            board: widget.board,
            threadSub: thread.sub != null ? thread.sub : '',
            threadNo: thread.no),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.threads.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Container(
              height: 64,
              width: 64,
              child: widget.threads[index].tim != null
                  ? Image(
                      image:
                          getThumbnail(widget.board, widget.threads[index].tim))
                  : SizedBox.shrink()),
          title: widget.threads[index].sub != null ? Text(unescapeHtml(widget.threads[index].sub)) : null,
          subtitle: parseHtmlString(context, widget.threads[index].com),
          onTap: () => _handleTap(widget.threads[index]),
        );
      },
    );
  }
}
