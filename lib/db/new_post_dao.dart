import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/new_post.dart';

// Class to interact with the Firestore collection 'posts'
class NewPostDAO {
  static final NewPostDAO _instance = NewPostDAO._internal();
  static final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts').withConverter<NewPost>(
            // Converter to convert Firestore DocumentSnapshot to NewPost object
            fromFirestore: (snapshot, _) => NewPost.fromMap(snapshot.data()!),
            toFirestore: (post, _) => post.toMap(),
          );

  factory NewPostDAO() => _instance;

  // Getter method to access the static CollectionReference _postsRef
  static CollectionReference get postsRef => _postsRef;

  NewPostDAO._internal();
}
