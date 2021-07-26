import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_app/models/task_model.dart';
import 'package:hive_todo_app/views/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks-box');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(      
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        canvasColor: Colors.transparent,
      ),
      home: SplashScreen(),
    );
  }
}
