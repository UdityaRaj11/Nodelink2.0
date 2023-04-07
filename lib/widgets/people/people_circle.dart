import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/screens/people_profile_screen.dart';

class PeopleCircle extends StatefulWidget {
  const PeopleCircle({Key? key}) : super(key: key);

  @override
  State<PeopleCircle> createState() => _PeopleCircleState();
}

class _PeopleCircleState extends State<PeopleCircle> {
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
        final PeopleDocs = Peoplenapshot.data!.docs;
        final userData = FirebaseAuth.instance.currentUser;
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000)),
          height: MediaQuery.of(context).size.height / 15,
          width: MediaQuery.of(context).size.width / 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: PeopleDocs.length,
            itemBuilder: (ctx, index) {
              final docRef = PeopleDocs[index].reference;
              final docId = docRef.id;
              return docId != userData!.uid
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          PeopleProfileScreen.routeName,
                          arguments: ScreenArguments('', docId, ''),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 48, 48, 48),
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                              PeopleDocs[index]['image_url']),
                        ),
                      ),
                    )
                  : Container();
            },
          ),
        );
      },
    );
  }
}
