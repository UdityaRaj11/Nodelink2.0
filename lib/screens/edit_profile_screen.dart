import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nodelink/widgets/user/edit_user_form.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? userImageUrl;
  String? userName;
  Future<String> fetchImageUrl() async {
    String imageUrl;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    imageUrl = userData['image_url'];
    return imageUrl;
  }

  Future<String> fetchUsername() async {
    String username;
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    username = userData['username'];
    return username;
  }

  @override
  void initState() {
    super.initState();
    fetchUsername().then(
      (value) {
        setState(() {
          userName = value;
        });
      },
    );
    fetchImageUrl().then((value) {
      setState(() {
        userImageUrl = value;
      });
    });
  }

  var _isLoading = false;
  void _submitPostForm(
    String username,
    String about,
    File image,
    List<String> skills,
    List<String> interests,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final userProf = FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(userProf!.uid + '.jpg');

      await ref.putFile(image);

      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userProf.uid)
          .update({
        'about': about,
        'username': username,
        'image_url': url,
        'skills': skills,
        'interests': interests,
      });
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your inputs!';
      if (err.message != null) {
        message = err.message.toString();
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: EditUserForm(_submitPostForm, _isLoading),
    );
  }
}
