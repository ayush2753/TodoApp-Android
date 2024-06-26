import 'package:flutter/material.dart';
import 'package:todo_app/screen/add_page.dart';
import 'package:todo_app/screen/splashscreen.dart';
import 'package:todo_app/screen/todo_list.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TodoListPage(),
    );
  }
}
