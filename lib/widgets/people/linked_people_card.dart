import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LinkedPeopleCard extends StatefulWidget {
  final String docId;

  LinkedPeopleCard(
    this.docId,
  );

  @override
  State<LinkedPeopleCard> createState() => _LinkedPeopleCardState();
}

class _LinkedPeopleCardState extends State<LinkedPeopleCard> {
  Future<void> deleteFriend() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('userInteraction')
        .doc(widget.docId)
        .delete();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.docId)
        .collection('userInteraction')
        .doc(user.uid)
        .delete();
  }

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
          return Card(
            elevation: 7,
            color: const Color.fromARGB(255, 38, 38, 38),
            child: SizedBox(
              height: 60,
              width: 300,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: NetworkImage(snapdata!['image_url']),
                    width: 50,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    snapdata['username'],
                    style: const TextStyle(
                      color: Color.fromARGB(255, 208, 208, 208),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 10),
                          content: const Text(
                            'Are you sure about removing this link?',
                          ),
                          action: SnackBarAction(
                              label: 'Yes, I am',
                              textColor: Theme.of(context).errorColor,
                              onPressed: () {
                                deleteFriend();
                              }),
                        ),
                      );
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        color: Color.fromARGB(255, 205, 17, 4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
