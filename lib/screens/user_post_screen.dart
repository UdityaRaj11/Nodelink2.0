import 'package:flutter/material.dart';
import 'package:nodelink/widgets/posts/user_post.dart';
import '../widgets/posts/post.dart';

class UserPostScreen extends StatefulWidget {
  @override
  State<UserPostScreen> createState() => _UserPostScreenState();

  static const routeName = '/user-post-screen';
}

class _UserPostScreenState extends State<UserPostScreen> {
  Widget build(BuildContext context) {
    final postInex = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 209, 209, 209),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 6,
          ),
          child: const Text(
            'My Contribution',
            style: TextStyle(
                color: Color.fromARGB(255, 239, 239, 239), fontSize: 15),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 30, 30)),
        child: SingleChildScrollView(child: UserPost(postInex)),
      ),
    );
  }
}
