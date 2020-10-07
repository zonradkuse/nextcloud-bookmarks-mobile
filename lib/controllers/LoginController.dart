import 'package:bookmarks/abstractions/Controller.dart';
import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/widgets/LoginWidget.dart';
import 'package:flutter/widgets.dart';
import 'package:bookmarks/views/LoginView.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginController extends Controller<LoginWidget> {

  String _baseUrl;

  String get baseUrl => _baseUrl;

  User createUserFromRequestIfExists(NavigationRequest request) {
    if (request.url.startsWith("nc")) {
      RegExp regex = RegExp(r"server:(.*)&user:(.*)&password:(.*)");
      Iterable matches = regex.allMatches(request.url);
      if (matches.length == 0) return null;

      RegExpMatch match = matches.first;
      // nextcloud does not use standard uri parameter formats (: instead of =)
      // -- hence we parse them ourselves
      String username = match.group(2);
      String password = match.group(3);
      String server = match.group(1);

      User user = User(server, username, password);
      user.insert();

      return user;
    }

    return null;
  }

  setBaseUrl(String url) {
    setState(() {
      this._baseUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) => LoginView(this);

}