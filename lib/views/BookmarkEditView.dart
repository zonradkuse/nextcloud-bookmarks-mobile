import 'package:bookmarks/abstractions/AuthenticatedView.dart';
import 'package:bookmarks/controllers/BookmarkController.dart';
import 'package:bookmarks/widgets/HomeWidget.dart';
import 'package:flutter/material.dart';

class BookmarkEditView
    extends AuthenticatedView<HomeWidget, BookmarkController> {
  const BookmarkEditView(state, {Key? key}) : super(state, key: key);

  Widget doBuild(BuildContext context) {
    return Stepper(
        steps: null
    );
  }

}