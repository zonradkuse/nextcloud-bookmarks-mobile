import 'package:bookmarks/abstractions/AuthenticatedView.dart';
import 'package:bookmarks/controllers/BookmarkController.dart';
import 'package:bookmarks/models/Bookmark.dart';
import 'package:bookmarks/models/Folder.dart';
import 'package:bookmarks/views/CenteredCard.dart';
import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum BookmarkAction { EDIT, DELETE, SHARE }

class BookmarkListView
    extends AuthenticatedView<HomeWidget, BookmarkController> {
  const BookmarkListView(state, {Key key}) : super(state, key: key);

  static const int subtitleLength = 42;
  static const int titleLength = 70;

  @override
  Widget doBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.folder == null ? "Bookmarks" : state.folder.title),
        leading: state.folderId != -1
            ? BackButton(onPressed: () {
                state.setFolder(state.folder.parentFolder);
                state.retrieveBookmarks();
              })
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: state.refresh,
        child: Center(
          child: Builder(
            builder: (context) {
              if (state.bookmarks == null) {
                state.refresh();
                return CircularProgressIndicator();
              } else if (state.bookmarks.length == 0 &&
                  state.folders.length == 0) {
                return _noBookmarksFound();
              }

              return _bookmarksList();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add bookmark',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView _bookmarksList() {
    return ListView(
      controller: ScrollController(),
      physics: AlwaysScrollableScrollPhysics(),
      children: _rows(),
    );
  }

  CenteredCard _noBookmarksFound() {
    return CenteredCard(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: SvgPicture.asset("assets/whale.svg", height: 50),
        ),
        Text(
          "You don't have any bookmarks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16.0, 0.0, 8.0),
          child: TextButton(
            onPressed: () {
              state.resetBookmarks();
              state.retrieveBookmarks();
            },
            child: Text('Refresh'),
          ),
        ),
      ]),
    );
  }

  List<Widget> _rows() {
    List<Widget> result = List();
    assert(state.bookmarks != null);

    if (state.folders != null) {
      for (Folder folder in state.folders) {
        result.add(
          Card(
            elevation: 2,
            child: InkWell(
              onTap: () {
                state.setFolder(folder.id);
              },
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(Icons.folder)),
                  Expanded(
                    child: ListTile(
                      title: Text(
                          "${this._capString(folder.title, BookmarkListView.titleLength)}"),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    for (Bookmark bookmark in state.bookmarks) {
      result.add(
        Card(
          elevation: 2,
          child: InkWell(
            onTap: () {
              state.launchInBrowser(bookmark.url);
            },
            child: Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: bookmark.favicon),
                Expanded(
                  child: ListTile(
                    title: Text(
                        "${this._capString(bookmark.title, BookmarkListView.titleLength)}"),
                    subtitle:
                        Text("${this._prepareBookmarkSubtitle(bookmark)}"),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                _contextMenu(bookmark),
              ],
            ),
          ),
        ),
      );
    }

    return result;
  }

  Widget _contextMenu(Bookmark bookmark) {
    return PopupMenuButton<BookmarkAction>(
      elevation: 5,
      onSelected: (BookmarkAction action) {
        switch (action) {
          case BookmarkAction.EDIT:
            // open edit view
            break;
          case BookmarkAction.SHARE:
            // open share view
            break;
          case BookmarkAction.DELETE:
            // make sure and call controller
            state.delete(bookmark);
            break;
        }
      },
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<BookmarkAction>>[
          PopupMenuItem(value: BookmarkAction.EDIT, child: Text('Edit')),
          PopupMenuItem(value: BookmarkAction.SHARE, child: Text('Share')),
          PopupMenuDivider(),
          PopupMenuItem(
              value: BookmarkAction.DELETE,
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ))
        ];
      },
    );
  }

  String _prepareBookmarkSubtitle(Bookmark bookmark) {
    String subtitle = bookmark.description;
    if (subtitle == '') {
      subtitle = bookmark.url;
    }
    return this._capString(subtitle, BookmarkListView.subtitleLength);
  }

  String _capString(String string, int length) {
    return string.length <= length
        ? string
        : string.substring(0, length) + '...';
  }
}
