import 'package:bookmarks/abstractions/WidgetView.dart';
import 'package:bookmarks/models/User.dart';
import 'package:bookmarks/widgets/LoginWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AuthenticatedView<TWidget, TController> extends WidgetView<TWidget, TController> {

  const AuthenticatedView(state, {Key key}) : super(state, key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // TODO performance. This is called whenever any action happens.
      // i.e. for any action we perform 2 db queries which we don't actually need
      future: User.findOne(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.data == null) {
          // show LoginWidget if we couldn't find any user
          return LoginWidget();
        } else {
          return doBuild(context);
        }
    });
  }

  Widget doBuild(BuildContext context);
}