import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/screens/people_profile_screen.dart';
import 'package:nodelink/screens/post_screen.dart';
import 'package:nodelink/widgets/notifications/notifications_card.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  void selectProfile(BuildContext context) {}
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('Notifications')
          .orderBy('interactiontime', descending: true)
          .snapshots(),
      builder: (ctx, notificationsSnapshot) {
        if (notificationsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final notiDoc = notificationsSnapshot.data!.docs;

        return notificationsSnapshot.data!.size == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.update_disabled_outlined,
                      size: 150,
                      color: Color.fromARGB(255, 58, 58, 58),
                    ),
                    Text(
                      'No Notifications Yet!',
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
                itemCount: notiDoc.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    child: NotificationsCard(
                      notiDoc[index]['reqId'],
                      notiDoc[index]['interactiontime'],
                      notiDoc[index]['cause'],
                      notiDoc[index]['type'],
                      notiDoc[index].reference.id,
                    ),
                    onTap: () {
                      if (notiDoc[index]['type'] == 'q&a') {
                        Navigator.of(context).pushNamed(
                          PostScreen.routeName,
                          arguments: notiDoc[index]['post_Id'],
                        );
                      } else {
                        Navigator.of(context).pushNamed(
                          PeopleProfileScreen.routeName,
                          arguments:
                              ScreenArguments('', notiDoc[index]['reqId'], ''),
                        );
                      }
                    },
                  );
                },
              );
      },
    );
  }
}
