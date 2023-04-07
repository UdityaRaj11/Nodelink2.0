import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/screens/comments_screen.dart';
import 'package:nodelink/screens/people_profile_screen.dart';

class PostCard extends StatefulWidget {
  final String title;
  final String content;
  final String postimageurl;
  final String userImage;
  final String userName;
  final String userId;
  final String docId;
  final bool isMe;
  final Key? key;

  PostCard(
    this.title,
    this.content,
    this.postimageurl,
    this.userImage,
    this.userName,
    this.userId,
    this.docId,
    this.isMe, {
    this.key,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isliked = false;
  bool isloved = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width - 4,
              padding: const EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 1,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 2,
              ),
              child: Card(
                elevation: 7,
                color: const Color.fromARGB(255, 37, 37, 37),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 69, 69, 69)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                PeopleProfileScreen.routeName,
                                arguments:
                                    ScreenArguments('', widget.userId, ''),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 48, 48, 48),
                              radius: 15,
                              backgroundImage: CachedNetworkImageProvider(
                                widget.userImage,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.userName,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 238, 238, 238),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 420,
                        width: 500,
                        child: Card(
                          color: const Color.fromARGB(255, 48, 48, 48),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: CachedNetworkImage(
                            imageUrl: widget.postimageurl,
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 7,
                          margin: const EdgeInsets.all(1),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 222, 222, 222),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Row(
                        children: [
                          Text(
                            '${(widget.content).substring(0, 20)} ${widget.content.length == 20 ? '' : '...'}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 190, 190, 190)),
                          ),
                          const Spacer(),
                          const Text(
                            'Read More',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Card(
                        elevation: 7,
                        color: const Color.fromARGB(255, 29, 29, 29),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 88, 88, 88)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7)),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isliked == false
                                            ? isliked = true
                                            : isliked = false;
                                      });
                                    },
                                    icon: Icon(
                                      isliked == false
                                          ? Icons.thumb_up_alt_outlined
                                          : Icons.thumb_up,
                                      color: const Color.fromARGB(
                                          255, 20, 132, 223),
                                    ),
                                  ),
                                  const Text(
                                    'Like',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 114, 114, 114),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isloved == false
                                            ? isloved = true
                                            : isloved = false;
                                      });
                                    },
                                    icon: Icon(
                                      isloved == false
                                          ? Icons.favorite_border_outlined
                                          : Icons.favorite,
                                      color: const Color.fromARGB(
                                          255, 217, 60, 49),
                                    ),
                                  ),
                                  const Text(
                                    'Love',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 114, 114, 114),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        CommentScreen.routeName,
                                        arguments: ScreenArguments(
                                            widget.title, widget.docId, ''),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.question_answer_outlined,
                                      color: Color.fromARGB(255, 20, 132, 223),
                                    ),
                                  ),
                                  const Text(
                                    'Q&A',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 114, 114, 114),
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              // Column(
                              //   children: [
                              //     IconButton(
                              //       onPressed: () {},
                              //       icon: const Icon(Icons.ios_share_outlined,
                              //           color:
                              //               Color.fromARGB(255, 69, 160, 72)),
                              //     ),
                              //     const Text(
                              //       'Share',
                              //       style: TextStyle(
                              //         color: Color.fromARGB(255, 114, 114, 114),
                              //         fontSize: 10,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
