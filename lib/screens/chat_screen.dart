import 'package:flutter/material.dart';
import '/widgets/chat/messages.dart';
import '/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/community-chat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 8),
          child: const Text(
            'Community Chat',
            style: TextStyle(
                color: Color.fromARGB(255, 202, 202, 202), fontSize: 15),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 30, 30)),
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}
