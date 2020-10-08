class Bookmark {
  int _id;
  String _url;
  String _title;
  String _description;

  List<String> _tags;
  List<String> _folders;

  Bookmark(this._id, this._url, this._title, this._description, this._tags,
      this._folders);

  int get id => _id;
  String get url => _url;
  String get title => _title;
  String get description => _description;

  static Bookmark fromJson(Map<String, dynamic> data) {
    return Bookmark(
      (data["id"] as int),
      (data["url"] as String),
      (data["title"] as String),
      (data["description"] as String),
      (data["tags"] as List<dynamic>).cast<String>(),
      (data["folders"] as List<dynamic>).cast<String>(),
    );
  }
}
