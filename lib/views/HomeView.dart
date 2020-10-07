import 'package:bookmarks/abstractions/WidgetView.dart';
import 'package:bookmarks/controllers/HomeController.dart';
import 'package:bookmarks/abstractions/AuthenticatedView.dart';
import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeView extends AuthenticatedView<HomeWidget, HomeController> {

  const HomeView (state, {Key key}) : super(state, key: key);

  @override
  Widget doBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: LiquidPullToRefresh(
        onRefresh: state.retrieveBookmarks,
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Card(
                child: ListTile(
                  title: Text("${state.bookmarks}"),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: state.incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
