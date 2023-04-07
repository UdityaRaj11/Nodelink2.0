import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/screens/comments_screen.dart';
import 'package:nodelink/screens/people_profile_screen.dart';

class PostContent extends StatefulWidget {
  final String title;
  final String content;
  final String postImgUrl;
  final String userImg;
  final String userId;
  final String docId;
  String userName;
  Key? key;

  PostContent(
    this.title,
    this.content,
    this.postImgUrl,
    this.userImg,
    this.userName,
    this.userId,
    this.docId, {
    this.key,
  });

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  @override
  Widget build(BuildContext context) {
    final presUserId = FirebaseAuth.instance.currentUser;
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 29, 29, 29),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: MediaQuery.of(context).size.width - 18,
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    presUserId!.uid != widget.userId
                        ? Navigator.of(context).pushNamed(
                            PeopleProfileScreen.routeName,
                            arguments: ScreenArguments('', widget.userId, ''))
                        : null;
                  },
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 48, 48, 48),
                    backgroundImage: CachedNetworkImageProvider(
                      widget.userImg,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 238, 238, 238),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 500,
              width: 600,
              child: Card(
                color: const Color.fromARGB(255, 48, 48, 48),
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: CachedNetworkImage(
                  imageUrl: widget.postImgUrl,
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 7,
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
            Text(
              widget.content,
              style: const TextStyle(color: Color.fromARGB(255, 190, 190, 190)),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.thumb_up_alt_outlined,
                    color: Color.fromARGB(255, 20, 132, 223),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_outlined,
                      color: Color.fromARGB(255, 208, 57, 47)),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      CommentScreen.routeName,
                      arguments: ScreenArguments(
                          widget.title.toString(), widget.docId.toString(), ''),
                    );
                  },
                  icon: const Icon(
                    Icons.question_answer_outlined,
                    color: Color.fromARGB(255, 20, 132, 223),
                  ),
                ),
                const Spacer(),
                // IconButton(
                //   onPressed: () {},
                //   icon:
                //       const Icon(Icons.ios_share_outlined, color: Colors.green),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
