import 'dart:convert';

import 'package:bookmarks/models/Bookmark.dart';
import 'package:bookmarks/models/User.dart';

import 'package:http/http.dart' as http;

class BookmarkService {
  final User user;

  static const _ENDPOINT_BASE = "/index.php/apps/bookmarks/public/rest/v2/bookmark";

  static final Map<User, BookmarkService> _cache =
    <User, BookmarkService>{};

  factory BookmarkService(User user) {
    return _cache.putIfAbsent(user, () => BookmarkService._(user));
  }

  // private initializing constructor of this factory
  BookmarkService._(this.user);

  Future<String> retrieveAllBookmarks() async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('${this.user.username}:${this.user.appPassword}'));
    http.Response response = await http.get(
      this.user.serverUrl + _ENDPOINT_BASE,
      headers: <String, String>{'authorization': basicAuth}
    );

    if (response.statusCode == 200) {
      // success
      return response.body;
    }

    return "";
  }

  static BookmarkService of(User user) {
    return BookmarkService(user);
  }
}