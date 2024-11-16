import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final int postIndex;

  PostDetailScreen({required this.postIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail #$postIndex'),
      ),
      body: Center(
        child: Text('Full details of Post #$postIndex'),
      ),
    );
  }
}
