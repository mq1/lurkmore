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

class Board {
  final String board;
  final String title;

  Board({this.board, this.title});

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
        board: json['board'] as String, title: json['title'] as String);
  }

  Map<String, dynamic> toJson() => {
        'board': board,
        'title': title,
      };
}

class Thread {
  final int no; // numeric id
  final int tim; // numeric image id
  final String sub; // subject
  final String com; // comment
  final int replies; // reply count

  Thread({this.no, this.tim, this.sub, this.com, this.replies});

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
        no: json['no'] as int,
        tim: json['tim'] as int,
        sub: json['sub'] as String,
        com: json['com'] as String,
        replies: json['replies'] as int);
  }
}

class Post {
  final int no; // numeric id
  final String name; // author
  final String sub; // subject
  final String com; // comment
  final int tim; // image numeric id
  final String filename;
  final String ext; // file extension

  Post(
      {this.no,
      this.name,
      this.sub,
      this.com,
      this.tim,
      this.filename,
      this.ext});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      no: json['no'] as int,
      name: json['name'] as String,
      sub: json['sub'] as String,
      com: json['com'] as String,
      tim: json['tim'] as int,
      filename: json['filename'] as String,
      ext: json['ext'] as String,
    );
  }
}
