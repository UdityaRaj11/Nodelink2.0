import 'package:flutter/material.dart';
import 'package:nodelink/widgets/people/people.dart';
import 'package:nodelink/widgets/people/people_circle.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);
  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.all(
        MediaQuery.of(context).devicePixelRatio * 5,
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceWidth = mediaQuery.size.width;
    final deviceHeight = mediaQuery.size.height;
    final size = mediaQuery.devicePixelRatio;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 30, 30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(
              top: deviceHeight / 30,
            )),
            Padding(
              padding: EdgeInsets.only(left: size * 8),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Search Nodes to ',
                  style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: size * 8,
              ),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Create Connections!',
                  style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSectionTitle(context, 'Preferred Nodes'),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 75, 75, 75), width: 2),
                    ),
                    child: Text(
                      'See all',
                      style: TextStyle(
                          fontSize: mediaQuery.textScaleFactor * 10,
                          color: const Color.fromARGB(255, 75, 75, 75)),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: People(),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSectionTitle(context, 'Nearby Nodes'),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 75, 75, 75), width: 2),
                    ),
                    child: Text(
                      'See all',
                      style: TextStyle(
                          fontSize: mediaQuery.textScaleFactor * 10,
                          color: const Color.fromARGB(255, 75, 75, 75)),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const PeopleCircle(),
          ],
        ),
      ),
    );
  }
}
