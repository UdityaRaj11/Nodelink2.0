import 'package:flutter/material.dart';

class GridDisplay extends StatefulWidget {
  final List<String> words;
  GridDisplay(this.words);

  @override
  State<GridDisplay> createState() => _GridDisplayState();
}

class _GridDisplayState extends State<GridDisplay> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: widget.words.length,
      itemBuilder: (ctx, index) {
        return Container(
          width: 100,
          height: 20,
          child: Chip(
            backgroundColor: const Color.fromARGB(255, 35, 35, 35),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(
              widget.words[index],
              style: const TextStyle(
                  fontSize: 8, color: Color.fromARGB(255, 218, 218, 218)),
            ),
          ),
        );
      },
    );
  }
}
