// Import necessary packages
import 'package:flutter/material.dart';

// Define a scaffold for the posts
class PostsScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomWidget;

  // Constructor
  const PostsScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.bottomWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build the scaffold with the specified app bar, body, and bottom navigation bar
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
      ),
      body: body,
      bottomNavigationBar: bottomWidget,
    );
  }
}
