import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class NotificationsCard extends StatefulWidget {
  final String reqId;
  final Timestamp time;
  final String cause;
  final String type;
  final String notiId;

  NotificationsCard(
    this.reqId,
    this.time,
    this.cause,
    this.type,
    this.notiId,
  );

  @override
  State<NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {
  Future<void> _deleteNotification() async {
    final authId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(authId)
        .collection('Notifications')
        .doc(widget.notiId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(widget.reqId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          var snapdata = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: const Color.fromARGB(255, 29, 29, 29),
                child: SizedBox(
                  height: 60,
                  width: 400,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image(
                        image: NetworkImage(snapdata!['image_url']),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            snapdata['username'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 208, 208, 208),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.cause,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Color.fromARGB(255, 208, 208, 208),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          widget.cause ==
                                  ' has posted a question or answer on your Post.'
                              ? InkWell(
                                  onTap: () {
                                    _deleteNotification().then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.grey,
                                  ),
                                )
                              : widget.cause == 'Sent you a link Request'
                                  ? InkWell(
                                      onTap: () {
                                        _deleteNotification().then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: const Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.grey,
                                      ),
                                    )
                                  // const Text(
                                  //     'View',
                                  //     style: TextStyle(
                                  //       fontSize: 12,
                                  //       color: Color.fromARGB(255, 205, 17, 4),
                                  //     ),
                                  //   )
                                  : InkWell(
                                      onTap: () => _deleteNotification(),
                                      child: const Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                          const Spacer(),
                          Text(
                            DateFormat('dd-MMM~ HH:mm')
                                .format(widget.time.toDate()),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color.fromARGB(255, 208, 208, 208),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 65, 65, 65),
              ),
            ],
          );
        });
  }
}
