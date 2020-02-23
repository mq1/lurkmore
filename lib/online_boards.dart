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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lurkmore/types.dart';
import 'package:http/http.dart' as http;

class OnlineBoardsPage extends StatelessWidget {
  const OnlineBoardsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add board(s)')),
      body: OnlineBoardsView(),
    );
  }
}

class OnlineBoardsView extends StatefulWidget {
  OnlineBoardsView({Key key}) : super(key: key);

  @override
  _OnlineBoardsViewState createState() => _OnlineBoardsViewState();
}

class _OnlineBoardsViewState extends State<OnlineBoardsView> {
  Map<String, dynamic> boards;

  Future<List<Board>> getBoards(http.Client client) async {
    final response = await client.get('https://a.4cdn.org/boards.json');

    final parsed = json.decode(response.body)['boards'];
    return parsed.map<Board>((json) => Board.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Board>>(
      future: getBoards(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? OnlineBoardList(boards: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class OnlineBoardList extends StatefulWidget {
  OnlineBoardList({Key key, this.boards}) : super(key: key);

  final List<Board> boards;

  @override
  _OnlineBoardListState createState() => _OnlineBoardListState();
}

class _OnlineBoardListState extends State<OnlineBoardList> {
  void _handleTap(String board) {
    // TODO add board to saved boards
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.boards.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(child: Text(widget.boards[index].board)),
            title: Text(widget.boards[index].title),
            onTap: () {
              _handleTap(widget.boards[index].board);
            },
          );
        });
  }
}
