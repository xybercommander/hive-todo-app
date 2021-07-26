import 'package:flutter/material.dart';
import 'package:hive_todo_app/views/splash_screen.dart';

void main() {
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
