import 'package:bookmarks/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'layouts/DefaultLayout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(DefaultLayout());
}
