// Importing the required packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Class representing a new post entry
class NewPost {
  DateTime? date;
  String? imageURL;
  int? quantity;
  GeoPoint? location;

  // Getter for a short string representation of the post's date
  String get dateStringShort => (date != null)
      ? DateFormat('yMMMEd', 'en-US').format(date!)
      : 'No Timestamp';

  // Getter for a long string representation of the post's date
  String get dateStringLong =>
      (date != null) ? DateFormat('yMMMMEEEEd').format(date!) : 'No Timestamp';

  String get quantityString => (quantity != null) ? quantity!.toString() : '0';

  // Getter for a string representation of the post's location
  String get locationString =>
      'Location: ${(location != null) ? '(${location!.latitude}, ${location!.longitude})' : 'Unspecified'}';

  // Constructor for a post entry
  NewPost({this.date, this.imageURL, this.quantity, this.location});

  // Constructor for creating a post entry from a map
  NewPost.fromMap(Map<String, dynamic> map)
      : date = map['date'].toDate(),
        imageURL = map['imageURL'],
        quantity = map['quantity'],
        location = map['location'];

  // Method for creating a map representation of the post entry
  Map<String, Object?> toMap() {
    return {
      'date': date as DateTime,
      'imageURL': imageURL as String,
      'quantity': quantity as int,
      'location': location as GeoPoint,
    };
  }
}
