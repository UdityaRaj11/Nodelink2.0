import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nodelink/screens/people_profile_screen.dart';
import '/modal/screen_arguments.dart';
import '/widgets/chat/new_personal_messages.dart';
import '/widgets/chat/personal_messages.dart';

class PersonalChatScreen extends StatefulWidget {
  const PersonalChatScreen({Key? key}) : super(key: key);
  static const routeName = '/personal-chat-screen';

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
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
          child: Text(
            args.title,
            style: const TextStyle(
                color: Color.fromARGB(255, 202, 202, 202), fontSize: 15),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  PeopleProfileScreen.routeName,
                  arguments: ScreenArguments('', args.id, ''),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(args.img),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 20,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 30, 30)),
        child: Column(
          children: [
            Expanded(
              child: PersonalMessages(args.id),
            ),
            NewPersonalMessages(args.id),
          ],
        ),
      ),
    );
  }
}
