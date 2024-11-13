import 'package:flutter/material.dart';
import 'package:to_do_list/to_do_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List Application',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        )
      ),
      home: const TodoList(),
    );
  }
}
