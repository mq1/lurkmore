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

class Board {
  final String board;
  final String title;

  Board({this.board, this.title});

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
        board: json['board'] as String, title: json['title'] as String);
  }
}

class BoardsView extends StatefulWidget {
  BoardsView({Key key, @required this.onChanged}) : super(key: key);

  final ValueChanged<String> onChanged;

  @override
  _BoardsViewState createState() => _BoardsViewState();
}

class _BoardsViewState extends State<BoardsView> {
  Map<String, dynamic> boards;

  Future<List<Board>> fetchBoards(http.Client client) async {
    final response = await client.get('https://a.4cdn.org/boards.json');

    return parseBoards(response.body);
  }

  List<Board> parseBoards(String responseBody) {
    final parsed = json.decode(responseBody)['boards'];

    return parsed.map<Board>((json) => Board.fromJson(json)).toList();
  }

  void _handleTap(String board) {
    widget.onChanged(board);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Board>>(
      future: fetchBoards(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? BoardList(boards: snapshot.data, onChanged: _handleTap)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class BoardList extends StatefulWidget {
  BoardList({Key key, this.boards, @required this.onChanged}) : super(key: key);

  final List<Board> boards;
  final ValueChanged<String> onChanged;

  @override
  _BoardListState createState() => _BoardListState();
}

class _BoardListState extends State<BoardList> {
  void _handleTap(String board) {
    widget.onChanged(board);
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
