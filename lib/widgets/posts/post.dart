import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/widgets/posts/post_content.dart';
import 'package:nodelink/widgets/posts/posts_card.dart';

class Post extends StatefulWidget {
  String postIndex;

  Post(this.postIndex);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    final postIndex = ModalRoute.of(context)!.settings.arguments as String;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('post')
          .doc(postIndex)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<DocumentSnapshot> postSnapshot) {
        var postDocs = postSnapshot.data;
        if (postSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return PostContent(
          postDocs!['title'],
          postDocs['content'],
          postDocs['post_image_url'],
          postDocs['user_image'],
          postDocs['user_name'],
          postDocs['userId'],
          postIndex,
          key: ValueKey(postIndex),
        );
      },
    );
  }
}
