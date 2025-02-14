import 'package:assignment2/Provider/logged_student.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'database_helper.dart';
import 'my_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.insertPredefinedCourses();
  runApp(ChangeNotifierProvider(
      create: (context)=>LoggedStudent(),
    child: const MyApp(),
  ));
}

