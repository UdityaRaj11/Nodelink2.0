import 'package:flutter/material.dart';

class PeopleGrid extends StatefulWidget {
  final List<String> words;
  PeopleGrid(this.words);

  @override
  State<PeopleGrid> createState() => _PeopleGridState();
}

class _PeopleGridState extends State<PeopleGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0.2,
        mainAxisSpacing: 0.2,
      ),
      itemCount: widget.words.length - 2,
      itemBuilder: (ctx, index) {
        return Container(
          width: 20,
          height: 10,
          child: Chip(
            elevation: 7,
            shadowColor: const Color.fromARGB(255, 32, 32, 32),
            padding: const EdgeInsets.all(1),
            backgroundColor: const Color.fromARGB(255, 27, 27, 27),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(
              widget.words[index],
              style: const TextStyle(
                  fontSize: 9, color: Color.fromARGB(255, 218, 218, 218)),
            ),
          ),
        );
      },
    );
  }
}
