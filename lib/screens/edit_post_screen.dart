import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nodelink/widgets/posts/posts_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-posts-screen';

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
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
    String title,
    String content,
    File image,
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
          .child('posts_images')
          .child(userProf!.uid + time + '.jpg');

      await ref.putFile(image);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('post')
          .doc(userProf.uid + time)
          .set({
        'content': content,
        'title': title,
        'post_image_url': url,
        'user_image': userImageUrl,
        'user_name': userName,
        'creationTime': Timestamp.now(),
        'userId': userProf.uid,
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
      body: PostsForm(_submitPostForm, _isLoading),
    );
  }
}
