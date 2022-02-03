import 'package:flutter/material.dart';
import 'package:latihan_sqllite/pages/pelanggan/form_pelanggan.dart';
import 'package:latihan_sqllite/pages/pelanggan/list_pelanggan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:   PelangganList(),
    );
  }
}

