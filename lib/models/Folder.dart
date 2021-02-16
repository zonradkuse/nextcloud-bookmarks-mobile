class Folder {
  int _id;
  int _parentFolder;
  String _title;

  List<Folder> _children;

  Folder(this._id, this._parentFolder, this._title, this._children);

  int get id => _id;
  int get parentFolder => _parentFolder;
  String get title => _title;
  List<Folder> get children => _children;

  static Folder fromJson(Map<String, dynamic> data) {
    final newChildren = data["children"] as List;
    return Folder(
      (data["id"] as int),
      (data["parent_folder"] as int),
      (data["title"] as String),
      (data["children"] is List
          ? newChildren
              .cast<Map<String, Object>>()
              .map((data) => Folder.fromJson(data))
              .toList()
          : null),
    );
  }
}
