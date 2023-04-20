// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detail_screen.dart';
import 'new_post_screen.dart';

import '../widgets/food_waste_post.dart';
import '../widgets/camera_fab.dart';
import '../models/new_post.dart';
import '../db/new_post_dao.dart';

// Defining a stateful widget for the PostsListScreen
class PostsListScreen extends StatefulWidget {
  // Setting a static route name
  static const routeName = 'posts_list';
  final String title;

  // Constructor for the widget
  const PostsListScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

// State class for the PostsListScreen widget
class _PostsListScreenState extends State<PostsListScreen> {
  // Initializing a variable to keep track of the total quantity of posts
  int totalQuantity = 0;

  // Getting a reference to the posts in the database and ordering them by date
  final snapshots =
      NewPostDAO.postsRef.orderBy('date', descending: true).snapshots();

  // When the widget is first created, initialize the total quantity of posts
  @override
  void initState() {
    super.initState();
    getTotalItems();
  }

  // Update the total quantity of posts based on changes to the database
  void getTotalItems() {
    snapshots.listen((event) {
      for (var docChange in event.docChanges) {
        var docSnapshot = docChange.doc;
        setState(() {
          totalQuantity += docSnapshot.get('quantity') as int;
        });
      }
    });
  }

  // Build the widget tree for the PostsListScreen
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        Widget body;
        String title = widget.title;
        // If there are posts in the database, display them in a list
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          body = postsList(context, snapshot);
          title += ' - $totalQuantity';
          // If there are no posts in the database, display a loading indicator
        } else {
          body = const Center(child: CircularProgressIndicator());
        }
        // Display the posts in a scaffold with an add post button
        return PostsScaffold(
          title: title,
          body: body,
          bottomWidget: addPostButton(context),
        );
      },
    );
  }

  // Widget for displaying the list of posts
  Widget postsList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        NewPost postEntry = snapshot.data!.docs[index].data() as NewPost;
        String date = postEntry.dateStringLong;
        String numWasteItems = postEntry.quantityString;
        // Display each post in a list tile with a date and number of waste items
        return Semantics(
          button: true,
          enabled: true,
          label: 'Post from $date with $numWasteItems waste items',
          onTapHint: 'View the details of this post',
          child: ListTile(
            title: Text(date),
            trailing: Text(numWasteItems),
            onTap: () {
              Navigator.of(context).pushNamed(
                PostDetailsScreen.routeName,
                arguments: postEntry,
              );
            },
            shape: const Border(top: BorderSide()),
          ),
        );
      },
    );
  }

  Widget addPostButton(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: 'Button to select an image to post',
      onTapHint: 'Select an image to post',
      child: LargeButton(
        onPressed: () => Navigator.of(context).pushNamed(NewPostForm.routeName),
        child: const Icon(Icons.photo_library_outlined),
      ),
    );
  }
}
