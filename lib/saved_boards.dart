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
import 'package:lurkmore/catalog.dart';
import 'package:lurkmore/types.dart';
import 'package:lurkmore/online_boards.dart';
import 'package:lurkmore/storage.dart';

class SavedBoardsPage extends StatelessWidget {
  const SavedBoardsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Boards')),
      body: SavedBoardsView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnlineBoardsPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SavedBoardsView extends StatefulWidget {
  @override
  _SavedBoardsViewState createState() => _SavedBoardsViewState();
}

class _SavedBoardsViewState extends State<SavedBoardsView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Board>>(
      future: getSavedBoards(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? SavedBoardList(boards: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SavedBoardList extends StatefulWidget {
  SavedBoardList({Key key, this.boards}) : super(key: key);

  final List<Board> boards;

  @override
  _SavedBoardListState createState() => _SavedBoardListState();
}

class _SavedBoardListState extends State<SavedBoardList> {
  void _handleTap(String board) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CatalogPage(board: board)));
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
