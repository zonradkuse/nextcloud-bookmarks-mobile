import 'package:bookmarks/controllers/HomeController.dart';
import 'package:bookmarks/abstractions/AuthenticatedView.dart';
import 'package:bookmarks/models/Bookmark.dart';
import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends AuthenticatedView<HomeWidget, HomeController> {

  const HomeView (state, {Key key}) : super(state, key: key);

  @override
  Widget doBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: state.retrieveBookmarks,
        child: Center(
          child: ListView(
            controller: ScrollController(),
            physics: AlwaysScrollableScrollPhysics(),
            children: _rows(context),
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

  List<Widget> _rows(BuildContext context) {
    List<Widget> result = List();
    assert(state.bookmarks != null);
    for (Bookmark bookmark in state.bookmarks) {
      result.add(
        InkWell(
          onTap: () {
            state.launchInBrowser(bookmark.url);
          },
          child: Card(
            elevation: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text("${bookmark.title}"),
                    subtitle: Text("${bookmark.description != "" ? bookmark.description : bookmark.url}"),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                PopupMenuButton(
                  elevation: 5,
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) {
                    return <PopupMenuEntry>[
                      PopupMenuItem(child: Text('Edit')),
                      PopupMenuItem(child: Text('Share')),
                      PopupMenuDivider(),
                      PopupMenuItem(child: Text('Delete', style: TextStyle(color: Colors.red),))
                    ];
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (result.length == 0) {
      result.add(
        Card(
          child: Center(
            child: Text("No bookmarks, yet :-(")
          ),
        )
      );
    }

    return result;
  }
}
