import 'package:flutter/material.dart';
import 'package:flutter_sqlite/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyApp createState() => _MyApp();

}

class _MyApp extends  State<StatefulWidget> {

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Curd",
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: HomePage(title: "Home Page")
    );
  }
}

