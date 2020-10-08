import 'package:bookmarks/abstractions/Controller.dart';
import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/widgets/LoginWidget.dart';
import 'package:flutter/widgets.dart';
import 'package:bookmarks/views/login/LoginView.dart';
import 'package:validators/validators.dart';
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

  String _preprocessUrl(String url) {
    if (!url.startsWith("http")) {
      url = "https://$url";
    }

    return url;
  }

  setBaseUrl(String url) {
    setState(() {
      this._baseUrl = _preprocessUrl(url);
    });
  }

  @override
  Widget build(BuildContext context) => LoginView(this);

}