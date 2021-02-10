import 'package:bookmarks/models/Bookmark.dart';
import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/services/Service.dart';

class BookmarkService extends Service {
  static const _ENDPOINT_BASE =
      "/index.php/apps/bookmarks/public/rest/v2/bookmark";

  static final Map<User, BookmarkService> _cache = <User, BookmarkService>{};

  factory BookmarkService(User user) {
    assert(user != null);
    return _cache.putIfAbsent(user, () => BookmarkService._(user));
  }

  // private initializing constructor of this factory
  BookmarkService._(user) : super(endpointBase: _ENDPOINT_BASE, user: user);

  Future<List<Bookmark>> retrieveAllBookmarks() async {
    Map<String, dynamic> response = await getRequest('?page=-1');

    List<Bookmark> result = List<Bookmark>();
    if (response["status"] != "success") return result;

    for (Map<String, dynamic> element in response["data"]) {
      result.add(Bookmark.fromJson(element));
    }

    return result;
  }

  Future<List<Bookmark>> retrieveBookmarksOfFolder(int folderId) async {
    Map<String, dynamic> response =
        await getRequest('?page=-1&folder=' + folderId.toString());

    List<Bookmark> result = List<Bookmark>();
    if (response["status"] != "success") return result;

    for (Map<String, dynamic> element in response["data"]) {
      Bookmark bookmark = Bookmark.fromJson(element);
      bookmark.setFavicon(getImage('/' + bookmark.id.toString() + '/favicon'));
      result.add(bookmark);
    }

    return result;
  }

  void delete(Bookmark bookmark) {
    super.deleteRequest('/' + bookmark.id.toString());
  }

  static BookmarkService of(User user) {
    return BookmarkService(user);
  }
}
