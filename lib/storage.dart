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
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:lurkmore/types.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localBoardsFile async {
  final path = await _localPath;
  return File('$path/boards.json');
}

Future<List<Board>> getSavedBoards() async {
  try {
    final file = await _localBoardsFile;
    final contents = await file.readAsString();
    final parsed = json.decode(contents);
    return parsed.map<Board>((json) => Board.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
}

Future<File> saveBoards(List<Board> boards) async {
  final encoded = json.encode(boards);

  final file = await _localBoardsFile;
  return file.writeAsString(encoded);
}
