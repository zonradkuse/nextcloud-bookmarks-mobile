import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:bookmarks/views/HomeView.dart';
import 'package:bookmarks/abstractions/Controller.dart';
import 'package:flutter/cupertino.dart';

class HomeController extends Controller<HomeWidget> {
  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) => HomeView(this);

}
