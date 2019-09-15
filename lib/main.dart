import 'package:flutter/material.dart';
import 'package:vtb_hackaton/app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VTB Hack',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: App(),
      debugShowCheckedModeBanner: false,
    );
  }
}
