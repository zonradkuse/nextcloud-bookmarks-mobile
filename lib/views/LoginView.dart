import 'package:bookmarks/controllers/LoginController.dart';
import 'package:bookmarks/views/NextcloudLoginWebView.dart';
import 'package:bookmarks/widgets/LoginWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../abstractions/WidgetView.dart';

class LoginView extends WidgetView<LoginWidget, LoginController> {
  const LoginView (state, {Key key}) : super(state, key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nextcloud Login"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Please enter your Nextcloud server url to sync your bookmarks with:"),
              TextFormField(
                // TODO update even before submit
                onFieldSubmitted: this.state.setBaseUrl,
                validator: (String value) {
                  return isURL(value, requireProtocol: true) ? 'Please use a valid url' : null;
                },
                decoration: InputDecoration(
                  hintText: "url",
                  helperText: "e.g. https://cloud.example.com/",
                ),
              ),
              RaisedButton(
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NextcloudLoginWebView(state))
                  ),
                },
                child: Text("Let's go!"),
              ),
            ],
          ),
        ),
      );
  }
  
}
