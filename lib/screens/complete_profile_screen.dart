import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nodelink/widgets/user/complete_user_form.dart';
import 'package:nodelink/widgets/user/edit_user_form.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/complete-profile';

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  var _isLoading = false;
  void _submitPostForm(
    String about,
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

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userProf!.uid)
          .update({
        'about': about,
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
      body: CompleteUserForm(_submitPostForm, _isLoading),
    );
  }
}
