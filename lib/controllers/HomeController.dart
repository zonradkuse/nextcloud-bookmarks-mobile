import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/services/BookmarkService.dart';
import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:bookmarks/views/HomeView.dart';
import 'package:bookmarks/abstractions/Controller.dart';
import 'package:flutter/cupertino.dart';

class HomeController extends Controller<HomeWidget> {
  int _counter = 0;

  String _bookmarks = "";

  HomeController() {
    // initialize bookmarks once
    this.retrieveBookmarks();
  }

  int get counter => _counter;
  String get bookmarks => _bookmarks;

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> retrieveBookmarks() async {
    User user = await User.findOne();
    String bookmarks = await BookmarkService.of(user).retrieveAllBookmarks();

    setState(() {
      _bookmarks = bookmarks;
    });
  }

  @override
  Widget build(BuildContext context) => HomeView(this);

}
