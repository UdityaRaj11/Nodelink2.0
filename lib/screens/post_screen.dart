import 'package:flutter/material.dart';
import '../widgets/posts/post.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  static const routeName = '/post-screen';
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    final postInex = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 209, 209, 209),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 5.5),
          child: const Text(
            'Contribution',
            style: TextStyle(
                color: Color.fromARGB(255, 239, 239, 239), fontSize: 15),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 30, 30)),
        child: Column(
          children: [
            Expanded(
              child: Post(postInex),
            ),
          ],
        ),
      ),
    );
  }
}
