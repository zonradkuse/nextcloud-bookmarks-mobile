import 'package:bookmarks/controllers/LoginController.dart';
import 'package:bookmarks/views/NextcloudLoginWebView.dart';
import 'package:bookmarks/widgets/LoginWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../abstractions/WidgetView.dart';

class LoginView extends WidgetView<LoginWidget, LoginController> {
  LoginView (state, {Key key}) : super(state, key: key);

  final TextEditingController _textEditingController = TextEditingController();

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
                controller: _textEditingController,
                validator: (String value) {
                  return isURL(value, requireProtocol: true) ? 'Please use a valid url' : null;
                },
                decoration: InputDecoration(
                  hintText: "url",
                  helperText: "e.g. https://cloud.example.com/",
                ),
              ),
              RaisedButton(
                onPressed: () {
                  state.setBaseUrl(_textEditingController.text);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NextcloudLoginWebView(state))
                  );
                },
                child: Text("Let's go!"),
              ),
            ],
          ),
        ),
      );
  }
  
}
