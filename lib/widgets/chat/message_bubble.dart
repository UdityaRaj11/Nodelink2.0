import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userName;
  final String userImage;
  final Timestamp creationTime;
  final Key? key;

  MessageBubble(
    this.message,
    this.userName,
    this.userImage,
    this.creationTime,
    this.isMe, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    var sentdate =
        DateFormat('dd-MMM-yy ~ HH:mm').format(creationTime.toDate());
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isMe
                ? Text(
                    sentdate,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 160, 160, 160)),
                  )
                : CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      userImage,
                    ),
                  ),
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? const Color.fromARGB(255, 37, 37, 37)
                    : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              width: MediaQuery.of(context).size.width - 180,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color:
                          Theme.of(context).accentTextTheme.titleMedium!.color,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
            !isMe
                ? Text(
                    sentdate,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 160, 160, 160)),
                  )
                : Container(),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
