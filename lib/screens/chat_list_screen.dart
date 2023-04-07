import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/screens/personal_chat_screen.dart';
import 'package:nodelink/widgets/people/people_chat_card.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);
  static const routeName = '/chat-list-screen';

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: const Text(
                'Your Chats:',
                style: TextStyle(
                  color: Color.fromARGB(255, 218, 218, 218),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.group_outlined,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
              title: const Text(
                'Community Chat',
                style: TextStyle(
                  color: Color.fromARGB(255, 164, 164, 164),
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/community-chat');
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 116, 116, 116),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.3,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(userId)
                    .collection('userInteraction')
                    .where('Friends', isEqualTo: true)
                    .snapshots(),
                builder: (ctx, LinkedPeopleSnapshot) {
                  if (LinkedPeopleSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final linkedDoc = LinkedPeopleSnapshot.data!.docs;
                  return ListView.builder(
                    reverse: false,
                    itemCount: linkedDoc.length,
                    itemBuilder: (ctx, index) {
                      final docRef = linkedDoc[index].reference;
                      final docId = docRef.id;
                      return PeopleChatCard(
                        docId,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
