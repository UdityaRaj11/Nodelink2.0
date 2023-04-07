import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/screens/people_profile_screen.dart';
import 'package:nodelink/widgets/people/linked_people_card.dart';
import 'package:nodelink/widgets/posts/posts_card.dart';

class LinkRequests extends StatefulWidget {
  const LinkRequests({Key? key}) : super(key: key);

  @override
  State<LinkRequests> createState() => _LinkRequestsState();
}

class _LinkRequestsState extends State<LinkRequests> {
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

  Future<bool> ifExists(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('userInteraction')
        .doc(docId)
        .get();
    bool isDocExists = docSnapshot.exists;
    return isDocExists;
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
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('userInteraction')
          .where('Got Request', isEqualTo: true)
          .snapshots(),
      builder: (ctx, linkRequestsSnapshot) {
        if (linkRequestsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final linkedDoc = linkRequestsSnapshot.data!.docs;
        return linkRequestsSnapshot.data!.size == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.hourglass_empty_outlined,
                      size: 150,
                      color: Color.fromARGB(255, 58, 58, 58),
                    ),
                    Text(
                      'Waiting for Nodes\' Requests.',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 58, 58, 58),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                reverse: false,
                itemCount: linkedDoc.length,
                itemBuilder: (ctx, index) {
                  final docRef = linkedDoc[index].reference;
                  final docId = docRef.id;
                  return InkWell(
                    child: LinkedPeopleCard(
                      docId,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        PeopleProfileScreen.routeName,
                        arguments: ScreenArguments('', docId, ''),
                      );
                    },
                  );
                },
              );
      },
    );
  }
}
