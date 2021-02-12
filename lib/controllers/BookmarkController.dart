import 'package:bookmarks/abstractions/Controller.dart';
import 'package:bookmarks/models/Bookmark.dart';
import 'package:bookmarks/models/Folder.dart';
import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/services/BookmarkService.dart';
import 'package:bookmarks/services/FolderService.dart';
import 'package:bookmarks/views/BookmarkListView.dart';
import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkController extends Controller<HomeWidget> {
  int _counter = 0;

  int _folderId = -1;

  List<Bookmark> _bookmarks;
  List<Folder> _folders;

  int get counter => _counter;

  int get folderId => _folderId;

  List<Bookmark> get bookmarks => _bookmarks;

  Folder get folder {
    if (this._folderId == -1) return null;

    return findFolder(this._folders, this._folderId);
  }

  List<Folder> get folders =>
      this._folderId == -1 ? this._folders : folder.children;

  static Folder findFolder(List<Folder> folders, int folderId) {
    if (folders == null) {
      return null;
    }
    for (Folder folder in folders) {
      if (folder.id == folderId) {
        return folder;
      }
      Folder found = findFolder(folder.children, folderId);
      if (found != null) {
        return found;
      }
    }
    return null;
  }

  Future<void> refresh() async {
    await this.retrieveBookmarks();
    await this.retrieveFolders();
  }

  Future<void> retrieveBookmarks() async {
    User user = await User.findOne();

    List<Bookmark> bookmarks = List();
    if (user != null) {
      bookmarks = await BookmarkService.of(user)
          .retrieveBookmarksOfFolder(this._folderId);
    }

    setState(() {
      _bookmarks = bookmarks;
    });
  }

  Future<void> retrieveFolders() async {
    User user = await User.findOne();

    List<Folder> folders = List();
    if (user != null) {
      folders = await FolderService.of(user).retrieveFolders();
    }

    setState(() {
      _folders = folders;
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

  Future<void> setFolder(int id) async {
    if (findFolder(this._folders, id) == null) {
      id = -1;
    }

    this._folderId = id;
    await retrieveBookmarks();
    setState(() {
      _folderId = id;
    });
  }
}
