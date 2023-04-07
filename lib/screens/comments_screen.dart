import 'package:flutter/material.dart';
import 'package:nodelink/modal/screen_arguments.dart';
import 'package:nodelink/widgets/comment/comments.dart';
import 'package:nodelink/widgets/comment/new_comments.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);
  static const routeName = '/comments-screen';

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 8),
          child: Text(
            args.title,
            style: const TextStyle(
                color: Color.fromARGB(255, 202, 202, 202), fontSize: 15),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 30, 30)),
        child: Column(
          children: [
            Expanded(
              child: Comments(args.id),
            ),
            NewComments(args.id),
          ],
        ),
      ),
    );
  }
}
