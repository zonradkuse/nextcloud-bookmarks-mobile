import 'package:bookmarks/models/Bookmark.dart';
import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/services/BookmarkService.dart';
import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:bookmarks/views/HomeView.dart';
import 'package:bookmarks/abstractions/Controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends Controller<HomeWidget> {
  int _counter = 0;

  List<Bookmark> _bookmarks = List();

  HomeController() {
    // initialize bookmarks once
    this.retrieveBookmarks();
  }

  int get counter => _counter;
  List<Bookmark> get bookmarks => _bookmarks;

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> retrieveBookmarks() async {
    User user = await User.findOne();
    List<Bookmark> bookmarks = await BookmarkService.of(user).retrieveAllBookmarks();

    setState(() {
      _bookmarks = bookmarks;
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
  Widget build(BuildContext context) => HomeView(this);

}
