import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/screens/post_screen.dart';
import 'package:nodelink/widgets/posts/posts_card.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  String? userImageUrl;
  String? userName;
  int? idx;
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

  void selectProfile(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('post')
          .orderBy('creationTime', descending: true)
          .snapshots(),
      builder: (ctx, postSnapshot) {
        if (postSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final postDocs = postSnapshot.data!.docs;
        final userData = FirebaseAuth.instance.currentUser;
        return ListView.builder(
          reverse: false,
          itemCount: postDocs.length,
          itemBuilder: (ctx, index) {
            final docRef = postDocs[index].reference;
            final docId = docRef.id;
            return Column(
              children: [
                const Divider(
                  color: Color.fromARGB(255, 103, 103, 103),
                ),
                InkWell(
                  child: PostCard(
                    postDocs[index]['title'],
                    postDocs[index]['content'],
                    postDocs[index]['post_image_url'],
                    postDocs[index]['user_image'],
                    postDocs[index]['user_name'],
                    postDocs[index]['userId'],
                    docId,
                    postDocs[index]['userId'] == userData?.uid,
                    key: ValueKey(postDocs[index].reference.id),
                  ),
                  onTap: () {
                    setState(() {
                      idx = index;
                    });
                    Navigator.of(context).pushNamed(
                      PostScreen.routeName,
                      arguments: postDocs[index].reference.id,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
