import 'package:flutter/material.dart';
import 'package:nodelink/widgets/people/link_request.dart';
import 'package:nodelink/widgets/people/linked_people.dart';
import '../widgets/posts/post.dart';

class LinkRequestsScreen extends StatefulWidget {
  const LinkRequestsScreen({Key? key}) : super(key: key);

  static const routeName = '/link-Requests';
  @override
  State<LinkRequestsScreen> createState() => _LinkRequestsScreenState();
}

class _LinkRequestsScreenState extends State<LinkRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 209, 209, 209),
          ),
        ),
        title: const Text(
          'Link Requests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 30, 30)),
        child: Column(
          children: [
            Expanded(
              child: LinkRequests(),
            ),
          ],
        ),
      ),
    );
  }
}
