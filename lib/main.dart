// Import required packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';

// Main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the preferred device orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase app
  await Firebase.initializeApp();

  // Run the app
  runApp(const App(title: 'Wasteagram'));
}
