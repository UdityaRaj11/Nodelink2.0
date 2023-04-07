import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPersonalMessages extends StatefulWidget {
  final String docId;
  NewPersonalMessages(this.docId, {Key? key}) : super(key: key);

  @override
  State<NewPersonalMessages> createState() => _NewPersonalMessagesState();
}

class _NewPersonalMessagesState extends State<NewPersonalMessages> {
  final _controller = TextEditingController();
  final authdata = FirebaseAuth.instance.currentUser;
  var _enteredMessage = '';

  Future<void> _sendMessage() async {
    final time = Timestamp.now();
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance
        .collection('user')
        .doc(authdata!.uid)
        .collection('chats')
        .doc(widget.docId)
        .collection('personalChats')
        .add({
      'text': _enteredMessage,
      'creationTime': time,
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    FirebaseFirestore.instance
        .collection('user')
        .doc(widget.docId)
        .collection('chats')
        .doc(authdata!.uid)
        .collection('personalChats')
        .add({
      'text': _enteredMessage,
      'creationTime': time,
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      color: const Color.fromARGB(255, 33, 33, 33),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: _controller,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: const InputDecoration(
                  labelText: 'Send a message...',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  )),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.send),
            onPressed: () {
              _enteredMessage.trim().isEmpty ? null : _sendMessage();
            },
          )
        ],
      ),
    );
  }
}
