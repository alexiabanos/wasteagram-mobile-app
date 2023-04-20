// Import necessary packages and files
import 'package:flutter/material.dart';
import 'screens/list_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/new_post_screen.dart';

// Create a stateful widget for the app
class App extends StatefulWidget {
  final String title;

  // Constructor
  const App({Key? key, required this.title}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

// Define the state for the app
class _AppState extends State<App> {
  // Define a map of routes for the app
  late final Map<String, Widget Function(BuildContext)> routes;

  @override
  void initState() {
    super.initState();
    // Initialize the routes map
    routes = {
      PostsListScreen.routeName: (context) {
        return PostsListScreen(title: widget.title);
      },
      PostDetailsScreen.routeName: (context) {
        return PostDetailsScreen(title: widget.title);
      },
      NewPostForm.routeName: (context) {
        return const NewPostForm();
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    // Build the MaterialApp widget with the specified title, theme, routes, and initial route
    return MaterialApp(
      title: widget.title,
      theme: ThemeData.dark(),
      routes: routes,
      initialRoute: PostsListScreen.routeName,
    );
  }
}
