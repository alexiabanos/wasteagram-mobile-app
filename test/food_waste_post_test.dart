import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/models/new_post.dart';

void main() {
  // Verifies NewPost object created has correct location values
  test(
    'New post has correct location values',
    () {
      // Set up the required variables and objects for the test
      final DateTime date = DateTime.parse('2022-03-10');
      const String url = 'TEST_URL/new_post';
      const int quantity = 1;
      const GeoPoint location = GeoPoint(1.0, 2.0);

      // Create a NewPost object from the map and verify if it has appropriate values
      final postEntry = NewPost.fromMap({
        'date': Timestamp.fromDate(date),
        'imageURL': url,
        'quantity': quantity,
        'location': location,
      });

      expect(postEntry.date, date);
      expect(postEntry.imageURL, url);
      expect(postEntry.quantity, quantity);
      expect(postEntry.location, location);
    },
  );

  // Verifies dateStringLong function of the NewPost object returns correct format
  test(
    'NewPost object\'s dateStringLong function should return the date as \'WEEKDAY, MONTH DAY, YEAR\'',
    () {
      // Set the default locale for Intl
      Intl.defaultLocale = 'en-US';

      // Create an array of weekday strings to verify the function's output
      final weekdayStrings = [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
      ];

      // Loop through days 6 to 12 of March 2022 and verify if dateStringLong function returns the correct format
      for (int day = 6; day <= 12; ++day) {
        final postEntry = NewPost(
            date: DateTime.parse('2022-03-${day.toString().padLeft(2, '0')}'));
        final expectedString = '${weekdayStrings[day - 6]}, March $day, 2022';
        expect(postEntry.dateStringLong, expectedString);
      }
    },
  );

  // Verifies dateStringShort function of the NewPost object returns correct format
  test(
    'NewPost object\'s dateStringShort function should return the date as \'ABBR_WEEKDAY, ABBR_MONTH DAY, YEAR\'',
    () {
      // Set the default locale for Intl
      Intl.defaultLocale = 'en-US';

      // Create an array of abbreviated weekday strings to verify the function's output
      final abbrWeekdayStrings = [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
      ];

      // Loop through days 6 to 12 of March 2022 and verify if dateStringShort function returns the correct format
      for (int day = 6; day <= 12; ++day) {
        final postEntry = NewPost(
            date: DateTime.parse('2022-03-${day.toString().padLeft(2, '0')}'));
        final expectedString = '${abbrWeekdayStrings[day - 6]}, Mar $day, 2022';
        expect(postEntry.dateStringShort, expectedString);
      }
    },
  );
}
