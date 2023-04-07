import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/widgets/comment/comments.dart';
import 'package:nodelink/widgets/comment/new_comments.dart';
import 'package:nodelink/widgets/posts/post_content.dart';

class UserPost extends StatefulWidget {
  int? postIndex;

  UserPost(this.postIndex);

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  String? userId;
  Future<String> GetuserId() async {
    String userid;
    final userData = FirebaseAuth.instance.currentUser;
    userid = userData!.uid;
    return userid;
  }

  @override
  void initState() {
    super.initState();
    GetuserId().then(
      (value) {
        setState(() {
          userId = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postIndex = ModalRoute.of(context)!.settings.arguments as int;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('post')
          .orderBy('creationTime')
          .where(
            'userId',
            isEqualTo: userId,
          )
          .snapshots(),
      builder: (ctx, postSnapshot) {
        if (postSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final postDocs = postSnapshot.data!.docs;
        final docRef = postDocs[postIndex].reference;
        final docId = docRef.id;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PostContent(
              postDocs[postIndex]['title'],
              postDocs[postIndex]['content'],
              postDocs[postIndex]['post_image_url'],
              postDocs[postIndex]['user_image'],
              postDocs[postIndex]['user_name'],
              postDocs[postIndex]['userId'],
              docId,
              key: ValueKey(postDocs[postIndex].reference.id),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
