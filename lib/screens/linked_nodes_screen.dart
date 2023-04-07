import 'package:flutter/material.dart';
import 'package:nodelink/widgets/people/linked_people.dart';
import '../widgets/posts/post.dart';

class LinkedNodesScreen extends StatefulWidget {
  const LinkedNodesScreen({Key? key}) : super(key: key);

  static const routeName = '/linked-nodes';
  @override
  State<LinkedNodesScreen> createState() => _LinkedNodesScreenState();
}

class _LinkedNodesScreenState extends State<LinkedNodesScreen> {
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
          'Linked Nodes',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 30, 30)),
        child: Column(
          children: [
            Expanded(
              child: LinkedPeople(),
            ),
          ],
        ),
      ),
    );
  }
}
