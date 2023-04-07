import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/screens/people_profile_screen.dart';
import 'package:nodelink/screens/post_screen.dart';
import 'package:nodelink/widgets/people/people_card.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (ctx, Peoplenapshot) {
        if (Peoplenapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final peopleDocs = Peoplenapshot.data!.docs;
        final userData = FirebaseAuth.instance.currentUser;
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: false,
            itemCount: peopleDocs.length,
            itemBuilder: (ctx, index) {
              final docRef = peopleDocs[index].reference;
              final docId = docRef.id;
              return docId != userData!.uid
                  ? InkWell(
                      child: PeopleCard(
                        peopleDocs[index]['username'],
                        peopleDocs[index]['image_url'],
                        (peopleDocs[index]['skills'] as List)
                            .map((e) => e as String)
                            .toList(),
                        (peopleDocs[index]['interests'] as List)
                            .map((e) => e as String)
                            .toList(),
                        key: ValueKey(peopleDocs[index].reference.id),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          PeopleProfileScreen.routeName,
                          arguments: ScreenArguments('', docId, ''),
                        );
                        setState(() {
                          idx = index;
                        });
                        // Navigator.of(context).pushNamed(
                        //   PostScreen.routeName,
                        //   arguments: idx,
                        // );
                      })
                  : Container();
            });
      },
    );
  }
}
