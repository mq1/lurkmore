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
import 'package:lurkmore/types.dart';
import 'package:http/http.dart' as http;

Future<List<Board>> getBoards() async {
  final response = await http.Client().get('https://a.4cdn.org/boards.json');

  final parsed = json.decode(response.body)['boards'];
  return parsed.map<Board>((json) => Board.fromJson(json)).toList();
}

Future<List<Thread>> fetchCatalog(String board) async {
  final response =
      await http.Client().get('https://a.4cdn.org/$board/catalog.json');

  return parseCatalog(response.body);
}

List<Thread> parseCatalog(String responseBody) {
  List<Thread> threads = [];
  final parsed = json.decode(responseBody);

  for (final page in parsed)
    for (final thread in page['threads']) threads.add(Thread.fromJson(thread));

  return threads;
}

Future<List<Post>> fetchThread(String board, int threadNo) async {
  final response = await http.Client()
      .get('https://a.4cdn.org/$board/thread/$threadNo.json');

  return parseThread(response.body);
}

List<Post> parseThread(String responseBody) {
  final parsed = json.decode(responseBody)['posts'];

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}
