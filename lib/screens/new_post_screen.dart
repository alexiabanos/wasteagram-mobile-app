import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'list_screen.dart';
import '../widgets/food_waste_post.dart';
import '../widgets/camera_fab.dart';
import '../models/new_post.dart';
import '../db/new_post_dao.dart';

// Class definition for NewPostForm widget
class NewPostForm extends StatefulWidget {
  static const routeName = 'new_post';
  final String title = 'New Post';

  const NewPostForm({Key? key}) : super(key: key);

  // Returns the state for NewPostForm widget
  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final formKey = GlobalKey<FormState>();

  final locationService = Location();

  final picker = ImagePicker();
  Future<XFile?>? pickedFile;
  File? image;

  final postsRef = NewPostDAO.postsRef;
  final postEntryValues = NewPost();

  // Function to initialize state
  @override
  void initState() {
    super.initState();
    retrieveLocation();
    getImage();
  }

  // Retrieve user's location
  void retrieveLocation() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData? locationData;
      _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          debugPrint('Failed to enable service. Returning.');
          return;
        }
      }

      _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          debugPrint('Location service permission not granted. Returning.');
          return;
        }
      }

      locationData = await locationService.getLocation();
      postEntryValues.location = GeoPoint(
        locationData.latitude!,
        locationData.longitude!,
      );
    } on PlatformException catch (e) {
      debugPrint('Error: ${e.toString()}, code: ${e.code}');
    }
  }

  // Get an image from the user's gallery
  void getImage() {
    pickedFile = picker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pickedFile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        Widget child;
        Widget? bottomButton;
        if (snapshot.hasData) {
          image = File(snapshot.data!.path);
          child = ListView(
            shrinkWrap: true,
            children: [
              Image.file(
                image!,
                semanticLabel: 'Your selected image',
              ),
              const SizedBox(height: 10),
              quantityTextField(),
            ],
          );
          bottomButton = uploadButton(context);
        } else if (snapshot.hasError) {
          child = const Center(child: Icon(Icons.photo));
        } else {
          child = const Center(child: CircularProgressIndicator());
        }
        return PostsScaffold(
          title: widget.title,
          body: Form(key: formKey, child: child),
          bottomWidget: bottomButton,
        );
      },
    );
  }

  // Widget for the quantity text field
  Widget quantityTextField() {
    return Semantics(
      textField: true,
      label: 'Text field for number of wasted items',
      onTapHint: 'Enter the number of wasted items as a whole number',
      child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'Number of Wasted Items'),
        style: Theme.of(context).textTheme.headline4,
        onSaved: (value) {
          postEntryValues.quantity = int.parse(value!);
        },
        validator: (value) {
          if (value == null || int.tryParse(value) == null) {
            return ' * Required field';
          }
          return null;
        },
      ),
    );
  }

  Widget uploadButton(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: 'Button to upload your post',
      onTapHint: 'Upload your post',
      child: LargeButton(
        onPressed: () => uploadPost(context),
        child: const Icon(Icons.cloud_upload_outlined),
      ),
    );
  }

  void uploadPost(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      formKey.currentState!.save();
      await uploadImage();
      await postsRef.add(postEntryValues);
      Navigator.of(context).popUntil(
          (route) => route.settings.name == PostsListScreen.routeName);
    }
  }

  Future<void> uploadImage() async {
    postEntryValues.date = DateTime.now();
    if (image != null) {
      String fileName = '${postEntryValues.date!}.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image!);
      await uploadTask;
      postEntryValues.imageURL = await storageReference.getDownloadURL();
    } else {
      postEntryValues.imageURL = 'null';
    }
  }
}
