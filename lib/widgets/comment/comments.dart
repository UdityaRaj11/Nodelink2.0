import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/widgets/comment/comments_card.dart';

class Comments extends StatelessWidget {
  final String docId;
  Comments(this.docId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('post')
          .doc(docId)
          .collection('QandA')
          .orderBy('creationTime', descending: true)
          .snapshots(),
      builder: (ctx, commentSnapshot) {
        if (commentSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final commentDocs = commentSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: commentDocs.length,
          itemBuilder: (ctx, index) => CommentsCard(
            commentDocs[index]['text'],
            commentDocs[index]['username'],
            commentDocs[index]['userImage'],
            commentDocs[index]['creationTime'],
            key: ValueKey(commentDocs[index].reference.id),
          ),
        );
      },
    );
  }
}
