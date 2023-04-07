import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CommentsCard extends StatelessWidget {
  final String message;
  final String userName;
  final String userImage;
  final Timestamp creationTime;
  final Key? key;

  CommentsCard(
    this.message,
    this.userName,
    this.userImage,
    this.creationTime, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    var commentDate =
        DateFormat('dd-MMM-yy ~ HH:mm').format(creationTime.toDate());
    return Stack(
      fit: StackFit.loose,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                userImage,
              ),
            ),
            Card(
              color: const Color.fromARGB(255, 37, 37, 37),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                width: MediaQuery.of(context).size.width - 70,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 16,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          commentDate,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 146, 146, 146)),
                        ),
                      ],
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .accentTextTheme
                            .titleMedium!
                            .color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
