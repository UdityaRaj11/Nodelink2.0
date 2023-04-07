import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/widgets/chat/message_bubble.dart';

class PersonalMessages extends StatelessWidget {
  final String docId;
  PersonalMessages(this.docId);

  @override
  Widget build(BuildContext context) {
    final authdata = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(authdata!.uid)
          .collection('chats')
          .doc(docId)
          .collection('personalChats')
          .orderBy('creationTime', descending: true)
          .snapshots(),
      builder: (ctx, personalMessagesnapshot) {
        if (personalMessagesnapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = personalMessagesnapshot.data!.docs;
        final userData = FirebaseAuth.instance.currentUser;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['username'],
            chatDocs[index]['userImage'],
            chatDocs[index]['creationTime'],
            chatDocs[index]['userId'] == userData?.uid,
            key: ValueKey(chatDocs[index].reference.id),
          ),
        );
      },
    );
  }
}
