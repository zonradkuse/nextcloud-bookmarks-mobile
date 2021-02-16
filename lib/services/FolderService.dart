import 'package:bookmarks/models/Folder.dart';
import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/services/Service.dart';

class FolderService extends Service {
  static const _ENDPOINT_BASE =
      "/index.php/apps/bookmarks/public/rest/v2/folder";

  static final Map<User, FolderService> _cache = <User, FolderService>{};

  factory FolderService(User user) {
    assert(user != null);
    return _cache.putIfAbsent(user, () => FolderService._(user));
  }

  // private initializing constructor of this factory
  FolderService._(user) : super(endpointBase: _ENDPOINT_BASE, user: user);

  Future<List<Folder>> retrieveFolders([int folderId = -1]) async {
    Map<String, dynamic> response =
        await getRequest('?layers=-1&root=' + folderId.toString());

    List<Folder> result = List<Folder>();
    if (response["status"] != "success") return result;

    for (Map<String, dynamic> element in response["data"]) {
      result.add(Folder.fromJson(element));
    }

    return result;
  }

  void delete(Folder folder) {
    super.deleteRequest(folder.id.toString());
  }

  static FolderService of(User user) {
    return FolderService(user);
  }
}
