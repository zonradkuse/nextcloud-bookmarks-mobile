import 'package:bookmarks/models/Bookmark.dart';
import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/services/BookmarkService.dart';
import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:bookmarks/views/BookmarkListView.dart';
import 'package:bookmarks/abstractions/Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkController extends Controller<HomeWidget> {
  int _counter = 0;

  List<Bookmark> _bookmarks;

  int get counter => _counter;
  List<Bookmark> get bookmarks => _bookmarks;

  Future<void> retrieveBookmarks() async {
    User user = await User.findOne();

    List<Bookmark> bookmarks = List();
    if (user != null) {
      bookmarks = await BookmarkService.of(user).retrieveAllBookmarks();
    }

    setState(() {
      _bookmarks = bookmarks;
    });
  }

  void resetBookmarks() {
    setState(() {
      _bookmarks = null;
    });
  }

  Future<void> delete(Bookmark bookmark) async {
    User user = await User.findOne();
    BookmarkService.of(user).delete(bookmark);

    setState(() {
      _bookmarks.remove(bookmark);
    });
  }

  Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) => BookmarkListView(this);

}
