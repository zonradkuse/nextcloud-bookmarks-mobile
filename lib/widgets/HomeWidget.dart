import 'package:bookmarks/controllers/HomeController.dart';
import 'package:flutter/cupertino.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomeController createState() => HomeController();
}