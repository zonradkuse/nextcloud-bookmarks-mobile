import 'package:bookmarks/controllers/LoginController.dart';
import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:bookmarks/widgets/LoginWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../abstractions/WidgetView.dart';

class NextcloudLoginWebView extends WidgetView<LoginWidget, LoginController> {
  const NextcloudLoginWebView(state, {Key key}) : super(state, key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nextcloud Login"),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: "Nextcloud Bookmarks Android / <VERSION>",
        onWebViewCreated: (WebViewController controller) {
          Map<String, String> headers = {
            "OCS-APIREQUEST": "true",
          };
          controller.clearCache();
          controller.loadUrl("${state.baseUrl}/index.php/login/flow", headers: headers);
        },
        navigationDelegate: (NavigationRequest request) {
          User user = state.createUserFromRequestIfExists(request);
          if (user == null) {
            return NavigationDecision.navigate;
          }

          // we have a user -- navigate back to home!
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeWidget()),
          );

          return NavigationDecision.prevent;
        },
      ),
    );
  }

}
