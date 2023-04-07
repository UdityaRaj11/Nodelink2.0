import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/screens/post_screen.dart';
import 'package:nodelink/widgets/user/user_posts_blocks..dart';

class PeoplePosts extends StatefulWidget {
  final String uid;
  PeoplePosts(this.uid);

  @override
  State<PeoplePosts> createState() => _PeoplePostsState();
}

class _PeoplePostsState extends State<PeoplePosts> {
  String? userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('post')
            .orderBy('creationTime')
            .where(
              'userId',
              isEqualTo: widget.uid,
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
                    Navigator.of(context).pushNamed(
                      PostScreen.routeName,
                      arguments: postDocs[index].reference.id,
                    );
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
