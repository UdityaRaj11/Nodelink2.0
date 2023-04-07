import 'package:flutter/material.dart';

class UserPostsBlock extends StatelessWidget {
  final String title;
  final String postImgUrl;
  final Key? key;

  UserPostsBlock(this.title, this.postImgUrl, {this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 1),
      width: 300,
      height: 100,
      child: Card(
          child: Column(
        children: [
          Expanded(
            child: Container(
              child: Image.network(
                postImgUrl,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      )),
    );
  }
}
