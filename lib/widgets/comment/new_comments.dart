import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewComments extends StatefulWidget {
  final String docId;
  NewComments(this.docId, {Key? key}) : super(key: key);

  @override
  State<NewComments> createState() => _NewCommentsState();
}

class _NewCommentsState extends State<NewComments> {
  final _controller = new TextEditingController();
  var _enteredComment = '';
  Future<void> _addNotification(
    String cause,
    String reqId,
    String postId,
  ) async {
    final time = Timestamp.now();
    final postData = await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docId)
        .get();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(postData['userId'])
        .collection('Notifications')
        .add({
      'reqId': reqId,
      'interactiontime': time,
      'post_Id': postId,
      'cause': cause,
      'type': 'q&a'
    });
  }

  Future<void> _sendComment() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    final postData = await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docId)
        .get();
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docId)
        .collection('QandA')
        .add({
      'text': _enteredComment,
      'creationTime': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    }).then((value) {
      if (postData['userId'] != user.uid) {
        _addNotification(
          ' has posted a question or answer on your Post.',
          user.uid,
          widget.docId,
        );
      }
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
                  labelText: 'Type Here...',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  )),
              onChanged: (value) {
                setState(() {
                  _enteredComment = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.send),
            onPressed: () {
              _enteredComment.trim().isEmpty ? null : _sendComment();
            },
          )
        ],
      ),
    );
  }
}
