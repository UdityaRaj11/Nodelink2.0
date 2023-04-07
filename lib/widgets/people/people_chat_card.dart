import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/screens/personal_chat_screen.dart';

class PeopleChatCard extends StatefulWidget {
  final String docId;

  PeopleChatCard(
    this.docId,
  );

  @override
  State<PeopleChatCard> createState() => _PeopleChatCardState();
}

class _PeopleChatCardState extends State<PeopleChatCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(widget.docId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        var snapdata = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 15,
                backgroundColor: const Color.fromARGB(255, 39, 39, 39),
                backgroundImage: NetworkImage(
                  snapdata!['image_url'],
                ),
              ),
              title: Text(
                snapdata['username'],
                style: const TextStyle(
                  color: Color.fromARGB(255, 164, 164, 164),
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                  PersonalChatScreen.routeName,
                  arguments: ScreenArguments(
                    snapdata['username'],
                    widget.docId,
                    snapdata['image_url'],
                  ),
                );
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 116, 116, 116),
            ),
          ],
        );
      },
    );
  }
}
