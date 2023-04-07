import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/screens/post_screen.dart';
import 'package:nodelink/screens/user_post_screen.dart';
import 'package:nodelink/widgets/user/user_posts_blocks..dart';
import '/widgets/chat/message_bubble.dart';

class UserPosts extends StatefulWidget {
  UserPosts({Key? key}) : super(key: key);

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  String? userId;
  int? idx;
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

  void selectProfile(BuildContext context) {
    Navigator.of(context).pushNamed(
      UserPostScreen.routeName,
      arguments: idx,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              shrinkWrap: true,
              reverse: true,
              itemCount: postDocs.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      idx = index;
                    });
                    selectProfile(context);
                  },
                  child: UserPostsBlock(
                    postDocs[index]['title'],
                    postDocs[index]['post_image_url'],
                    key: ValueKey(postDocs[index].reference.id),
                  ),
                );
              });
        });
  }
}
