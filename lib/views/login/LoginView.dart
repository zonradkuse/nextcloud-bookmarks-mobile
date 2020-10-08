import 'package:bookmarks/controllers/LoginController.dart';
import 'package:bookmarks/views/CenteredCard.dart';
import 'package:bookmarks/views/login/NextcloudLoginWebView.dart';
import 'package:bookmarks/widgets/LoginWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../../abstractions/WidgetView.dart';

class LoginView extends WidgetView<LoginWidget, LoginController> {
  LoginView(state, {Key key}) : super(state, key: key);

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nextcloud Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(12),
          child: CenteredCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enter your Nextcloud URL",
                    style: Theme.of(context).textTheme.headline6),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.blueAccent,
                      onPressed: () {
                        if (!isURL(_textEditingController.text)) {
                          SnackBar snackbar = SnackBar(content: Text("Please provide a valid URL"));
                          Scaffold.of(context).showSnackBar(snackbar);
                          return;
                        }
                        state.setBaseUrl(_textEditingController.text);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                NextcloudLoginWebView(state)));
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        showCursor: true,
                        decoration: InputDecoration(
                          helperText: "e.g. https://cloud.example.com/",
                          isDense: true,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
