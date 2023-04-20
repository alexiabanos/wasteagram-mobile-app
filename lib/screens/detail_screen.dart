import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/food_waste_post.dart';
import '../models/new_post.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({Key? key, required this.title}) : super(key: key);

  // Defining static constant route name
  static const routeName = 'post_details';
  final String title;

  @override
  Widget build(BuildContext context) {
    // Getting postEntry from modal route arguments
    final NewPost postEntry =
        ModalRoute.of(context)!.settings.arguments as NewPost;

    return PostsScaffold(
      title: title,
      body: postDetails(context, postEntry),
    );
  }

  // Function that returns the widget for post details
  Widget postDetails(BuildContext context, NewPost postEntry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Displaying date of post
          Text(
            postEntry.dateStringShort,
            style: Theme.of(context).textTheme.headline4,
          ),
          Builder(
            builder: (BuildContext context) {
              // Checking if image URL is present and not null
              if (postEntry.imageURL != null && postEntry.imageURL != 'null') {
                // Displaying cached image from URL using cached_network_image package
                return CachedNetworkImage(
                  imageUrl: postEntry.imageURL!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                  fadeOutDuration: Duration.zero,
                );
              }
              // Displaying default icon if image URL is null
              return const Icon(Icons.image);
            },
          ),
          // Displaying quantity of items in the post
          Text(
            '${postEntry.quantityString} items',
            style: Theme.of(context).textTheme.headline4,
          ),
          // Displaying location of the post
          Text(postEntry.locationString),
        ],
      ),
    );
  }
}
