import 'package:flutter/material.dart';

import 'upload_trip_and_images_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UploadPage(),
    );
  }
}
