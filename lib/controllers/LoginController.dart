import 'package:bookmarks/abstractions/Controller.dart';
import 'package:bookmarks/widgets/LoginWidget.dart';
import 'package:flutter/widgets.dart';
import 'package:bookmarks/views/LoginView.dart';

class LoginController extends Controller<LoginWidget> {

  @override
  Widget build(BuildContext context) => LoginView(this);

}